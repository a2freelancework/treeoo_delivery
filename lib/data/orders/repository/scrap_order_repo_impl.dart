// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/core/errors/exceptions.dart';
import 'package:treeo_delivery/core/errors/failures.dart';
import 'package:treeo_delivery/core/utils/type_def.dart';
import 'package:treeo_delivery/data/orders/data_source/scrap_order_local_data_src.dart';
import 'package:treeo_delivery/data/orders/data_source/scrap_orders_remote_src.dart';
import 'package:treeo_delivery/data/orders/model/invoiced_scrap.dart';
import 'package:treeo_delivery/data/orders/model/scrap_model.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/domain/orders/repository/scrap_order_repo.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/orderdetails.dart';

class ScrapOrderRepoImpl implements ScrapOrderRepo {
  const ScrapOrderRepoImpl({
    required OrderRemoteDataSrc remoteDataSrc,
    required OrderLocalDataSrc localDataSrc,
  })  : _remotSrc = remoteDataSrc,
        _localSrc = localDataSrc;

  final OrderRemoteDataSrc _remotSrc;
  final OrderLocalDataSrc _localSrc;
  @override
  ScrapOrderStream getAllOrders(int page) => _remotSrc.getAllOrders(page);

  @override
  Stream<Iterable<ScrapOrder>> getAllPendingAssignedOrders(
    String? searchText,
  ) => _remotSrc.getAllPendingAssignedOrders(searchText);

  @override
  FutureScrapOrders getTodaysPendingOrders() async {
    throw UnimplementedError();
    // final today = DateTime.now();
    // try {
    //   final newDate = await _checkOrderUpdated();
    //   if (newDate == null) {
    //     // both server and cached date are equel
    //     final cacheResult = await _localSrc.fetchOrdersFromCache();
    //     if (cacheResult != null) {
    //       final todaysOrder = cacheResult.where(
    //         (order) => order.pickupDate.isLessThanOrEquel(today),
    //       );
    //       return Right(todaysOrder);
    //     } // else means failed to fetch from cache
    //   }

    //   final assignedPendingOrder =
    //       await _remotSrc.getAllPendingAssignedOrders();
    //   await _localSrc.saveAssignedPendingOrderLocally(
    //     orders: assignedPendingOrder,
    //     date: newDate,
    //   );
    //   final todaysOrder = assignedPendingOrder.where(
    //     (order) => order.pickupDate.isLessThanOrEquel(today),
    //   );
    //   return Right(todaysOrder);
    // } on ServerException catch (e) {
    //   return Left(ServerFailure.fromException(e));
    // } on CacheException catch (e) {
    //   return Left(
    //     CacheFailure(
    //       message: e.message,
    //       statusCode: e.statusCode,
    //     ),
    //   );
    // } catch (e) {
    //   debugPrint(' ======= todaysPendingOrders $e ======= ');
    //   return Left(CacheFailure.fromException());
    // }
  }

  @override
  Future<Either<Failure, InvoicedScrap>> getInvoicedScrapData(String id) async {
    try {
      final result = await _remotSrc.getInvoicedScrapData(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  StreamCollections getCollection(ScrapType type) =>
      _remotSrc.getLast7daysMyCollection(type);

  @override
  FutureVoid cancelOrder({
    required String id,
    required String invoicedScrapRefId,
    required String reason,
  }) async {
    try {
      await _remotSrc.cancelOrder(
        id: id,
        reason: reason,
        invoicedScrapRefId: invoicedScrapRefId,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  FutureVoid completeOrder({required ScrapOrder order}) async {
    try {
      // final myCollection =
       await _remotSrc.completeOrder(
        order: order as ScrapOrderModel,
      );
      // await Future.wait([
      //   _localSrc.saveMyCollectionLocally(
      //     type: CollectionSavingType.addOn,
      //     collection: myCollection,
      //   ),
      //   _localSrc.refreshOrder(),
      // ]);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  // ignore: unused_element
  Future<int?> _checkOrderUpdated() async {
    final dates = await Future.wait([
      _localSrc.getOrderUpdatedDate(),
      _remotSrc.getOrderUpdatedDate(),
    ]).then((value) => (cache: value[0], server: value[1]));

    debugPrint('_checkOrderUpdated: '
        'CACHEDDATE ${dates.cache} ==||== SERVERDATE ${dates.server}');
    return dates.server != null &&
            dates.cache != null &&
            dates.server == dates.cache
        ? null
        : dates.server;
  }

  @override
  FutureVoid rescheduleOrder({
    required DateTime date,
    required String id,
  }) async {
    try {
      await _remotSrc.rescheduleOrder(date: date, id: id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, List<ScrapModel>>> getAllScrap() async {
    final recentlyUpdatedDate = await _checkScrapItemsUpdated();

    if (recentlyUpdatedDate != null) {
      try {
        final result = await _getDataFromServer(recentlyUpdatedDate);
        return Right(result);
      } on ServerException catch (e) {
        return Left(ServerFailure.fromException(e));
      }
    } else {
      try {
        final result = await _localSrc.getScrapItemFromCache();
        if (result != null) {
          debugPrint('--------- DATA FETCHED FROM CACHE ---------');
          return Right(result);
        } else {
          final result = await _getDataFromServer();
          return Right(result);
        }
      } on ServerException catch (e) {
        return Left(ServerFailure.fromException(e));
      }
    }
  }

  Future<int?> _checkScrapItemsUpdated() async {
    final cachedDate = _localSrc.getScrapLastUpdatedCachedDate();
    final serverDate = await _remotSrc.getScrapUpdatedDate();
    debugPrint('_checkScrapItemsUpdated: '
        'CACHEDDATE $cachedDate <---> SERVERDATE $serverDate');
    return serverDate != null && cachedDate != null && serverDate == cachedDate
        ? null
        : serverDate;
  }

  Future<List<ScrapModel>> _getDataFromServer(
      [int? recentlyUpdatedDate]) async {
    final result = await _remotSrc.getAllScrap();
    debugPrint('--------- DATA FETCHED FROM SERVER ---------');
    _cacheData(scraps: result, date: recentlyUpdatedDate);
    return result;
  }

  void _cacheData({
    required List<ScrapModel> scraps,
    int? date,
  }) {
    _localSrc.cacheScrapAndCategory(scraps);
    if (date != null) {
      debugPrint('cacheScrapLastUpdatedDate $date');
      _localSrc.cacheScrapLastUpdatedDate(date);
    }
  }

  @override
  FutureVoid updateOrderStatus({
    required String id,
    required OrderStatus status,
    String? invoicedScrapRefId,
    String? reson,
    DateTime? reschedule,
  }) async {
    try {
      await _remotSrc.updateOrderStatus(
        id: id,
        status: status,
        invoicedScrapRefId: invoicedScrapRefId,
        reason: reson,
        reschedule: reschedule,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(
        ServerFailure(
          message: e.message,
          statusCode: e.statusCode,
        ),
      );
    }
  }
  
}

extension on DateTime {
  // ignore: unused_element
  bool isLessThanOrEquel(DateTime date) =>
      day <= date.day && month <= date.month && year <= date.year;
}

// ignore_for_file: lines_longer_than_80_chars, constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/core/errors/exceptions.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/core/utils/string_constants.dart';
import 'package:treeo_delivery/core/utils/type_def.dart'
    show ScrapOrderStream, StreamCollections;
import 'package:treeo_delivery/data/orders/model/collected_item.dart';
import 'package:treeo_delivery/data/orders/model/collection_model.dart';
import 'package:treeo_delivery/data/orders/model/invoiced_scrap.dart';
import 'package:treeo_delivery/data/orders/model/scrap_model.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';
import 'package:treeo_delivery/domain/orders/orders_const_info.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/orderdetails.dart';

abstract class OrderRemoteDataSrc {
  const OrderRemoteDataSrc();

  Stream<Iterable<ScrapOrderModel>> getAllPendingAssignedOrders(
    String? searchText,
  );

  ScrapOrderStream getAllOrders(int page);
  Future<Iterable<ScrapOrderModel>> searchAllOrders(int page);

  Future<int?> getOrderUpdatedDate();

  StreamCollections getLast7daysMyCollection(ScrapType type);

  Future<void> cancelOrder({
    required String id,
    required String reason,
    required String invoicedScrapRefId,
  });

  Future<void> updateOrderStatus({
    required String id,
    required OrderStatus status,
    String? invoicedScrapRefId,
    String? reason,
    DateTime? reschedule,
  });

  Future<void> completeOrder({required ScrapOrderModel order});

  Future<InvoicedScrap> getInvoicedScrapData(String id);

  Future<void> rescheduleOrder({
    required DateTime date,
    required String id,
  });

  Future<int?> getScrapUpdatedDate();
  Future<List<ScrapModel>> getAllScrap();
}

const _orderUpdated = 'ASSIGNED_ORDER_UPDATED';
const _staffCol = 'staff_details';
const _staffControlCol = 'staff_order_controller';
const _invoiceCol = 'invoice';
const _invoicedScrapCol = 'invoiced_scrap';

const _myScrapCollTbl = 'my_collection';
const _dailyTotalScrapColTbl = 'daily_total_collection';

const _myWastCollTbl = 'my_waste_collection';
const _dailyTotalWasteColTbl = 'daily_total_waste_collection';

const _treeooStatusControlCollection = 'treeoo_status_control';
const _treeooStatusControlDoc = 'ADMIN';
const _scrapItemCollection = 'scrap_items';

typedef DocRef = DocumentReference<Map<String, dynamic>>;

class OrderRemoteDataSrcImpl extends OrderRemoteDataSrc {
  OrderRemoteDataSrcImpl({
    required FirebaseFirestore fireStore,
    required UserAuth userAuth,
  })  : _fs = fireStore,
        _auth = userAuth;

  final FirebaseFirestore _fs;
  final UserAuth _auth;

  @override
  ScrapOrderStream getAllOrders(int page) => _fs
      .collection(_invoiceCol)
      .where('assigned_staff_id', isEqualTo: _auth.currentUser!.staffId)
      .orderBy('created_at', descending: true)
      .limit(ordersPerPage * page)
      .snapshots()
      .map(
        (querySnap) => querySnap.docs.map(
          ScrapOrderModel.fromQueryMap,
        ),
      );

  @override
  Future<Iterable<ScrapOrderModel>> searchAllOrders(int page) {
    throw UnimplementedError();
  }

  @override
  Stream<Iterable<ScrapOrderModel>> getAllPendingAssignedOrders(
    String? searchText,
  ) {
    final date = DateTime.now();
    var query = _fs
        .collection(_invoiceCol)
        .where('assigned_staff_id', isEqualTo: _auth.currentUser!.staffId)
        .where('pickup_date', isLessThan: date)
        .where(
      'status',
      whereIn: [
        OrderStatusConst.PROCESSING,
        OrderStatusConst.RESCHEDULED,
        OrderStatusConst.ONWAY,
      ],
    );
    if (searchText != null && searchText.trim().isNotEmpty) {
      query = query.where(
        'order_id',
        isGreaterThanOrEqualTo: searchText.trim().toUpperCase(),
      );
    }
    return query.snapshots().map(
          (querySnapshote) =>
              querySnapshote.docs.map(ScrapOrderModel.fromQueryMap),
        );
  }

  @override
  Future<InvoicedScrap> getInvoicedScrapData(String id) async {
    try {
      debugPrint(id);
      final result = await _fs
          .collection(_invoicedScrapCol)
          .where('invoiceId', isEqualTo: id)
          .get()
          .then(
            (value) => InvoicedScrap.fromDocMap(value.docs.first),
          );
      return result;
    } on FirebaseException catch (e) {
      debugPrint(' ==ERROR FirebaseException getInvoicedScrapData: $e === ');
      throw ServerException(
        message: e.message ?? 'Something went wrong',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(' ==ERROR getInvoicedScrapData: $e ======= ');
      debugPrint('$s');
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<int?> getOrderUpdatedDate() async {
    try {
      final path = '$_staffCol/${_auth.currentUser!.uid}/$_staffControlCol';
      // debugPrint('*****************************');
      // debugPrint(' ======= $path ======= ');
      // debugPrint('*****************************');
      final date =
          await _fs.collection(path).doc(_orderUpdated).get().then((docSnap) {
        debugPrint(docSnap.data().toString());
        return (docSnap.data()!['date'] as Timestamp).toDate();
      });
      // debugPrint('ooooooooooooooo $date');
      return date.millisecondsSinceEpoch;
    } catch (e) {
      debugPrint(' ==== orderUpdatedDate(): $e ==== ');
      return null;
    }
  }

  @override
  StreamCollections getLast7daysMyCollection(ScrapType type) {
    var path = '';
    try {
      final tbl = type == ScrapType.scrap ? _myScrapCollTbl : _myWastCollTbl;
      path = '$_staffCol/${_auth.currentUser!.uid}/$tbl';
    } catch (e) {
      debugPrint(e.toString());
    }
    return _fs
        .collection(path)
        .orderBy(FieldPath.documentId,descending: true)
        .limitToLast(7)
        .snapshots()
        .map(
          (snap) => snap.docs.map(
            (qMap) => CollectionModel.fromQueryMap(qMap, type),
          ),
        );
  }

  @override
  Future<int?> getScrapUpdatedDate() async {
    try {
      final timestamp = await _fs
          .collection(_treeooStatusControlCollection)
          .doc(_treeooStatusControlDoc)
          .get()
          .then(
            (value) => value.data()?['scrap_updated'] as Timestamp?,
          );
      return timestamp?.millisecondsSinceEpoch;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<ScrapModel>> getAllScrap() async {
    try {
      final scrapQueryList = await _fs
          .collection(_scrapItemCollection)
          .where('deleted_at', isEqualTo: '')
          .get()
          .then((value) => value.docs);
      return scrapQueryList.map(ScrapModel.fromQueryMap).toList();
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> cancelOrder({
    required String id,
    required String reason,
    required String invoicedScrapRefId,
  }) async {
    try {
      final invoiceRef = _fs.collection(_invoiceCol).doc(id);
      final invoicedScrapRef =
          _fs.collection(_invoicedScrapCol).doc(invoicedScrapRefId);
      await _fs.runTransaction((transaction) async {
        transaction
          ..update(invoicedScrapRef, {
            'reasonToCancel': reason,
          })
          ..update(invoiceRef, {
            'status': OrderStatusConst.CANCELLED,
          });
      }).then((value) => debugPrint('===== ORDER CANCELLED ===='));
    } on FirebaseException catch (e) {
      debugPrint(' ======= cancelOrder: $e ======= ');
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    }
  }

  @override
  Future<void> rescheduleOrder({
    required DateTime date,
    required String id,
  }) async {
    try {
      final dataToUpdate = {
        'pickup_date': date,
        // 'status': OrderStatusConst.PENDING,
      };
      await _fs.collection(_invoiceCol).doc(id).update(dataToUpdate);
    } on FirebaseException catch (e) {
      debugPrint('==== assignedPendingOrders(): $e ==== ');
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> updateOrderStatus({
    required String id,
    required OrderStatus status,
    String? invoicedScrapRefId,
    String? reason,
    DateTime? reschedule,
  }) async {
    final dataToUpdate = <String, Object>{};
    const k_status = 'status';
    const pickup_date = 'pickup_date';
    var updateToInvoicedScrap = false;

    try {
      switch (status) {
        case OrderStatus.onWay:
          dataToUpdate[k_status] = OrderStatusConst.ONWAY;

        case OrderStatus.reschedule:
          dataToUpdate[k_status] = OrderStatusConst.RESCHEDULED;
          dataToUpdate[pickup_date] = reschedule!;

        case OrderStatus.dropOrder:
          dataToUpdate[k_status] = OrderStatusConst.DROPPED;
          updateToInvoicedScrap = true;

        case OrderStatus.cancelOrder:
          dataToUpdate[k_status] = OrderStatusConst.CANCELLED;
          updateToInvoicedScrap = true;

        case OrderStatus.onProgress:
          return;
      }

      final invoiceRef = _fs.collection(_invoiceCol).doc(id);
      final invoicedScrapRef =
          _fs.collection(_invoicedScrapCol).doc(invoicedScrapRefId);

      await _fs.runTransaction((transaction) async {
        if (updateToInvoicedScrap) {
          transaction.update(invoicedScrapRef, {
            'reasonToCancel': reason ?? '',
          });
        }
        transaction.update(invoiceRef, dataToUpdate);
      }).then((value) => debugPrint('===== ORDER UPDATE ===='));
    } on FirebaseException catch (e) {
      debugPrint('==== updateOrderStatus(): $e ==== ');
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> completeOrder({
    required ScrapOrderModel order,
  }) async {
    try {
      final now = DateTime.now();
      final today = now.dateOnly.millisecondsSinceEpoch;
      final (myColRef, dailyColRef) = findCollRef(today, order.type);
      final invoiceRef = _fs.collection(_invoiceCol).doc(order.id);
      final invoicedScrapRef = _fs
          .collection(_invoicedScrapCol)
          .doc(order.invoicedScraps!.scrapRefId);
      await _fs.runTransaction((tr) async {
        final myColl = await tr.get(myColRef).then(
          (snap) {
            if (snap.data() != null) {
              return CollectionModel.fromDocMap(snap, order.type);
            } else {
              return null;
            }
          },
        );
        final totalColl = await tr.get(dailyColRef).then(
          (snap) {
            if (snap.data() != null) {
              return CollectionModel.fromDocMap(snap, order.type);
            } else {
              return null;
            }
          },
        );

        final myCollUpdated = _createOrUpdateCollection(
          order: order,
          collection: myColl,
          date: today,
        );
        final totalCollUpdated = _createOrUpdateCollection(
          order: order,
          collection: totalColl,
          date: today,
        );

        final invoiceToUpdate = {
          'address': order.address,
          'status': OrderStatusConst.COMPLETED,
          'service_charge': order.serviceCharge,
          'round_off_amt': order.roundOffAmt,
          'amt_payable': order.amtPayable,
          'completed_date': now,
        };
        final myCollMap = {
          'date': today,
          'items': myCollUpdated.items.map((e) => e.toMap()).toList(),
          'total_service_charge': myCollUpdated.totalServiceCharge,
          'total_round_off': myCollUpdated.totalRoundOff,
          'total_qty': myCollUpdated.totalQty,
          'total_paid_amt': myCollUpdated.totalPaidAmt,
        };
        final totalCollMap = {
          'date': today,
          'items': totalCollUpdated.items.map((e) => e.toMap()).toList(),
          'total_service_charge': totalCollUpdated.totalServiceCharge,
          'total_round_off': totalCollUpdated.totalRoundOff,
          'total_qty': totalCollUpdated.totalQty,
          'total_paid_amt': totalCollUpdated.totalPaidAmt,
        };
        final invoicedScrapToUpdate = {
          'invoiceId': order.invoicedScraps!.invoiceId,
          'scrap_list': order.invoicedScraps!.scraps.map((e) => e.toMap()),
        };

        tr
          ..update(invoiceRef, invoiceToUpdate)
          ..set(myColRef, myCollMap)
          ..set(dailyColRef, totalCollMap)
          ..set(invoicedScrapRef, invoicedScrapToUpdate);
      }).then((value) => debugPrint('ORDER UPDATED SUCCESSFULLY $value'));
    } on FirebaseException catch (e, s) {
      debugPrint(' ==FirebaseException ERROR == completeOrder: $e ==');
      debugPrint('$s');
      throw ServerException(
        message: e.message ?? 'Error Occurred',
        statusCode: e.code,
      );
    } catch (e, s) {
      debugPrint(' == CATCH ERROR===== completeOrder: $e ======= ');
      debugPrint('$s');
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  CollectionModel _createOrUpdateCollection({
    required ScrapOrderModel order,
    required int date,
    CollectionModel? collection,
  }) {
    if (collection != null) {
      return _CollectionMethod.updateCollection(coll: collection, order: order);
    } else {
      return CollectionModel.fromScrapOrder(order, date);
    }
  }

  (DocRef myColRef, DocRef dailyColRef) findCollRef(int today, ScrapType type) {
    if (type == ScrapType.scrap) {
      final path = '$_staffCol/${_auth.currentUser!.uid}/$_myScrapCollTbl';
      final myColRef = _fs.collection(path).doc('$today');
      final dailyColRef = _fs.collection(_dailyTotalScrapColTbl).doc('$today');
      return (myColRef, dailyColRef);
    } else {
      final path = '$_staffCol/${_auth.currentUser!.uid}/$_myWastCollTbl';
      final myColRef = _fs.collection(path).doc('$today');
      final dailyColRef = _fs.collection(_dailyTotalWasteColTbl).doc('$today');
      return (myColRef, dailyColRef);
    }
  }
  
}

extension on DateTime {
  DateTime get dateOnly => DateTime(year, month, day);
}

class _CollectionMethod {
  static CollectionModel updateCollection({
    required CollectionModel coll,
    required ScrapOrderModel order,
  }) {
    final newSerCharge = order.serviceCharge + coll.totalServiceCharge;
    final newRoundOff = order.roundOffAmt + coll.totalRoundOff;
    final newTotal = order.amtPayable + coll.totalPaidAmt;
    final newTtlQty =
        order.invoicedScraps!.scraps.fold<double>(0, (p, sm) => sm.qty + p) +
            coll.totalQty;
    final newCollList = <CollectedItem>[];
    for (final sp in order.invoicedScraps!.scraps) {
      final i = coll.items.indexWhere((itm) => itm.itemName == sp.scrapName);
      if (i >= 0) {
        var item = coll.items[i];
        item = item.copyWith(
          qty: item.qty + sp.qty,
        );
        coll.items[i] = item;
      } else {
        final newColl = CollectedItem(
          itemName: sp.scrapName,
          amount: sp.price,
          qty: sp.qty,
        );
        newCollList.add(newColl);
      }
    }
    coll.items.addAll(newCollList);
    return coll.copyWith(
      totalPaidAmt: newTotal,
      totalRoundOff: newRoundOff,
      totalServiceCharge: newSerCharge,
      totalQty: newTtlQty,
    );
  }
}

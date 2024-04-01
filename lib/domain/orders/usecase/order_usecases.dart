// ignore_for_file: lines_longer_than_80_chars

import 'package:get_it/get_it.dart';
import 'package:treeo_delivery/core/utils/type_def.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/domain/orders/repository/scrap_order_repo.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/orderdetails.dart';

class OrderUsecases {
  OrderUsecases._();
  static final OrderUsecases _instance = OrderUsecases._();

  static OrderUsecases I = _instance;

  final ScrapOrderRepo _repo = GetIt.I.get<ScrapOrderRepo>();

  FutureVoid rescheduleOrder({
    required DateTime date,
    required String id,
  }) async =>
      _repo.rescheduleOrder(date: date, id: id);

  FutureMyCollections getMyCollection() => _repo.getMyCollection();

  Stream<Iterable<ScrapOrder>> getAllPendingAssignedOrders(
    String? searchText,
  ) =>
      _repo.getAllPendingAssignedOrders(searchText);

  ScrapOrderStream stream({required int page}) => _repo.getAllOrders(page);

  FutureScrapModels getAllScrap() => _repo.getAllScrap();

  FutureVoid updateOrderStatus({
    required String id,
    required OrderStatus status,
    String? invoicedScrapRefId,
    String? reson,
    DateTime? reschedule,
  }) =>
      _repo.updateOrderStatus(
        id: id,
        status: status,
        invoicedScrapRefId: invoicedScrapRefId,
        reson: reson,
        reschedule: reschedule,
      );
}

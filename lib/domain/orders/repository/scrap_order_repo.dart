import 'package:dartz/dartz.dart';
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/core/errors/failures.dart';
import 'package:treeo_delivery/core/utils/type_def.dart';
import 'package:treeo_delivery/data/orders/model/invoiced_scrap.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/orderdetails.dart';

abstract class ScrapOrderRepo {
  const ScrapOrderRepo();

  FutureScrapOrders getTodaysPendingOrders();

  ScrapOrderStream getAllOrders(int page);

  Stream<Iterable<ScrapOrder>> getAllPendingAssignedOrders(String? searchText);

  StreamCollections getCollection(ScrapType type);

  Future<Either<Failure, InvoicedScrap>> getInvoicedScrapData(String id);

  FutureVoid cancelOrder({
    required String id,
    required String reason,
    required String invoicedScrapRefId,
  });

  FutureVoid updateOrderStatus({
    required String id,
    required OrderStatus status,
    String? invoicedScrapRefId,
    String? reson,
    DateTime? reschedule,
  });

  FutureVoid completeOrder({
    required ScrapOrder order,
  });
  FutureVoid rescheduleOrder({
    required DateTime date,
    required String id,
  });

  FutureScrapModels getAllScrap();


}

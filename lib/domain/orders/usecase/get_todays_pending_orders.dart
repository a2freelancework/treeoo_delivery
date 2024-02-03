
import 'package:treeo_delivery/core/utils/type_def.dart';
import 'package:treeo_delivery/domain/orders/repository/scrap_order_repo.dart';

class GetTodaysPendingOrder {
  const GetTodaysPendingOrder(this._repo);
  final ScrapOrderRepo _repo;

  FutureScrapOrders call() => _repo.getTodaysPendingOrders();
}

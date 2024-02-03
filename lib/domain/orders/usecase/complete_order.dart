import 'package:treeo_delivery/core/utils/type_def.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/domain/orders/repository/scrap_order_repo.dart';

class CompleteOrder {
  const CompleteOrder(this._repo);
  final ScrapOrderRepo _repo;

  FutureVoid call({required ScrapOrder order}) => 
    _repo.completeOrder(order: order);
}

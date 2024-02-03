import 'package:treeo_delivery/core/utils/type_def.dart';
import 'package:treeo_delivery/domain/orders/repository/scrap_order_repo.dart';

class GetMyCollection {
  const GetMyCollection(this._repo);
  final ScrapOrderRepo _repo;

  FutureMyCollections call() => _repo.getMyCollection();
}

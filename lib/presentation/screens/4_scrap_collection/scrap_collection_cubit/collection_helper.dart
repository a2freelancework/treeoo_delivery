// ignore_for_file: lines_longer_than_80_chars

import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/core/services/injection_container.dart';
import 'package:treeo_delivery/domain/orders/entity/my_collection.dart';
import 'package:treeo_delivery/domain/orders/repository/scrap_order_repo.dart';

class CollectionHelper {
  const CollectionHelper._();
  static final ScrapOrderRepo _repo = sl();
  static Stream<Iterable<MyCollection>> scrapCollections() => _repo.getCollection(ScrapType.scrap);
  static Stream<Iterable<MyCollection>> wasteCollections() => _repo.getCollection(ScrapType.waste);
}

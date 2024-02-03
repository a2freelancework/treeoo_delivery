import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treeo_delivery/core/utils/type_def.dart';
import 'package:treeo_delivery/data/orders/model/collection_model.dart';
import 'package:treeo_delivery/data/orders/model/scrap_model.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';

enum CollectionSavingType {
  addOn,
  replaceAll,
}

abstract class OrderLocalDataSrc {
  const OrderLocalDataSrc();
  Future<int?> getOrderUpdatedDate();

  Future<void> saveAssignedPendingOrderLocally({
    required Iterable<ScrapOrderModel> orders,
    required int? date,
  });
  Future<Iterable<ScrapOrderModel>?> fetchOrdersFromCache();

  Future<Iterable<CollectionModel>?> getLast7daysMyCollection();

  Future<void> saveMyCollectionLocally({
    required CollectionSavingType type,
    required dynamic collection,
  });

  Future<void> refreshOrder();

  int? getScrapLastUpdatedCachedDate();
  Future<List<ScrapModel>?> getScrapItemFromCache();
  Future<void> cacheScrapAndCategory(List<ScrapModel> scraps);
  Future<void> cacheScrapLastUpdatedDate(int date);
}

const _orderUpdated = 'ASSIGNED_ORDER_UPDATED_DATE';
const _assignedPendingOrder = 'ASSIGNED_PENDING_ORDER';
const _myCollection = 'LAST_7_DAYS_MY_COLLECTION';
const _scrapUpdated = 'SCRAP_LAST_UPDATED_DATE';
const _tScrapTable = 'SCRAP_ITEMS';

class OrderLocalDataSrcImpl implements OrderLocalDataSrc {
  const OrderLocalDataSrcImpl(this._prf);
  final SharedPreferences _prf;

  @override
  Future<int?> getOrderUpdatedDate() async {
    try {
      return _prf.getInt(_orderUpdated);
    } catch (e) {
      debugPrint(' ======= orderUpdatedDate [CACHE] : $e======= ');
      return null;
    }
  }

  @override
  Future<void> saveAssignedPendingOrderLocally({
    required Iterable<ScrapOrderModel> orders,
    required int? date,
  }) async {
    try {
      final dataToSave = orders.map((e) => e.toMap()).toList();
      await _prf.setString(_assignedPendingOrder, jsonEncode(dataToSave));
      if (date != null) {
        await _prf.setInt(_orderUpdated, date);
      }
    } catch (e) {
      debugPrint(' ======= saveTodaysOrderLocally: $e ======= ');
    }
  }

  @override
  Future<Iterable<ScrapOrderModel>?> fetchOrdersFromCache() async {
    try {
      final result =
          (jsonDecode(_prf.getString(_assignedPendingOrder)!) as List)
              .map((e) => e as DataMap);
      debugPrint('==== [ORDERS FETCHED FROM CACHE] ${result.length}==== ');
      return result.map(ScrapOrderModel.fromMap);
    } catch (e) {
      debugPrint('==== fetchOrdersFromCache: $e ==== ');
      return null;
    }
  }

  @override
  Future<Iterable<CollectionModel>?> getLast7daysMyCollection() async {
    try {
      final result = (jsonDecode(_prf.getString(_myCollection)!) as List)
          .map((e) => e as DataMap);
      return result.map(CollectionModel.fromMap);
    } catch (e) {
      debugPrint('==== getLast7daysMyCollection: $e ==== ');
      return null;
    }
  }

  @override
  Future<void> saveMyCollectionLocally({
    required CollectionSavingType type,
    required dynamic collection,
  }) async {
    assert(
      collection is CollectionModel || collection is Iterable<CollectionModel>,
      'collection must be either CollectionModel or '
      'Iterable<MyCollectionModel>',
    );

    var dataToSave = <CollectionModel>[];
    try {
      if (type == CollectionSavingType.addOn) {
        final cachedColl = await getLast7daysMyCollection();
        if (cachedColl == null) {
          await _prf.remove(_myCollection);
          debugPrint(' *  cachedColl == null CollectionSavingType.addOn * ');
          return;
        }
        debugPrint(' =======BEFORE CollectionSavingType.addOn ======= ');
        for (var i = 0; i < cachedColl.length; i++) {
          final gg = cachedColl.elementAt(i);
          debugPrint('$i: $gg ');
        }
        dataToSave = cachedColl.toList()
          ..remove(collection as CollectionModel)
          ..add(collection);

        debugPrint(' =======AFTER CollectionSavingType.addOn ======= ');
        for (var i = 0; i < dataToSave.length; i++) {
          debugPrint('$i: ${dataToSave.elementAt(i)} ');
        }

        if (dataToSave.length > 7) {
          dataToSave.removeAt(0);
        }
      } else {
        dataToSave = (collection as Iterable<CollectionModel>).toList();
      }
      debugPrint(' ======= BEFORE SAVING ======= ');
      final listMap = dataToSave.map((coll) => coll.toMap()).toList();
      await _prf.setString(_myCollection, jsonEncode(listMap));
    } catch (e, s) {
      debugPrint('$s');
      debugPrint(' ======= saveMyCollectionLocally: $e ======= ');
    }
  }

  @override
  Future<void> refreshOrder() async {
    try {
      await _prf.remove(_assignedPendingOrder);
    } catch (e) {
      debugPrint('ERRORRR REFRESH ORDER: $e');
    }
  }
  
  @override
  int? getScrapLastUpdatedCachedDate() {
    try {
      final date = _prf.getInt(_scrapUpdated);
      debugPrint('=======>>> $date');
      return date;
      // return _pref.getInt(_scrapUpdated);
    } catch (e) {
      return null;
    }
  }
  
  @override
  Future<List<ScrapModel>?> getScrapItemFromCache() async{
    try {
      final result = jsonDecode(_prf.getString(_tScrapTable)!) as List;
         return List<Map<String, dynamic>>.from(result).map(ScrapModel.fromMap)
          .toList();
    } catch (e) {
      debugPrint('++>getScrapItemFromCache:  $e');
      return null;
    }
  }
  
  @override
  Future<void> cacheScrapAndCategory(List<ScrapModel> scraps) async {
    await _prf.setString(_tScrapTable, jsonEncode(
      scraps.map((e) => e.toMap()).toList(),
    ),);
  }
  
  @override
  Future<void> cacheScrapLastUpdatedDate(int date) async {
    await _prf.setInt(_scrapUpdated, date);
  }
}

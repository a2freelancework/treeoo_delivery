// ignore_for_file: lines_longer_than_80_chars, constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:treeo_delivery/core/errors/exceptions.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/core/utils/string_constants.dart';
import 'package:treeo_delivery/core/utils/type_def.dart' show ScrapOrderStream;
import 'package:treeo_delivery/data/orders/model/collected_item.dart';
import 'package:treeo_delivery/data/orders/model/collection_model.dart';
import 'package:treeo_delivery/data/orders/model/invoiced_scrap.dart';
import 'package:treeo_delivery/data/orders/model/scrap_model.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';
import 'package:treeo_delivery/domain/orders/orders_const_info.dart';
import 'package:treeo_delivery/presentation/screens/orderscreen/orderdetails.dart';

abstract class OrderRemoteDataSrc {
  const OrderRemoteDataSrc();

  Stream<Iterable<ScrapOrderModel>> getAllPendingAssignedOrders(
    String? searchText,
  );

  ScrapOrderStream getAllOrders(int page);
  Future<Iterable<ScrapOrderModel>> searchAllOrders(int page);

  Future<int?> getOrderUpdatedDate();

  Future<Iterable<CollectionModel>> getLast7daysMyCollection();

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

  Future<CollectionModel> completeOrder({required ScrapOrderModel order});

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
const _myCollectionCol = 'my_collection';
const _dailyTotalCol = 'daily_total_collection';
const _treeooStatusControlCollection = 'treeoo_status_control';
const _treeooStatusControlDoc = 'ADMIN';
const _scrapItemCollection = 'scrap_items';

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
    // TODO: implement searchAllOrders
    throw UnimplementedError();
  }

  // @override
  // Future<Iterable<ScrapOrderModel>> getAllPendingAssignedOrders() async {
  //   //.where('status', whereIn: ['PROCESSING','PENDING'])
  //   try {
  //     debugPrint(' =======>> ${_auth.currentUser!.staffId}  ====== ');
  //     final result = await _fs
  //         .collection(_invoiceCol)
  //         .where('assigned_staff_id', isEqualTo: _auth.currentUser!.staffId)
  //         .where('status', isEqualTo: 'PROCESSING')
  //         .get()
  //         .then(
  //           (querySnap) => querySnap.docs.map(
  //             ScrapOrderModel.fromQueryMap,
  //           ),
  //         );
  //     debugPrint('$result ');
  //     debugPrint('==== [ORDERS FETCHED FROM SERVER] ==== ');
  //     return result;
  //   } on FirebaseException catch (e) {
  //     debugPrint('==== assignedPendingOrders(): $e ==== ');
  //     throw ServerException(
  //       message: e.message ?? 'Error Occurred',
  //       statusCode: e.code,
  //     );
  //   } catch (e) {
  //     throw ServerException(
  //       message: e.toString(),
  //       statusCode: '500',
  //     );
  //   }
  // }

  @override
  Stream<Iterable<ScrapOrderModel>> getAllPendingAssignedOrders(
    String? searchText,
  ) {
    var query = _fs
        .collection(_invoiceCol)
        .where('assigned_staff_id', isEqualTo: _auth.currentUser!.staffId)
        // .where('status', isEqualTo: 'PROCESSING');
        .where('status', whereIn: [
      OrderStatusConst.PROCESSING,
      OrderStatusConst.RESCHEDULED,
      OrderStatusConst.ONWAY,
    ],);
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
    // return _fs
    //     .collection(_invoiceCol)
    //     .where('assigned_staff_id', isEqualTo: _auth.currentUser!.staffId)
    //     .where('status', isEqualTo: 'PROCESSING')
    //     .where('order_id', isGreaterThanOrEqualTo: 'TR3')
    //     .snapshots()
    //     .map(
    //       (querySnapshote) =>
    //           querySnapshote.docs.map(ScrapOrderModel.fromQueryMap),
    //     );
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
      debugPrint('*****************************');
      debugPrint(' ======= $path ======= ');
      debugPrint('*****************************');
      final date =
          await _fs.collection(path).doc(_orderUpdated).get().then((docSnap) {
        debugPrint(docSnap.data().toString());
        return (docSnap.data()!['date'] as Timestamp).toDate();
      });
      debugPrint('ooooooooooooooo $date');
      return date.millisecondsSinceEpoch;
    } catch (e) {
      debugPrint(' ==== orderUpdatedDate(): $e ==== ');
      return null;
    }
  }

  @override
  Future<CollectionModel> completeOrder({
    required ScrapOrderModel order,
  }) async {
    final today = DateTime.now().dateOnly.millisecondsSinceEpoch;
    try {
      final path = '$_staffCol/${_auth.currentUser!.uid}/$_myCollectionCol';
      debugPrint('-------> path: $path');

      final myCollectionRef = _fs.collection(path).doc('$today');
      final dailyTotalCollRef = _fs.collection(_dailyTotalCol).doc('$today');
      final invoiceRef = _fs.collection(_invoiceCol).doc(order.id);
      final invoicedScrapRef = _fs
          .collection(_invoicedScrapCol)
          .doc(order.invoicedScraps!.scrapRefId);

      CollectionModel? myCollToUpdate;
      CollectionModel? dailyTotalCollToUpdate;
      await _fs.runTransaction((transaction) async {
        final myCollDoc = await transaction
            .get(myCollectionRef)
            .then((d) => (id: d.id, data: d.data()));

        final dailyTotalCollDoc = await transaction
            .get(dailyTotalCollRef)
            .then((d) => (id: d.id, data: d.data()));

        myCollToUpdate = _findCollectionModel(myCollDoc, order, today);
        dailyTotalCollToUpdate = _findCollectionModel(
          dailyTotalCollDoc,
          order,
          today,
        );

        debugPrint('myCollToUpdate: FIRST: $myCollToUpdate');
        final invoiceToUpdate = {
          'address': order.address,
          'status': 'COMPLETED',
          'service_charge': order.serviceCharge,
          'round_off_amt': order.roundOffAmt,
          'amt_payable': order.amtPayable,
        };
        final myColl = {
          'date': today,
          'items': myCollToUpdate!.items.map((e) => e.toMap()).toList(),
          'total_service_charge': myCollToUpdate!.totalServiceCharge,
          'total_round_off': myCollToUpdate!.totalRoundOff,
          'total_qty': myCollToUpdate!.totalQty,
          'total_paid_amt': myCollToUpdate!.totalPaidAmt,
        };
        final dailyTotalColl = {
          'date': today,
          'items': dailyTotalCollToUpdate!.items.map((e) => e.toMap()).toList(),
          'total_service_charge': dailyTotalCollToUpdate!.totalServiceCharge,
          'total_round_off': dailyTotalCollToUpdate!.totalRoundOff,
          'total_qty': dailyTotalCollToUpdate!.totalQty,
          'total_paid_amt': dailyTotalCollToUpdate!.totalPaidAmt,
        };
        final invoicedScrapToUpdate = {
          'invoiceId': order.invoicedScraps!.invoiceId,
          'scrap_list': order.invoicedScraps!.scraps.map((e) => e.toMap()),
        };

        transaction
          ..update(invoiceRef, invoiceToUpdate)
          ..set(myCollectionRef, myColl)
          ..set(dailyTotalCollRef, dailyTotalColl)
          ..set(invoicedScrapRef, invoicedScrapToUpdate);

        // print('===========invoiceToUpdate=========');
        // print(invoiceToUpdate);
        // print('===========myColl=========');
        // print(myColl);
        // print('===========dailyTotalColl=========');
        // print(dailyTotalColl);
        // print('===========invoicedScrapToUpdate=========');
        // print(invoicedScrapToUpdate);
      }).then((value) => debugPrint('ORDER UPDATED SUCCESSFULLY $value'));
      return myCollToUpdate!;
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

  @override
  Future<Iterable<CollectionModel>> getLast7daysMyCollection() async {
    try {
      final path = '$_staffCol/${_auth.currentUser!.uid}/$_myCollectionCol';
      final collections = await _fs
          .collection(path)
          .orderBy(FieldPath.documentId)
          .limitToLast(7)
          .get()
          .then(
            (querySnap) => querySnap.docs.map(CollectionModel.fromQueryMap),
          );
      debugPrint('==== [MY COLLECTIONS FROM SERVER] ==== ');
      return collections;
    } on FirebaseException catch (e) {
      debugPrint(' ==== getLast7daysMyCollection(): $e ==== ');
      throw ServerException(
        message: e.message ?? 'Unable to get data',
        statusCode: e.code,
      );
    } catch (e) {
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  CollectionModel _findCollectionModel(
    ({Map<String, dynamic>? data, String id}) doc,
    ScrapOrderModel order,
    int date,
  ) {
    if (doc.data != null) {
      doc.data!['id'] = doc.id;
      final myColl = CollectionModel.fromMap(doc.data!);
      return _CollectionMethod.updateCollection(
        coll: myColl,
        order: order,
      );
    } else {
      return _CollectionMethod.createCollection(
        order: order,
        id: date,
      );
    }
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
        'status': OrderStatusConst.PENDING,
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
    final newTotalQty = order.invoicedScraps!.scraps.fold<double>(
          0,
          (sum, sp) => sp.qty + sum,
        ) +
        coll.totalQty;
    final newCollList = <CollectedItem>[];

    for (final sp in order.invoicedScraps!.scraps) {
      final index =
          coll.items.indexWhere((itm) => itm.itemName == sp.scrapName);
      if (index >= 0) {
        var myCol = coll.items[index];
        myCol = myCol.copyWith(
          amount: myCol.amount + sp.price * sp.qty,
          qty: myCol.qty + sp.qty,
        );
        coll.items[index] = myCol;
      } else {
        final newColl = CollectedItem(
          itemName: sp.scrapName,
          amount: sp.price * sp.qty,
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
      totalQty: newTotalQty,
    );
  }

  static CollectionModel createCollection({
    required ScrapOrderModel order,
    required int id,
  }) {
    return CollectionModel(
      id: id.toString(),
      date: DateTime.fromMillisecondsSinceEpoch(id),
      totalPaidAmt: order.amtPayable,
      totalQty:
          order.invoicedScraps!.scraps.fold(0, (prev, sp) => sp.qty + prev),
      totalRoundOff: order.roundOffAmt,
      totalServiceCharge: order.serviceCharge,
      items: order.invoicedScraps!.scraps
          .map(
            (sp) => CollectedItem(
              amount: sp.price * sp.qty,
              itemName: sp.scrapName,
              qty: sp.qty,
            ),
          )
          .toList(),
    );
  }
}
/*
I am using FirebaseFirestore. there is a collection users. I need to get all user whose name start with 'ab' or phone_no start with 1236
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;

void getUsersWithNameOrPhone() async {
  // Query for names starting with 'ab'
  QuerySnapshot nameQuery = await _firestore
      .collection('users')
      .where('name', isGreaterThanOrEqualTo: 'ab')
      .where('name', isLessThan: 'ac') // 'ac' comes after 'ab' in ASCII
      .get();

  // Query for phone numbers starting with '1236'
  QuerySnapshot phoneQuery = await _firestore
      .collection('users')
      .where('phone_no', isGreaterThanOrEqualTo: '1236')
      .where('phone_no', isLessThan: '1237') // Next possible number after '1236'
      .get();

  // Combine and process the results from both queries
  // Note: This simplistic approach might include duplicates if a user matches both criteria
  List<QueryDocumentSnapshot> combinedResults = nameQuery.docs + phoneQuery.docs;

  // Eliminate potential duplicates by converting to a set and back to a list
  List<QueryDocumentSnapshot> uniqueResults = combinedResults.toSet().toList();

  // Process your results (e.g., print, display in UI)
  uniqueResults.forEach((doc) {
    print(doc.data());
  });
}

*/

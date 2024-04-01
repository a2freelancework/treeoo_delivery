// ignore_for_file: lines_longer_than_80_chars

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:treeo_delivery/core/extensions/date_ext.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';

const _invoicePrefix = 'TR';
const _usersCollection = 'users';
const _invoiceCount = 'daily_invoice_count';
const _invoice = 'invoice';
const _invoicedScrap = 'invoiced_scrap';

class AddOrderBackend {
  AddOrderBackend();

  final FirebaseFirestore _fs = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> checkUserAlreadyExist({
    required String phone,
  }) async {
    final users = await _fs
        .collection(_usersCollection)
        .where(
          'phone',
          isEqualTo: phone,
        )
        .get();
    if (users.docs.isNotEmpty) {
      final user = users.docs.first.data();
      user['id'] = users.docs.first.id;
      return user;
    }
    return null;
  }

  // creaye user and order
  Future<void> createUserAndOrder({
    required Map<String, String?> user,
    required ScrapOrderModel scrapModel,
  }) async {
    await _saveToDataBase(
      user: user,
      scrapModel: scrapModel,
    );
  }

  // creaye order only
  Future<void> createOrderForExistingUser(ScrapOrderModel scrapModel) async {
    await _saveToDataBase(scrapModel: scrapModel);
  }

  Future<void> _saveToDataBase({
    required ScrapOrderModel scrapModel,
    Map<String, String?>? user,
  }) async {
    final today = DateTime.now();
    final pickupUser = UserAuth.I.currentUser!;
    final invoiceNoDate = DateFormat('ddMMyy').format(today);
    final countRef =
        _fs.collection(_invoiceCount).doc(pickupUser.pickupLocation!.name);
    final invoiceRef = _fs.collection(_invoice).doc();
    final invoicedScrapRef = _fs.collection(_invoicedScrap).doc();
    final invoice = scrapModel.toMap()
      ..remove('id')
      ..remove('invoicedScraps');
    invoice['order_id'] =
        '$_invoicePrefix$invoiceNoDate${pickupUser.pickupLocation!.symbol}';
    invoice['pickup_location'] = pickupUser.pickupLocation!.name;
    invoice['pickup_date'] = scrapModel.pickupDate;
    invoice['created_at'] = scrapModel.createdAt;
    await _fs.runTransaction((transaction) async {
      final snapshot = await transaction.get(countRef);
      if (snapshot.exists) {
        final countData = snapshot.data()!;
        final countLastUpdated =
            (countData['last_updated'] as Timestamp).toDate();
        var updatedCnt = 0;
        if (today.toDate == countLastUpdated.toDate) {
          updatedCnt = (snapshot.data()!['count'] as int) + 1;
          transaction.update(countRef, {'count': updatedCnt});
        } else {
          updatedCnt = 1;
          transaction.update(
            countRef,
            {'count': updatedCnt, 'last_updated': today},
          );
        }

        final paddedCount = updatedCnt.toString().padLeft(3, '0');
        invoice['order_id'] =
            '$_invoicePrefix$invoiceNoDate${pickupUser.pickupLocation!.symbol}$paddedCount';
      }

      // if user != null then create new user
      if (user != null) {
        final usersRef = _fs.collection(_usersCollection).doc(user['phone']);
        transaction.set(usersRef, user);
      }
      
      transaction
        ..set(invoiceRef, invoice)
        ..set(invoicedScrapRef, {
          'scrap_list': <Map<String, dynamic>>[],
          'invoiceId': invoiceRef.id,
        });
    });
  }
}

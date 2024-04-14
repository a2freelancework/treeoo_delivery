// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/data/orders/model/invoiced_scrap.dart';

class ScrapOrder extends Equatable {
  const ScrapOrder({
    required this.id,
    required this.orderId,
    required this.assignedStaffId,
    required this.address,
    required this.customerName,
    required this.phone,
    required this.pickupDate,
    required this.completedDate,
    required this.amtPayable,
    required this.roundOffAmt,
    required this.serviceCharge,
    required this.type,
    required this.note,
    required this.status,
    required this.createdAt,
    required this.uid,
    required this.invoicedScraps,
  });

  final String id;
  final String orderId;
  final String assignedStaffId;
  final String address;
  final String customerName;
  final String phone;
  final DateTime pickupDate;
  final DateTime? completedDate;
  final double amtPayable;
  final double roundOffAmt;
  final double serviceCharge;
  final ScrapType type;
  final String note;
  final String status;
  final DateTime createdAt;
  final InvoicedScrap? invoicedScraps;
  final String uid;

  @override
  List<Object?> get props => [id];

  @override
  String toString() {
    return 'ScrapOrder( id: $id, orderId: $orderId, address: $address, customerName: $customerName, '
        'phone: $phone pickupDate: $pickupDate, amtPayable: $amtPayable, status: $status, type: $type'
        'roundOffAmt: $roundOffAmt, serviceCharge: $serviceCharge, uid: $uid) '
        '==|invoicedScraps: $invoicedScraps note: $note';
  }
}

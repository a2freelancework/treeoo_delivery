// ignore_for_file: lines_longer_than_80_chars

import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/core/utils/type_def.dart';
import 'package:treeo_delivery/data/orders/model/invoiced_scrap.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';

class ScrapOrderModel extends ScrapOrder {
  const ScrapOrderModel({
    required super.id,
    required super.orderId,
    required super.assignedStaffId,
    required super.customerName,
    required super.phone,
    required super.address,
    required super.pickupDate,
    required super.amtPayable,
    required super.roundOffAmt,
    required super.serviceCharge,
    required super.note,
    required super.type,
    required super.status,
    required super.createdAt,
    required super.uid,
    super.completedDate,
    super.invoicedScraps,
  });

  factory ScrapOrderModel.fromQueryMap(QueryMap data) {
    final map = data.data();
    return ScrapOrderModel(
      id: data.id,
      orderId: map['order_id'] as String,
      address: map['address'] as String,
      customerName: (map['customer_name'] as String?) ?? '',
      phone: (map['phone'] as String?) ?? '',
      pickupDate: (map['pickup_date'] as Timestamp).toDate(),
      completedDate: map['completed_date']!= null ? (map['completed_date'] as Timestamp).toDate() : null,
      amtPayable: double.tryParse('${map['amt_payable']}') ?? 0,
      roundOffAmt: double.tryParse('${map['round_off_amt']}') ?? 0,
      serviceCharge: double.tryParse('${map['service_charge']}') ?? 0,
      note: map['note'] as String,
      type: (map['type'] as String).toScrapType(),
      status: map['status'] as String,
      uid: map['uid'] as String,
      assignedStaffId: map['assigned_staff_id'] as String,
      createdAt: (map['created_at'] as Timestamp).toDate(),
      // invoicedScraps: null,
    );
  }

  factory ScrapOrderModel.fromMap(DataMap map) {
    return ScrapOrderModel(
      id: map['id'] as String,
      orderId: map['order_id'] as String,
      address: map['address'] as String,
      customerName: map['customer_name'] as String,
      phone: map['phone'] as String,
      pickupDate: DateTime.fromMillisecondsSinceEpoch(map['pickup_date'] as int),
      completedDate: map['pickup_date'] != null ? DateTime.fromMillisecondsSinceEpoch(map['completed_date'] as int):null,
      amtPayable: map['amt_payable'] as double,
      roundOffAmt: map['round_off_amt'] as double,
      serviceCharge: map['service_charge'] as double,
      note: map['note'] as String,
      type: (map['type'] as String).toScrapType(),
      status: map['status'] as String,
      uid: map['uid'] as String,
      assignedStaffId: map['assigned_staff_id'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      invoicedScraps: map['invoicedScraps'] != null
          ? InvoicedScrap.fromMap(map['invoicedScraps'] as Map<String, dynamic>)
          : null,
    );
  }

  ScrapOrderModel copyWith({
    String? address,
    DateTime? pickupDate,
    double? amtPayable,
    double? roundOffAmt,
    double? serviceCharge,
    String? status,
    InvoicedScrap? invoicedScraps,
  }) {
    return ScrapOrderModel(
      id: id,
      orderId: orderId,
      address: address ?? this.address,
      customerName: customerName,
      phone: phone,
      pickupDate: pickupDate ?? this.pickupDate,
      completedDate: completedDate,
      amtPayable: amtPayable ?? this.amtPayable,
      roundOffAmt: roundOffAmt ?? this.roundOffAmt,
      serviceCharge: serviceCharge ?? this.serviceCharge,
      note: note,
      type: type,
      status: status ?? this.status,
      uid: uid,
      assignedStaffId: assignedStaffId,
      createdAt: createdAt,
      invoicedScraps: invoicedScraps ?? this.invoicedScraps,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderId,
      'customer_name': customerName,
      'phone': phone,
      'address': address,
      'pickup_date': pickupDate.millisecondsSinceEpoch,
      'completed_date': completedDate?.millisecondsSinceEpoch,
      'amt_payable': amtPayable,
      'round_off_amt': roundOffAmt,
      'service_charge': serviceCharge,
      'note': note,
      'type': type.toText,
      'status': status,
      'uid': uid,
      'assigned_staff_id': assignedStaffId,
      'created_at': createdAt.millisecondsSinceEpoch,
      'invoicedScraps': invoicedScraps?.toMap(),
    };
  }

  ScrapOrderModel clone() {
    return ScrapOrderModel(
      id: id,
      orderId: orderId,
      address: address,
      customerName: customerName,
      phone: phone,
      pickupDate: pickupDate,
      amtPayable: amtPayable,
      roundOffAmt: roundOffAmt,
      serviceCharge: serviceCharge,
      note: note,
      type: type,
      status: status,
      uid: uid,
      assignedStaffId: assignedStaffId,
      createdAt: createdAt,
      invoicedScraps: invoicedScraps?.clone(),
    );
  }
}

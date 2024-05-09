// ignore_for_file: lines_longer_than_80_chars

import 'package:treeo_delivery/core/app_enums/staff_status.dart';
import 'package:treeo_delivery/core/services/user_location_helper.dart';
import 'package:treeo_delivery/domain/auth/entity/pickup_user.dart';
import 'package:treeo_delivery/domain/auth/entity/vehicle.dart';

final today = DateTime.now();

class PickupUserModel extends PickupUser {
  const PickupUserModel({
    required super.uid,
    required super.email,
    required super.phone,
    required super.name,
    required super.status,
    required super.staffId,
    required super.sessionExpiry,
    required super.orderCode,
    super.pickupLocation,
    super.vehicle,
  });

  PickupUserModel.dummy()
      : this(
          uid: '111',
          name: 'dummy name',
          email: '',
          phone: '1234567890',
          staffId: '1234',
          status: 'ACTIVE'.toStaffStatus(),
          // sessionExpiry: DateTime.now(),
          // pickupLocation: null,
          orderCode: '1234',
          sessionExpiry: DateTime(today.year, today.month, today.day - 1, 6),
        );

  PickupUserModel.fromCacheMap(Map<String, dynamic> map)
      : this(
          uid: map['uid'] as String,
          name: map['staff_name'] as String,
          email: map['email'] as String,
          phone: map['staff_number'] as String,
          staffId: map['staff_id'] as String,
          status: (map['status'] as String).toStaffStatus(),
          pickupLocation: map['pickupLocation'] != null
              ? UserLocation.fromMap(
                  map['pickupLocation'] as Map<String, dynamic>)
              : null,
          vehicle: map['vehicle'] != null
              ? Vehicle.fromMap(map['vehicle'] as Map<String, dynamic>)
              : null,
          orderCode: map['order_code'] as String,
          sessionExpiry: DateTime.fromMillisecondsSinceEpoch(
            map['sessionExpiry'] as int,
          ),
        );
  // PickupUserModel.fromQueryMap(String id, Map<String, dynamic> map) : this(
  //   uid: id,
  //   name: map['staff_name'] as String,
  //   email: map['email'] as String,
  //   phone: map['staff_number'] as String,
  //   staffId: map['staff_id'] as String,
  //   status: (map['status'] as String).toStaffStatus(),
  //   pickupLocation: UserLocation.fromLocationName(map['staff_district'] as String),
  //   orderCode: map['order_code'] as String,
  //   sessionExpiry: DateTime.now().createSessionExp,
  // );
  factory PickupUserModel.fromQueryMap(String id, Map<String, dynamic> map) {
    return PickupUserModel(
      uid: id,
      name: map['staff_name'] as String,
      orderCode: map['order_code'] as String,
      staffId: map['staff_id'] as String,
      email: map['email'] as String,
      phone: map['staff_number'] as String,
      status: (map['status'] as String).toStaffStatus(),
      pickupLocation: UserLocation.fromLocationName(map['staff_district'] as String),
      sessionExpiry: DateTime.now().createSessionExp,
    );
  }

  PickupUserModel copyWith({
    Vehicle? vehicle,
    UserLocation? pickupLocation,
  }) {
    return PickupUserModel(
      uid: uid,
      email: email,
      name: name,
      phone: phone,
      staffId: staffId,
      status: status,
      sessionExpiry: sessionExpiry,
      vehicle: vehicle ?? this.vehicle,
      orderCode: orderCode,
      pickupLocation: pickupLocation ?? this.pickupLocation,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'staff_name': name,
      'email': email,
      'staff_number': phone,
      'staff_id': staffId,
      'status': status.stringValue,
      'sessionExpiry': sessionExpiry.millisecondsSinceEpoch,
      'vehicle': vehicle?.toMap(),
      'order_code': orderCode,
      'pickupLocation': pickupLocation?.toMap(),
    };
  }
}

extension on DateTime {
  // session will expire tomorrow 6AM
  DateTime get createSessionExp => DateTime(year, month, day + 1, 6);
}

extension on String {
  StaffStatus toStaffStatus() {
    switch (this) {
      case 'ACTIVE':
        return StaffStatus.ACTIVE;
      case 'NEW':
        return StaffStatus.NEW;
      default:
        return StaffStatus.DEACTIVE;
    }
  }
}

// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';
import 'package:treeo_delivery/core/app_enums/staff_status.dart';
import 'package:treeo_delivery/core/services/user_location_helper.dart';
import 'package:treeo_delivery/domain/auth/entity/vehicle.dart';

class PickupUser extends Equatable {
  const PickupUser({
    required this.uid,
    required this.email,
    required this.phone,
    required this.name,
    required this.status,
    required this.staffId,
    required this.sessionExpiry,
    required this.orderCode,
    this.pickupLocation,
    this.vehicle,
  });

  final String uid;
  final String phone;
  final String name;
  final StaffStatus status;
  final String staffId;
  final String email;
  final DateTime sessionExpiry;
  final Vehicle? vehicle;
  final UserLocation? pickupLocation;
  final String orderCode;

  @override
  List<Object?> get props => [uid];

  @override
  String toString() {
    return 'PickupUser(uid: $uid, email: $email, vehicle: $vehicle, '
        'phone: $phone, name: $name, status: $status) '
        'staffId: $staffId, sessionExpiry: $sessionExpiry, pickupLocation: $pickupLocation';
  }
}

extension PickupUserExpiry on PickupUser {
  // session will expire everyday 6AM
  // So compare sessionExpiry date with now
  bool get isSessionExpired => sessionExpiry.isBefore(DateTime.now());
}

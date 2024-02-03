import 'package:equatable/equatable.dart';
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
    this.vehicle,
  });
  final String uid;
  final String phone;
  final String name;
  final String status;
  final String staffId;
  final String email;
  final DateTime sessionExpiry;
  final Vehicle? vehicle;

  @override
  List<Object?> get props => [uid];

  @override
  String toString() {
    return 'PickupUser(uid: $uid, email: $email, vehicle: $vehicle, '
        'phone: $phone, name: $name, status: $status) '
        'staffId: $staffId, sessionExpiry: $sessionExpiry';
  }
}

extension PickupUserExpiry on PickupUser {
  // session will expire everyday 6AM
  // So compare sessionExpiry date with now
  bool get isSessionExpired => sessionExpiry.isBefore(DateTime.now());
}

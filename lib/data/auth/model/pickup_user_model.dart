// ignore_for_file: lines_longer_than_80_chars

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
    super.vehicle,
  });

  PickupUserModel.dummy() : this(
    uid: '111',
    name: 'dummy name',
    email: '',
    phone: '1234567890',
    staffId: '1234',
    status: 'ACTIVE',
    // sessionExpiry: DateTime.now(),
    sessionExpiry: DateTime(today.year,today.month, today.day-1,6),
  );

  PickupUserModel.fromCacheMap(Map<String, dynamic> map) : this(
    uid: map['uid'] as String,
    name: map['staff_name'] as String,
    email: map['staff_name'] as String,
    phone: map['staff_number'] as String,
    staffId: map['staff_id'] as String,
    status: map['status'] as String,
    vehicle: map['vehicle'] != null ? Vehicle.fromMap(map['vehicle'] as Map<String, dynamic>) : null,
    sessionExpiry: DateTime.fromMillisecondsSinceEpoch(
      map['sessionExpiry'] as int,
    ),
  );
  PickupUserModel.fromQueryMap(String id, Map<String, dynamic> map) : this(
    uid: id,
    name: map['staff_name'] as String,
    email: map['email'] as String,
    phone: map['staff_number'] as String,
    staffId: map['staff_id'] as String,
    status: map['status'] as String,
    sessionExpiry: DateTime.now().createSessionExp,
  );


  PickupUserModel copyWith({
    Vehicle? vehicle,
  }){
    return PickupUserModel(
      uid: uid,
      email: email,
      name: name,
      phone: phone,
      staffId: staffId,
      status: status,
      sessionExpiry: sessionExpiry, 
      vehicle: vehicle ?? this.vehicle,
    );
  }
  
  Map<String, dynamic> toMap(){
    return {
      'uid': uid,
      'staff_name': name,
      'email': email,
      'staff_number': phone,
      'staff_id': staffId,
      'status': status,
      'sessionExpiry': sessionExpiry.millisecondsSinceEpoch, 
      'vehicle': vehicle?.toMap(),
    };
  }
}

extension on DateTime {// session will expire tomorrow 6AM
  DateTime get createSessionExp => DateTime(year, month, day +1, 6);
}

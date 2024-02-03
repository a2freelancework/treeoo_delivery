import 'package:equatable/equatable.dart';

class Vehicle extends Equatable {
  const Vehicle({required this.id, required this.number, required this.name});

  Vehicle.fromMap(Map<String, dynamic> map)
      : this(
          id: map['id'] as String,
          name: map['name'] as String,
          number: map['number'] as String,
        );

  final String id;
  final String number;
  final String name;

  @override
  List<Object?> get props => [number];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'number': number,
    };
  }

  @override
  String toString() {
    return 'Vehicle( id: $id, name: $name, number: $number)';
  }
}

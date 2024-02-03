// ignore_for_file: lines_longer_than_80_chars

import 'package:dartz/dartz.dart';
import 'package:treeo_delivery/core/errors/failures.dart';
import 'package:treeo_delivery/domain/auth/entity/vehicle.dart';
import 'package:treeo_delivery/domain/auth/repository/auth_repo.dart';

class SaveSelectedVehicles {
  const SaveSelectedVehicles(this._repo);
  final AuthRepo _repo;

  Future<Either<Failure, void>> call(Vehicle vehicle) => _repo.saveSelectedVehicle(vehicle);
}

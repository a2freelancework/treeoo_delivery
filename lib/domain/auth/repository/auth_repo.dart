import 'package:dartz/dartz.dart';
import 'package:treeo_delivery/core/errors/failures.dart';
import 'package:treeo_delivery/core/services/user_location_helper.dart';
import 'package:treeo_delivery/domain/auth/entity/pickup_user.dart';
import 'package:treeo_delivery/domain/auth/entity/vehicle.dart';

abstract class AuthRepo {
  const AuthRepo();

  Either<Failure, PickupUser> getUserFromCache();

  // Future<Either<Failure, PickupUser>> getUserFromServer({
  //   required String phone,
  //   required String password,
  // });

  Future<Either<Failure, void>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> signUp({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> forgotPassword(String email);

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, Iterable<Vehicle>>> getVehicles();
  Future<Either<Failure, void>> cacheVehicleOrLocation({
    Vehicle? vehicle,
    UserLocation? location,
  });
}

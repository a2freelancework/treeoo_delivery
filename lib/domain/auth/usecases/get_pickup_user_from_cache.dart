import 'package:dartz/dartz.dart';
import 'package:treeo_delivery/core/errors/failures.dart';
import 'package:treeo_delivery/domain/auth/entity/pickup_user.dart';
import 'package:treeo_delivery/domain/auth/repository/auth_repo.dart';

class GetPickupUserFromCache{
  const GetPickupUserFromCache(this._repo);

  final AuthRepo _repo;
  
  Either<Failure, PickupUser> call() => _repo.getUserFromCache();
  
}

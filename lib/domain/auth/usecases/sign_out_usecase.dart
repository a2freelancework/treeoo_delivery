import 'package:dartz/dartz.dart';
import 'package:treeo_delivery/core/errors/failures.dart';
import 'package:treeo_delivery/domain/auth/repository/auth_repo.dart';

class SignOut {
  const SignOut(this._repo);

  final AuthRepo _repo;

  Future<Either<Failure, void>> call() => _repo.signOut();
}

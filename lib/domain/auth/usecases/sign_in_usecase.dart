import 'package:dartz/dartz.dart';
import 'package:treeo_delivery/core/errors/failures.dart';
import 'package:treeo_delivery/domain/auth/repository/auth_repo.dart';

class SignIn {
  const SignIn(this._repo);

  final AuthRepo _repo;

  Future<Either<Failure, void>> call({
    required String email,
    required String password,
  }) =>
      _repo.signIn(email: email, password: password);
}

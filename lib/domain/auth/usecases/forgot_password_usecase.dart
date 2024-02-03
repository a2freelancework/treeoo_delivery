// ignore_for_file: lines_longer_than_80_chars

import 'package:dartz/dartz.dart';
import 'package:treeo_delivery/core/errors/failures.dart';
import 'package:treeo_delivery/domain/auth/repository/auth_repo.dart';

class ForgotPassword {
  const ForgotPassword(this._repo);

  final AuthRepo _repo;

  Future<Either<Failure, void>> call(String email) => _repo.forgotPassword(email);
}

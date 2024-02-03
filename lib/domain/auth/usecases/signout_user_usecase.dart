
import 'package:dartz/dartz.dart';
import 'package:treeo_delivery/core/errors/failures.dart';
import 'package:treeo_delivery/core/usecases/usecases.dart';
import 'package:treeo_delivery/domain/auth/repository/auth_repo.dart';

class SignOutUser extends UseCaseWithoutParam<void>{
  SignOutUser(this._repo);

  final AuthRepo _repo;
  @override
  Future<Either<Failure, void>> call() => _repo.signOut();  
}

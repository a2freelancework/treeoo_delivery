
import 'package:dartz/dartz.dart';
import 'package:treeo_delivery/core/errors/failures.dart';

abstract class UseCaseWithoutParam<Type>{
  const UseCaseWithoutParam();
  Future<Either<Failure, Type>> call();
}

abstract class UseCaseWithParam<Type, Param>{
  const UseCaseWithParam();
  Future<Either<Failure, Type>> call(Param param);  
}

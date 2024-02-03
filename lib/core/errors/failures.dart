import 'package:equatable/equatable.dart';
import 'package:treeo_delivery/core/errors/exceptions.dart';

abstract class Failure extends Equatable{
  const Failure({
    required this.message, required this.statusCode,
  });

  final String message;
  final dynamic statusCode;

  String get errorMessage => '$statusCode Error: $message';
  @override
  List<Object?> get props => [message, statusCode];
}

class CacheFailure extends Failure{
  const CacheFailure({required super.message, required super.statusCode});

  factory CacheFailure.fromException(){
   return const CacheFailure(
    message: 'Something went wrong', 
    statusCode: 400,
   ); 
  }  
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, required super.statusCode});
  
  factory ServerFailure.fromException(ServerException e){
    return ServerFailure(
      message: e.message, 
      statusCode: e.statusCode,
    );
  }
}

// ignore_for_file: lines_longer_than_80_chars

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:treeo_delivery/core/errors/exceptions.dart';
import 'package:treeo_delivery/core/errors/failures.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/core/services/user_location_helper.dart';
import 'package:treeo_delivery/data/auth/data_source/auth_data_src.dart';
import 'package:treeo_delivery/data/auth/data_source/email_password_src.dart';
import 'package:treeo_delivery/data/auth/model/pickup_user_model.dart';
import 'package:treeo_delivery/domain/auth/entity/pickup_user.dart';
import 'package:treeo_delivery/domain/auth/entity/vehicle.dart';
import 'package:treeo_delivery/domain/auth/repository/auth_repo.dart';

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl(this._dataSrc, this._emailPaswdAuth);

  final AuthDataSrc _dataSrc;

  final EmailPasswordAuth _emailPaswdAuth;
  @override
  Either<Failure, PickupUser> getUserFromCache() {
    try {
      final result = _dataSrc.getUserFromCache();
      debugPrint(' ==== GET USER FROM CACHE ==== ');
      return Right(result);
    } on CacheException catch (e) {
      debugPrint(' == getUserFromCache === $e === ');
      return Left(CacheFailure(message: e.message, statusCode: e.statusCode));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _dataSrc.resetCache();
      await _emailPaswdAuth.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _emailPaswdAuth.signUp(email: email, password: password);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> signIn({
    required String email,
    required String password,
  }) async {
    
    try {
      final user = await _emailPaswdAuth.signIn(email: email, password: password,);
      await _dataSrc.saveUserDataLocally(user);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    } catch (e) {
      return Left(ServerFailure(message: e.toString(), statusCode: '500'));
    }
  }

  @override
  Future<Either<Failure, void>> forgotPassword(String email) async {
    try {
      await _emailPaswdAuth.sendPasswordResetLink(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, Iterable<Vehicle>>> getVehicles() async {
    try {
      final vehicls = await _emailPaswdAuth.getVehicles();
      return Right(vehicls);
    } on ServerException catch (e) {
      return Left(ServerFailure.fromException(e));
    }
  }

  @override
  Future<Either<Failure, void>> cacheVehicleOrLocation({
    Vehicle? vehicle,
    UserLocation? location,
  }) async {
    var user = UserAuth.I.currentUser as PickupUserModel?;
    try {
      user = user!.copyWith(
        vehicle: vehicle,
        pickupLocation: location,
      );

      await _dataSrc.saveUserDataLocally(user);
      if (location != null) {
        await _emailPaswdAuth.updateUserLocation(location);
      }
      return const Right(null);
    } on ServerException catch (e) {
      debugPrint('**** ******   [ERROR] ********* *****');
      return Left(ServerFailure.fromException(e));
    }
  }
}

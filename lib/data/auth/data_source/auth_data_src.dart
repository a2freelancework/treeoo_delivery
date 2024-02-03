// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treeo_delivery/core/errors/exceptions.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/data/auth/model/pickup_user_model.dart';
// import 'package:treeo_delivery/domain/auth/entity/pickup_user.dart' show PickupUserExpiry;

abstract class AuthDataSrc {
  const AuthDataSrc();
  PickupUserModel getUserFromCache();

  // Future<PickupUserModel> getUserFromServer({
  //   required String phone,
  //   required String password,
  // });

  Future<void> resetCache();

  Future<void> saveUserDataLocally(PickupUserModel data);
}

const _pickupUser = 'PICKUP_USER_DATA';

class AuthDataSrcImpl extends AuthDataSrc {
  const AuthDataSrcImpl(this._pref);

  final SharedPreferences _pref;

  @override
  PickupUserModel getUserFromCache() {
    try {
      final result = _pref.getString(_pickupUser);
      if (result == null) {
        throw const CacheException(message: 'User not found', statusCode: 500);
      }
      final user = PickupUserModel.fromCacheMap(
        jsonDecode(result) as Map<String, dynamic>,
      );
      // if (user.isSessionExpired) {
      //   throw const CacheException(message: 'Session Expired',statusCode: 500);
      // }
      UserAuth.I.setUser = user;
      return user;
    } on CacheException {
      rethrow;
    } catch (e) {
      throw CacheException(message: e.toString(), statusCode: 500);
    }
  }

  // @override
  // Future<PickupUserModel> getUserFromServer({
  //   required String phone,
  //   required String password,
  // }) async {
  //   try {
  //     final snapshot = await _fs
  //         .collection(_staffCol)
  //         .where('staff_number', isEqualTo: phone)
  //         .where('staff_password', isEqualTo: password)
  //         .limit(1)
  //         .get()
  //         .then((querySnapshot) => querySnapshot.docs.first);
  //     final user = PickupUserModel.fromQueryMap(snapshot.id, snapshot.data());
  //     await _saveUserDataLocally(user);
  //     UserAuth.instance.setUser = user;
  //     return user;
  //   } on FirebaseException catch (e) {
  //     throw ServerException(
  //       message: e.message ?? 'Something went wrong',
  //       statusCode: e.code,
  //     );
  //   } catch (e) {
  //     throw ServerException(message: e.toString(), statusCode: '505');
  //   }
  // }

  @override
  Future<void> resetCache() async {
    try {
      await _pref.clear();
      UserAuth.I.reset();
    } catch (e) {
      throw const CacheException(
        message: 'Something wnt wrong',
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> saveUserDataLocally(PickupUserModel data) async {
    try {
      final res = getUserFromCache();
      if (res != data) {
        /// clear all cached data if both models are not equel
        await _pref.clear();
      }
    } catch (e) {
      debugPrint(' ======= saveUserDataLocally [1] $e ======= ');
    }
    try {
      debugPrint(data.toMap().toString());
      await _pref.setString(_pickupUser, jsonEncode(data.toMap()));
      UserAuth.I.setUser = data;
    } catch (e) {
      debugPrint(' ======= saveUserDataLocally [2] $e ======= ');
    }
  }
}

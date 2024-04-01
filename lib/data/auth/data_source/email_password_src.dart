// ignore_for_file: lines_longer_than_80_chars, unnecessary_null_checks

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:treeo_delivery/core/errors/exceptions.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/core/services/user_location_helper.dart';
import 'package:treeo_delivery/data/auth/model/pickup_user_model.dart';
import 'package:treeo_delivery/domain/auth/entity/vehicle.dart';

abstract class EmailPasswordAuth {
  const EmailPasswordAuth();
  Future<void> signUp({
    required String email,
    required String password,
  });
  Future<PickupUserModel> signIn({
    required String email,
    required String password,
  });
  Future<void> sendVerificationEmail();
  Future<void> sendPasswordResetLink(String email);
  Future<void> signOut();

  Future<Iterable<Vehicle>> getVehicles();

  Future<void> updateUserLocation(UserLocation location);
}

const _staffCol = 'staff_details';
const _vehicle = 'pickup_vehicle';
const _statusController = 'treeoo_status_control';
const _admin = 'ADMIN';

class EmailPasswordAuthImpl implements EmailPasswordAuth {
  const EmailPasswordAuthImpl({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _fs = firestore;

  final FirebaseAuth _auth;
  final FirebaseFirestore _fs;

  @override
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint(' $credential ');
      await sendVerificationEmail();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        await _ifEmailAlreadyUsedReSendLink(email: email, password: password);
      } else {
        debugPrint('[FirebaseAuthException] signUp:  ${e.code}');
        throw ServerException(
          message: e.code.replaceAll('-', ' '),
          statusCode: '400',
        );
      }
    } catch (e) {
      debugPrint('signUp :: ERROR $e');
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<PickupUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      debugPrint(' ******************************* *****************');
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint(' $credential *****************');
      if (!credential.user!.emailVerified) {
        // email not verified
        await sendVerificationEmail();
        throw const ServerException(
          message:
              "Your acoount isn't verified yet. Verification link has been sent to your email. Please check!",
          statusCode: '400',
        );
      }
      return await _getUserFromDB();
    } on FirebaseAuthException catch (e) {
      debugPrint('[FirebaseAuthException] signIn:  ${e.code}');
      throw ServerException(
        message: e.code.replaceAll('-', ' '),
        statusCode: '400',
      );
    } on ServerException {
      rethrow;
    } catch (e) {
      debugPrint('signIp :: ERROR $e');
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> sendVerificationEmail() async {
    await _auth.currentUser!.sendEmailVerification();
  }

  @override
  Future<void> sendPasswordResetLink(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      debugPrint('[FirebaseAuthException] sendVerificationEmail:  ${e.code}');
      throw ServerException(
        message: e.code.replaceAll('-', ' '),
        statusCode: '400',
      );
    } catch (e) {
      debugPrint('sendVerificationEmail :: ERROR $e');
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      debugPrint('[FirebaseAuthException] signOut:  ${e.code}');
      throw ServerException(
        message: e.code.replaceAll('-', ' '),
        statusCode: '400',
      );
    } catch (e) {
      debugPrint('signOut :: ERROR $e');
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  Future<PickupUserModel> _getUserFromDB() async {
    try {
      debugPrint('currentUser: ${_auth.currentUser?.uid}');
      final snapshot =
          await _fs.collection(_staffCol).doc(_auth.currentUser!.uid).get();
      if (snapshot.data() == null) {
        await _createUserData();
        throw const ServerException(
          message: 'Waiting for admin aproval. Contact admin.',
          statusCode: '400',
        );
      } else if (snapshot.data()!['status'] != 'ACTIVE') {
        var errorMsg = '';
        if (snapshot.data()!['status'] == 'NEW') {
          errorMsg = 'Waiting for admin aproval. Contact admin.';
        } else {
          errorMsg = 'You are blocked by admin. Contact admin.';
        }
        throw ServerException(
          message: errorMsg,
          statusCode: '400',
        );
      }
      final user = PickupUserModel.fromQueryMap(snapshot.id, snapshot.data()!);
      UserAuth.I.setUser = user;
      return user;
    } on FirebaseException catch (e) {
      throw ServerException(
        message: e.message ?? 'Something went wrong',
        statusCode: e.code,
      );
    } on ServerException catch (e, s){
      debugPrint('ServerException  ==== $e ==== ');
      debugPrint(s.toString());
      rethrow;
    } catch (e, s) {
      debugPrint('catch ==== $e ==== ');
      debugPrint(s.toString());
      throw ServerException(message: e.toString(), statusCode: '505');
    }
  }

  Future<void> _createUserData() async {
    await _fs.collection(_staffCol).doc(_auth.currentUser!.uid).set({
        'created_date': DateTime.now(),
        'email': _auth.currentUser!.email!,
        'status': 'NEW',
      });
    await _fs.collection(_statusController).doc(_admin).update({
      'new_staff_register_date': DateTime.now(),
    });
  }

  Future<void> _ifEmailAlreadyUsedReSendLink({
    required String email,
    required String password,
  }) async {
    try {
      await signIn(email: email, password: password)
          .then((value) => sendVerificationEmail());
    } on FirebaseAuthException catch (e) {
      debugPrint(
        '[FirebaseAuthException] _ifEmailAlreadyUsedReSendLink:  ${e.code}',
      );
      throw ServerException(
        message: e.code.replaceAll('-', ' '),
        statusCode: '400',
      );
    } catch (e) {
      debugPrint('_ifEmailAlreadyUsedReSendLink :: ERROR $e');
      throw ServerException(
        message: e.toString(),
        statusCode: '500',
      );
    }
  }

  @override
  Future<Iterable<Vehicle>> getVehicles() async {
    try {
      return await _fs.collection(_vehicle).get().then((value) {
        return value.docs.map((e) {
          final map = e.data();
          map['id'] = e.id;
          return Vehicle.fromMap(map);
        });
      });
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: e.code.replaceAll('-', ' '),
        statusCode: '400',
      );
    } catch (e) {
      throw ServerException(message: e.toString(), statusCode: '500');
    }
  }

  @override
  Future<void> updateUserLocation(UserLocation location) async {
    try {
      final user = UserAuth.I.currentUser!;
      await _fs.collection(_staffCol).doc(user.uid).update({
        'staff_district': location.name,
      });
    } catch (e) {
      debugPrint('$e');
    }
  }
}

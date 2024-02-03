// ignore_for_file: lines_longer_than_80_chars

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:treeo_delivery/core/services/injection_container.dart' show sl;

const _credential = 'LOGIN_CREDENTIAL';

class Helper {
  Helper._();

  static Future<void> saveLoginCredential({
    required String email,
    required String password,
  }) async {
    await sl.get<SharedPreferences>().setString(
          _credential,
          jsonEncode({
            'email': email,
            'password': password,
          }),
        );
  }

  static ({String email, String password}) getLoginCredential() {
    try {
      final cred = sl.get<SharedPreferences>().getString(_credential);
      final res = jsonDecode(cred ?? '') as Map;
      return (
        email: res['email'] as String,
        password: res['password'] as String
      );
    } catch (e) {
      return (email: '', password: '');
    }
  }
}

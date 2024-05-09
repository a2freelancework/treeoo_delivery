// ignore_for_file: lines_longer_than_80_chars

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:treeo_delivery/core/utils/type_def.dart';

const _statusCtrl = 'treeoo_status_control';
const _appVersionDoc = 'APP_VERSIONS';
const _staffAppVersion = 'STAFF_APP_VERSION';

// const _iOSV = '1.0.0';
const _androidV = '3.0.1';

class AppVersion {
  AppVersion._();

  static final AppVersion _instance = AppVersion._();
  static final AppVersion I = _instance;

  static final _fs = FirebaseFirestore.instance;

  String? _version;
  String? get version => _version;

  (int, int, int) _versionToInts(String text) {
    final s = text.split('.').map(int.parse).toList();
    return (s[0], s[1], s[2]);
  }

  Future<void> getVersionFromDataBase() async {
    try {
      _version =
          await _fs.collection(_statusCtrl).doc(_appVersionDoc).get().then(
                (snap) => (snap.data()![_staffAppVersion] as DataMap)['android']
                    as String,
              );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  bool isNeedToForceUpdate() {
    assert(_version != null, 'version can not be null');
    try {
      final mainV = _versionToInts(_version!); //latest version in database
      final cAppVn = _versionToInts(_androidV); //current version

      if (mainV.$1 > cAppVn.$1) {
        return true;
      } else if (mainV.$1 == cAppVn.$1 && mainV.$2 > cAppVn.$2) {
        return true;
      } else if (mainV.$1 == cAppVn.$1 &&
          mainV.$2 == cAppVn.$2 &&
          mainV.$3 > cAppVn.$3) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

}

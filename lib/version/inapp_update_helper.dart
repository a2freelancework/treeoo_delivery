// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:treeo_delivery/core/utils/string_constants.dart';
import 'package:treeo_delivery/presentation/widget/helper_class/url_launcher_helper.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/version/app_version.dart';

class InAppUpdateHelper {
  const InAppUpdateHelper._();
  static GlobalKey<ScaffoldState> inAppUpdateKey =
      GlobalKey(debugLabel: 'inAppUpdateKey');
  static void showSnack(String text) {
    _hello += '$text\n';
    if (inAppUpdateKey.currentContext != null) {
      ScaffoldMessenger.of(inAppUpdateKey.currentContext!)
        ..removeCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: SelectableText(_hello),
            // duration: const Duration(hours: 1),
          ),
        );
      // Future.delayed(const Duration(seconds: 1), () {
      //   showDialog<void>(
      //     context: inAppUpdateKey.currentContext!,
      //     builder: (_) {
      //       return Dialog(
      //         alignment: Alignment.center,
      //         child: Text(text),
      //       );
      //     },
      //   );
      // });
    }
  }

  static String _hello = '';
  static bool _forceUpdate = false;

  static Future<void> checkForUpdate() async {
    try {
      await InAppUpdate.checkForUpdate().then((info) async {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          _forceUpdate = AppVersion.I.isNeedToForceUpdate();
          if (_forceUpdate) {
            if (_overlayEntry == null) {
              await _immediateUpdate().then((res) async {
                if (!res) {
                  await _showUpdateOverlay(inAppUpdateKey.currentContext!);
                } else {
                  removeOverlay();
                }
              });
            } else {
              await _showUpdateOverlay(inAppUpdateKey.currentContext!);
            }
          } else {
            await _flexibleUpdate();
          }
        }
      });
    } catch (e) {
      // showSnack('$e');
      debugPrint('-----------  TTTTTTTT');
    }
  }

  static void removeOverlay() {
    _overlayEntry?.remove();
  }

  static Future<bool> _immediateUpdate() async {
    final res = await InAppUpdate.performImmediateUpdate();
    return res == AppUpdateResult.success;
  }

  static Future<void> showBtmS() async {
    await _showUpdateOverlay(inAppUpdateKey.currentContext!);
  }

  static Future<void> _flexibleUpdate() async {
    await InAppUpdate.startFlexibleUpdate().then((res) {
      if (res == AppUpdateResult.inAppUpdateFailed) {
        showSnack('Update failed');
      }
    });
  }

  static OverlayEntry? _overlayEntry;
  static Future<void> _showUpdateOverlay(BuildContext context) async {
    _overlayEntry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.black38,
        child: Center(
          child: Container(
            height: 280,
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Update required',
                  style: TextStyle(
                    color: Colors.black,
                    // letterSpacing: .5,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Image.asset(
                      'assets/icon/icon.png',
                      width: 50,
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      'ScrapBee Staff',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                const Text(
                  'To continue using Scrapbee Staff, an update is necessary. Kindly tap the button below to access the Play Store and update the app.',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Align(
                  child: ElevatedButton(
                    onPressed: () async {
                      await UrlLaunchingHelper.link(
                        StringConst.APP_PLAYSTORE_LINK,
                      ).then((value) {
                        checkForUpdate();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(200, 45),
                      backgroundColor: darkgreen,
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  // static Future<void> _showUpdateBottomSheet(
  //   BuildContext context,
  // ) async {
  //   await showModalBottomSheet<void>(
  //     context: context,
  //     isDismissible: false,
  //     enableDrag: false,
  //     builder: (BuildContext context) {
  //       return SizedBox(
  //         height: 280, // Background color for modal barrier
  //         child: Container(
  //           padding: const EdgeInsets.all(20),
  //           decoration: BoxDecoration(
  //             color: Theme.of(context).canvasColor,
  //             borderRadius: const BorderRadius.only(
  //               topLeft: Radius.circular(10),
  //               topRight: Radius.circular(10),
  //             ),
  //           ),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: <Widget>[
  //               const Text(
  //                 'Update required',
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   // letterSpacing: .5,
  //                   fontSize: 18,
  //                 ),
  //               ),
  //               const SizedBox(height: 20),
  //               Row(
  //                 children: [
  //                   Image.asset(
  //                     'assets/icon/icon.png',
  //                     width: 50,
  //                   ),
  //                   const SizedBox(width: 15),
  //                   const Text(
  //                     'ScrapBee Staff',
  //                     style: TextStyle(
  //                       color: Colors.black,
  //                       fontSize: 14,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //               const SizedBox(height: 5),
  //               const Text(
  //                 'To continue using Scrapbee Staff, an update is necessary. Kindly tap the button below to access the Play Store and update the app.',
  //                 style: TextStyle(
  //                   color: Colors.black,
  //                   fontSize: 14,
  //                 ),
  //               ),
  //               const Spacer(),
  //               Align(
  //                 child: ElevatedButton(
  //                   onPressed: () async {
  //                     await UrlLaunchingHelper.link(
  //                       StringConst.APP_PLAYSTORE_LINK,
  //                     ).then((value) {
  //                       Navigator.pop(context);
  //                       checkForUpdate();
  //                     });
  //                   },
  //                   style: ElevatedButton.styleFrom(
  //                     minimumSize: const Size(200, 45),
  //                     backgroundColor: darkgreen,
  //                   ),
  //                   child: const Text(
  //                     'Update',
  //                     style: TextStyle(color: Colors.white),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

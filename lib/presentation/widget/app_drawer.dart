import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/core/utils/string_constants.dart';
import 'package:treeo_delivery/presentation/widget/helper_class/url_launcher_helper.dart';
import 'package:treeo_delivery/presentation/widget/logout_popup.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: darkgreen,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  Appname,
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                      color: whiteColor,
                      letterSpacing: .5,
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  UserAuth.I.currentUser?.name ?? '',
                  style: GoogleFonts.roboto(
                    textStyle:  TextStyle(
                      color: Colors.grey.shade300,
                      letterSpacing: .5,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Text(
                  UserAuth.I.currentUser?.email ?? '',
                  style: GoogleFonts.roboto(
                    textStyle: TextStyle(
                      color: Colors.grey.shade300,
                      letterSpacing: .5,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.document_scanner_rounded),
            title: const Text('Terms And Conditions'),
            onTap: () {
              UrlLaunchingHelper.link(StringConst.LINK_TERMS_AND_CONDITION);
            },
          ),
          ListTile(
            leading: const Icon(Icons.call),
            title: const Text('Call Us'),
            onTap: () {
              UrlLaunchingHelper.phone(StringConst.CONTACT_US_NO);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
              ConfirmDialog.showConfirmDialog(context);
            },
          ),
        ],
      ),
    );
  }
}

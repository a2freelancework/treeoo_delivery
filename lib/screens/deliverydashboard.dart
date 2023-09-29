import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:treeo_delivery/widget/reusable_colors.dart';

class DeliveryDashboard extends StatefulWidget {
  const DeliveryDashboard({super.key});

  @override
  State<DeliveryDashboard> createState() => _DeliveryDashboardState();
}

class _DeliveryDashboardState extends State<DeliveryDashboard> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: darkgreen,
        iconTheme: const IconThemeData(color: whiteColor),
        toolbarHeight: height * .09,
        title: Text(
          "Profile",
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
                color: whiteColor,
                letterSpacing: .5,
                fontSize: 25,
                fontWeight: FontWeight.w500),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: darkgreen,
              ),
              child: Text(
                Appname,
                style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      color: whiteColor,
                      letterSpacing: .5,
                      fontSize: 25,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: const Column(
        children: [],
      ),
    );
  }
}

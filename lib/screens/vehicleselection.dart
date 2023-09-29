import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:treeo_delivery/screens/deliverydashboard.dart';
import 'package:treeo_delivery/widget/reusable_colors.dart';
import 'package:treeo_delivery/widget/reusablewidgets.dart';

class VehicleSelection extends StatefulWidget {
  const VehicleSelection({super.key});

  @override
  State<VehicleSelection> createState() => _VehicleSelectionState();
}

class _VehicleSelectionState extends State<VehicleSelection> {
  int selectedindex = 0;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Padding(
        padding: EdgeInsets.only(left: width * .06, right: width * .06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            Image.asset(
              'images/vann.png',
              width: width * .5,
            ),
            Text(
              "Select Vehicle",
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                    color: darkgreen,
                    letterSpacing: .5,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              width: width,
              height: height * .6,
              child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 1.2,
                    crossAxisCount: 2, // number of items in each row
                    // spacing between columns
                  ),
                  itemCount: 4,
                  itemBuilder: (BuildContext ctx, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedindex = index;
                          });
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            color: peahcream,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              'images/vann.png',
                                              width: width * .24,
                                            ),
                                            Text(
                                              "KL 16 A 1273",
                                              style: GoogleFonts.roboto(
                                                textStyle: const TextStyle(
                                                    color: darkgreen,
                                                    letterSpacing: .5,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    selectedindex == index
                                        ? const Icon(
                                            Icons.verified,
                                            color: darkgreen,
                                          )
                                        : const SizedBox()
                                  ]),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const DeliveryDashboard()),
                );
              },
              child: Confirmcontainer(
                width: width * .8,
                height: height * .07,
                color: darkgreen,
                child: Center(
                  child: Text(
                    "Continue",
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          color: whiteColor,
                          letterSpacing: .5,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            const Spacer()
          ],
        ),
      ),
    );
  }
}

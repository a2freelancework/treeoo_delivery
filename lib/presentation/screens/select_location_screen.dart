// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:treeo_delivery/core/services/user_location_helper.dart';
import 'package:treeo_delivery/core/utils/snack_bar.dart';
import 'package:treeo_delivery/domain/auth/usecases/save_selected_vehicle.dart';
import 'package:treeo_delivery/presentation/screens/deliverydashboard.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/reusablewidgets.dart';

class SelectLocation extends StatefulWidget {
  const SelectLocation({super.key});

  @override
  State<SelectLocation> createState() => _SelectLocationState();
}

class _SelectLocationState extends State<SelectLocation> {
  late final CacheVehicleOrLocation _saveSelectedLocation =
      GetIt.I.get<CacheVehicleOrLocation>();
  int _selectedindex = 0;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
  }

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
            Lottie.asset(
              'images/location.json',
              width: width * .5,
            ),
            Text(
              'Select Location',
              style: GoogleFonts.roboto(
                textStyle: const TextStyle(
                  color: darkgreen,
                  letterSpacing: .5,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(
              width: width,
              height: height * .5,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 1.1,
                  crossAxisCount: 2, // number of items in each row
                  // spacing between columns
                ),
                itemCount: LocationList.list.length,
                itemBuilder: (BuildContext ctx, index) {
                  final location = LocationList.list[index];
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedindex = index;
                        });
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: ColoredBox(
                          color: peahcream,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Stack(
                              // alignment: Alignment.topRight,
                              alignment: Alignment.topCenter,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.asset(
                                      'images/location.png',
                                      width: width * .15,
                                    ),
                                    Text(
                                      location.name,
                                      style: GoogleFonts.roboto(
                                        textStyle: const TextStyle(
                                          color: darkgreen,
                                          letterSpacing: .5,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                // Row(
                                //   mainAxisAlignment: MainAxisAlignment.center,
                                //   children: [
                                //   ],
                                // ),
                                if (_selectedindex == index)
                                  const Positioned(
                                    right: 0,
                                    child: Icon(
                                      Icons.verified,
                                      color: darkgreen,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isSaving)
              const Center(
                child: CircularProgressIndicator(),
              )
            else
              GestureDetector(
                onTap: () {
                  _cacheSelectedLocationTo(LocationList.list[_selectedindex])
                      .then(
                    (value) => Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (context) => const DeliveryDashboard(),
                      ),
                    ),
                  );
                },
                child: Confirmcontainer(
                  width: width * .8,
                  height: height * .07,
                  color: darkgreen,
                  child: Center(
                    child: Text(
                      'Continue',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                          color: whiteColor,
                          letterSpacing: .5,
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Future<void> _cacheSelectedLocationTo(UserLocation location) async {
    setState(() {
      _isSaving = true;
    });
    await _saveSelectedLocation(
      location: location,
    ).then((value) {
      value.fold(
        (failure) {
          AppSnackBar.showSnackBar(context, failure.errorMessage);
        },
        (_) {
          setState(() {
            _isSaving = false;
          });
        },
      );
    });
  }
}

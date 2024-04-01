// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/core/utils/snack_bar.dart';
import 'package:treeo_delivery/domain/auth/entity/vehicle.dart';
import 'package:treeo_delivery/domain/auth/usecases/get_vehicles.dart';
import 'package:treeo_delivery/domain/auth/usecases/save_selected_vehicle.dart';
import 'package:treeo_delivery/presentation/screens/select_location_screen.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/reusablewidgets.dart';

class VehicleSelection extends StatefulWidget {
  const VehicleSelection({super.key});

  @override
  State<VehicleSelection> createState() => _VehicleSelectionState();
}

class _VehicleSelectionState extends State<VehicleSelection> {
  int _selectedindex = 0;
  bool _isloading = true;
  bool _isSaving = false;
  List<Vehicle> _vehicles = [];
  final GetVehicles _getVehicles = GetIt.I.get<GetVehicles>();
  late final CacheVehicleOrLocation _saveSelectedVehicles = GetIt.I.get<CacheVehicleOrLocation>();

  @override
  void initState() {
    super.initState();
    _getVehiclesFromServer();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: whiteColor,
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.only(left: width * .06, right: width * .06),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Spacer(),
                  Lottie.asset(
                    'images/delivery.json',
                    width: width * .7,
                  ),
                  Text(
                    'Select Vehicle',
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.1,
                        crossAxisCount: 2, // number of items in each row
                        // spacing between columns
                      ),
                      itemCount: _vehicles.length,
                      itemBuilder: (BuildContext ctx, index) {
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
                                    alignment: Alignment.topRight,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Image.asset(
                                                'images/vann.png',
                                                width: width * .24,
                                              ),
                                              Text(
                                                _vehicles[index].number,
                                                style: GoogleFonts.roboto(
                                                  textStyle: const TextStyle(
                                                    color: darkgreen,
                                                    letterSpacing: .5,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      if (_selectedindex == index)
                                        const Icon(
                                          Icons.verified,
                                          color: darkgreen,
                                        )
                                      else
                                        const SizedBox(),
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
                  if (_isSaving) const Center(
                          child: CircularProgressIndicator(),
                        ) else GestureDetector(
                          onTap: () {
                            _cacheSelectedVehicleTo(_vehicles[_selectedindex])
                                .then((value) => Navigator.push(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (context) =>
                                            const SelectLocation(),
                                      ),
                                    ),);
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

  Future<void> _getVehiclesFromServer() async {
    await _getVehicles().then((value) {
      value.fold(
        (failure) {
          AppSnackBar.showSnackBar(context, failure.errorMessage);
        },
        (vehicles) {
          _vehicles = vehicles.toList();
          setState(() {
            _isloading = false;
          });
        },
      );
    });
    debugPrint('UserAuth.I.currentUser:  ${UserAuth.I.currentUser}');
  }

  Future<void> _cacheSelectedVehicleTo(Vehicle vehicle) async {
    setState(() {
      _isSaving = true;
    });
    await _saveSelectedVehicles(
      vehicle: vehicle,
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

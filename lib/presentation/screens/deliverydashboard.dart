// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:treeo_delivery/core/extensions/context_ext.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/domain/auth/entity/pickup_user.dart';
import 'package:treeo_delivery/main.dart';
import 'package:treeo_delivery/presentation/authentication/auth_bloc/auth_bloc.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/pending_assigned_order_cubit/pending_assigned_order_cubit.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/pending_orders_screen.dart';
import 'package:treeo_delivery/presentation/screens/2_add_orders/add_new_order_cubit/add_new_order_cubit.dart';
import 'package:treeo_delivery/presentation/screens/2_add_orders/add_orders_screen.dart';
import 'package:treeo_delivery/presentation/screens/3_order_history/order_history_screen.dart';
import 'package:treeo_delivery/presentation/screens/4_scrap_collection/scrap_collection_screen.dart';
import 'package:treeo_delivery/presentation/widget/app_drawer.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/reusablewidgets.dart';
import 'package:treeo_delivery/version/inapp_update_helper.dart';

class DeliveryDashboard extends StatefulWidget {
  const DeliveryDashboard({super.key});

  @override
  State<DeliveryDashboard> createState() => _DeliveryDashboardState();
}

class _DeliveryDashboardState extends State<DeliveryDashboard> {
  PickupUser? _user;

  @override
  void initState() {
    super.initState();
    _user = UserAuth.I.currentUser;
    InAppUpdateHelper.checkForUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final kHeight01 = SizedBox(height: height * .01);
    return Scaffold(
      backgroundColor: whiteColor,
      key: InAppUpdateHelper.inAppUpdateKey,
      appBar: AppBar(
        backgroundColor: darkgreen,
        iconTheme: const IconThemeData(color: whiteColor),
        toolbarHeight: height * .09,
        title: Text(
          _user?.pickupLocation?.name ?? '',
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              color: whiteColor,
              letterSpacing: .5,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (_, st) => st is AuthLoggedOut,
        listener: (context, state) {
          context.pushAndRemoveUntil(const AuthPage());
        },
        child: Padding(
          padding: EdgeInsets.only(left: width * .05, right: width * .05),
          child: _user != null
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Spacer(),
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: extralightgreen,
                      child: Image.asset(
                        'images/bot1.png',
                        fit: BoxFit.fill,
                      ),
                    ),
                    const Spacer(),
                    _StaffDataRow(
                      label: 'Name',
                      value: _user!.name,
                    ),
                    kHeight01,
                    _StaffDataRow(
                      label: 'Mobile Number',
                      value: _user!.phone,
                    ),
                    kHeight01,
                    _StaffDataRow(
                      label: 'Vehicle Number',
                      value: _user!.vehicle?.number ?? 'NOT SELECTED',
                    ),
                    kHeight01,
                    _StaffDataRow(
                      label: 'Vehicle Name',
                      value: _user!.vehicle?.name ?? 'NOT SELECTED',
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Scrap Orders',
                        style: GoogleFonts.roboto(
                          textStyle: const TextStyle(
                            color: blackColor,
                            letterSpacing: .5,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height * .02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomContainer(
                          onTap: () {
                            pushScreen(
                              BlocProvider(
                                create: (context) =>
                                    GetIt.I.get<PendingAssignedOrderCubit>()
                                      ..getAllPendingAssignedOrders(),
                                child: const PendingOrderScreen(),
                              ),
                            );
                          },
                          heading: 'Scrap',
                          subheading: 'Orders',
                          icon: Icons.edit_document,
                        ),
                        CustomContainer(
                          onTap: () {
                            pushScreen(
                              BlocProvider(
                                create: (context) => AddNewOrderCubit(),
                                child: const AddOrdersScreen(),
                              ),
                            );
                          },
                          heading: 'Add',
                          subheading: 'Orders',
                          icon: Icons.document_scanner,
                        ),
                        CustomContainer(
                          onTap: () {
                            pushScreen(const OrderHistoryScreen());
                          },
                          heading: 'Scrap',
                          subheading: 'History',
                          icon: Icons.history,
                        ),
                      ],
                    ),
                    SizedBox(height: height * .02),
                    Row(
                      children: [
                        CustomContainer(
                          onTap: () {
                            pushScreen(const ScrapCollectionScreen());
                          },
                          heading: 'Scrap',
                          subheading: 'Collections',
                          icon: Icons.collections_bookmark,
                        ),
                      ],
                    ),
                    const Spacer(),
                  ],
                )
              : const Center(
                  child: Text('Something went wrong! Please login again.'),
                ),
        ),
      ),
    );
  }

  Future<void> pushScreen(Widget page) async {
    await Navigator.of(context).push(
      PageAnimationTransition(
        page: page,
        pageAnimationType: FadeAnimationTransition(),
      ),
    );
  }
}

class _StaffDataRow extends StatelessWidget {
  const _StaffDataRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              color: subtext,
              letterSpacing: .5,
              fontSize: 17,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.roboto(
            textStyle: const TextStyle(
              color: darkgreen,
              letterSpacing: .5,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

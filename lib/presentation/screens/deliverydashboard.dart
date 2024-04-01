// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/domain/auth/entity/pickup_user.dart';
import 'package:treeo_delivery/main.dart';
import 'package:treeo_delivery/presentation/authentication/auth_bloc/auth_bloc.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/pending_assigned_order_cubit/pending_assigned_order_cubit.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/pending_orders.dart';
import 'package:treeo_delivery/presentation/screens/2_add_orders/add_new_order_cubit/add_new_order_cubit.dart';
import 'package:treeo_delivery/presentation/screens/2_add_orders/add_orders_screen.dart';
import 'package:treeo_delivery/presentation/screens/3_scrap_history/scrap_history_screen.dart';
import 'package:treeo_delivery/presentation/screens/4_scrap_collection/scrap_collection_cubit/scrap_collection_cubit.dart';
import 'package:treeo_delivery/presentation/screens/4_scrap_collection/scrap_collection_screen.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/reusablewidgets.dart';

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
  }

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
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.document_scanner_rounded),
              title: const Text('Terms And Conditions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rate Us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.call),
              title: const Text('Call Us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Log Out'),
              onTap: () {
                context.read<AuthBloc>().add(const AuthSignOutEvent());
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listenWhen: (_, st) => st is AuthLoggedOut,
        listener: (context, state) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(builder: (context) => const AuthPage()),
            (route) => false,
          );
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Name',
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
                          _user!.name,
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
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Mobile Number',
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
                          _user!.phone,
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
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vehicle Number',
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
                          _user!.vehicle?.number ?? 'NOT SELECTED',
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
                    ),
                    SizedBox(
                      height: height * .01,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Vehicle Name',
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
                          _user!.vehicle?.name ?? 'NOT SELECTED',
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
                    SizedBox(
                      height: height * .02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageAnimationTransition(
                                page: BlocProvider(
                                  create: (context) =>
                                      GetIt.I.get<PendingAssignedOrderCubit>()
                                        ..getAllPendingAssignedOrders(),
                                  child: const PendingOrderScreen(),
                                ),
                                pageAnimationType: FadeAnimationTransition(),
                              ),
                            );
                          },
                          child: CustomContainer(
                            heading: 'Scrap',
                            subheading: 'Orders',
                            icon: Icons.edit_document,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageAnimationTransition(
                                page: BlocProvider(
                                  create: (context) => AddNewOrderCubit(),
                                  child: const AddOrdersScreen(),
                                ),
                                pageAnimationType: FadeAnimationTransition(),
                              ),
                            );
                          },
                          child: CustomContainer(
                            heading: 'Add',
                            subheading: 'Orders',
                            icon: Icons.document_scanner,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageAnimationTransition(
                                page: const ScrapHistoryScreen(),
                                pageAnimationType: FadeAnimationTransition(),
                              ),
                            );
                          },
                          child: CustomContainer(
                            heading: 'Scrap',
                            subheading: 'History',
                            icon: Icons.history,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * .02,
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              PageAnimationTransition(
                                page: BlocProvider(
                                  create: (context) =>
                                      GetIt.I.get<ScrapCollectionCubit>()
                                        ..getMyCollection(),
                                  child: const ScrapCollectionScreen(),
                                ),
                                pageAnimationType: FadeAnimationTransition(),
                              ),
                            );
                          },
                          child: CustomContainer(
                            heading: 'Scrap',
                            subheading: 'Collections',
                            icon: Icons.collections_bookmark,
                          ),
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
}

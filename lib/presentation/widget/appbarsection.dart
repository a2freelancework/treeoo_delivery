// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:treeo_delivery/core/extensions/date_ext.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/core/utils/snack_bar.dart';
import 'package:treeo_delivery/data/orders/model/invoiced_scrap.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/presentation/screens/orderscreen/orderdetails.dart';
import 'package:treeo_delivery/presentation/screens/scrapcollection/collectiondetails.dart';
import 'package:treeo_delivery/presentation/screens/scrapcollection/scrap_collection_cubit/scrap_collection_cubit.dart';
import 'package:treeo_delivery/presentation/widget/helper_class/url_launcher_helper.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class AppbarSectionwithoutback extends StatelessWidget {
  const AppbarSectionwithoutback({required this.heading, super.key});
  final String heading;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Spacer(),
        Text(
          heading,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Gilroy',
            fontSize: 16,
            letterSpacing: .8,
            color: blackColor,
          ),
        ),
        const Spacer(),
      ],
    );
  }
}

class AppbarSection extends StatelessWidget {
  const AppbarSection({
    required this.heading,
    super.key,
    this.onBackTap,
  });
  final String heading;
  final void Function()? onBackTap;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: width * .04,
        ),
        BackshadowContainer(
          onTap: onBackTap,
        ),
        const Spacer(),
        Text(
          heading,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: 'Gilroy',
            fontSize: 16,
            letterSpacing: .8,
            color: blackColor,
          ),
        ),
        SizedBox(
          width: width * .13,
        ),
        const Spacer(),
      ],
    );
  }
}

class BackshadowContainer extends StatelessWidget {
  const BackshadowContainer({
    super.key,
    this.onTap,
  });
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.pop(context);
          },
      child: Container(
        width: width * .12,
        height: height * .06,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: whiteColor,
          border: Border.all(width: .5, color: const Color(0XFFB1B1B1)),
          // boxShadow: [
          //   BoxShadow(
          //     color: shadowcolor,
          //     // offset: Offset(0, 2),
          //     blurRadius: 3,
          //     spreadRadius: 1,
          //   ),
          // ],
        ),
        child: const Center(
          child: Icon(
            Icons.arrow_back_ios_new_outlined,
            size: 16,
            color: blackColor,
          ),
        ),
      ),
    );
  }
}

class OrderContainer extends StatelessWidget {
  const OrderContainer({
    required this.name,
    required this.onTap,
    super.key,
  });
  final String name;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width * .9,
        height: height * .055,
        decoration: BoxDecoration(
          color: darkgreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            name,
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: whiteColor,
                letterSpacing: .5,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomeContainer extends StatelessWidget {
  const CustomeContainer({
    required this.name,
    required this.containercolor,
    required this.onnTap,
    super.key,
  });
  final String name;
  final Color containercolor;
  final VoidCallback onnTap;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onnTap,
      child: Container(
        width: width * .43,
        height: height * .055,
        decoration: BoxDecoration(
          color: containercolor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            name,
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: whiteColor,
                letterSpacing: .5,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchBox extends StatefulWidget {
  const SearchBox({required this.onEditingComplete, super.key});
  final void Function(String text) onEditingComplete;

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  late final TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * .05,
      width: width * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: shadowcolor,
            // offset: Offset(0, 2),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextField(
        cursorColor: blackColor,
        controller: _searchController,
        onEditingComplete: () {
          widget.onEditingComplete(_searchController.text);
        },
        // controller: _emailController,
        decoration: InputDecoration(
          fillColor: whiteColor,
          filled: true,
          prefixIcon: const Icon(
            Icons.search,
            size: 18,
            color: otpgrey,
          ),
          hintText: 'Search Order',
          contentPadding: const EdgeInsets.all(1),
          hintStyle: const TextStyle(fontSize: 12, color: Color(0xff6B6B6B)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: whiteColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: whiteColor),
          ),
        ),
        style: const TextStyle(
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w400,
          color: Color(0xff6B6B6B),
        ),
        // maxLines: maxLines,
      ),
    );
  }
}

final phonInputFormat = [
  FilteringTextInputFormatter.allow(RegExp(r'^\d{0,10}')),
];

class CustomTextfeild extends StatelessWidget {
  const CustomTextfeild({
    required this.searchterm,
    this.prefixText,
    this.keyboardType,
    this.inputFormatters,
    this.controller,
    this.validator,
    this.readOnly = false,
    this.suffixIcon,
    super.key,
  });
  final String searchterm;
  final String? prefixText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final bool readOnly;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: height * .05,
      width: width * .9,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: shadowcolor,
            // offset: Offset(0, 2),
            blurRadius: 1,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        cursorColor: blackColor,
        onEditingComplete: () {},
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        readOnly: readOnly,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          fillColor: whiteColor,
          filled: true,
          hintText: searchterm,
          prefixText: prefixText,
          contentPadding: const EdgeInsets.all(8),
          hintStyle: const TextStyle(fontSize: 12, color: Color(0xff6B6B6B)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: whiteColor, width: .3),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: whiteColor, width: .3),
          ),
        ),
        style: const TextStyle(
          fontSize: 12,
          height: 1,
          fontWeight: FontWeight.w400,
          color: Color(0xff6B6B6B),
        ),
        // maxLines: maxLines,
      ),
    );
  }
}

class Scarpdetailcard extends StatelessWidget {
  const Scarpdetailcard({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final vehicle = UserAuth.I.currentUser!.vehicle!;
    return BlocBuilder<ScrapCollectionCubit, ScrapCollectionState>(
      builder: (context, state) {
        if (state is ScrapCollectionLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8), // padding around the grid
            itemCount: state.collection.length, // total number of items
            itemBuilder: (context, index) {
              final collection = state.collection.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageAnimationTransition(
                        page: CollectionDetails(collection: collection),
                        pageAnimationType: FadeAnimationTransition(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: peahcream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                UserAuth.I.currentUser!.name, //'sooraj',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                vehicle.number, //'KL 16 A 7654',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: red,
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
                                UserAuth.I.currentUser!.phone, //'8848990138',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                vehicle.name, //'Maruthi Super Carry',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is ScrapCollectionError) {
          return Center(
            child: Text(state.message),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class CustomerdeatilList extends StatefulWidget {
  const CustomerdeatilList({required this.orderStream, super.key});
  final Stream<Iterable<ScrapOrder>> orderStream;

  @override
  State<CustomerdeatilList> createState() => _CustomerdeatilListState();
}

class _CustomerdeatilListState extends State<CustomerdeatilList> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: widget.orderStream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          final orders = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8), // padding around the grid
            itemCount: orders.length, // total number of items
            itemBuilder: (context, index) {
              final order = orders.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageAnimationTransition(
                        page: OrderDetails(order: order),
                        pageAnimationType: FadeAnimationTransition(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: peahcream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.customerName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                // 'In Progress',
                                order.status,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: red,
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
                                order.phone,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                order.orderId,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
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
                                order.address,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              const SizedBox.shrink(),
                              // Text(
                              //   '123.9 KM',
                              //   style: TextStyle(
                              //     fontWeight: FontWeight.w500,
                              //     fontFamily: 'Gilroy',
                              //     fontSize: 15,
                              //     letterSpacing: .4,
                              //     color: blackColor,
                              //   ),
                              // ),
                            ],
                          ),
                          const Line(),
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.pickupDate.toDate,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () {
                                  try {
                                    UrlLaunchingHelper.whatsapp(order.phone);
                                  } on Exception catch (_) {
                                    AppSnackBar.showSnackBar(
                                      context,
                                      'WhatsApp not installed.',
                                    );
                                  }
                                },
                                child: Image.asset(
                                  'images/whatsapp.png',
                                  width: width * .08,
                                ),
                              ),
                              SizedBox(
                                width: width * .02,
                              ),
                              InkWell(
                                onTap: () {
                                  try {
                                    UrlLaunchingHelper.phone(order.phone);
                                  } on Exception catch (e) {
                                    debugPrint(e.toString());
                                  }
                                },
                                child: Image.asset(
                                  'images/call.png',
                                  width: width * .07,
                                ),
                              ),
                              SizedBox(
                                width: width * .02,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class RescheduledCustomerData extends StatelessWidget {
  const RescheduledCustomerData({required this.controller, super.key});
  final StreamController<Iterable<ScrapOrder>> controller;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: controller.stream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8), // padding around the grid
            itemCount: snapshot.data!.length, // total number of items
            itemBuilder: (_, index) {
              final order = snapshot.data!.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {
                    // Navigator.of(context).push(
                    //   PageAnimationTransition(
                    //     page: const OrderDetails(),
                    //     pageAnimationType: FadeAnimationTransition(),
                    //   ),
                    // );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: peahcream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                order.customerName, //'sooraj',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                order.status, //'In Progress',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: red,
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
                                order.phone, //'8848990138',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                order.orderId, //'ATREYV456FG',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                            ],
                          ),
                          // SizedBox(
                          //   height: height * .01,
                          // ),
                          // const Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //       'Poojapoora',
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.w500,
                          //         fontFamily: 'Gilroy',
                          //         fontSize: 15,
                          //         letterSpacing: .4,
                          //         color: blackColor,
                          //       ),
                          //     ),
                          //     Text(
                          //       '123.9 KM',
                          //       style: TextStyle(
                          //         fontWeight: FontWeight.w500,
                          //         fontFamily: 'Gilroy',
                          //         fontSize: 15,
                          //         letterSpacing: .4,
                          //         color: blackColor,
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          const Line(),
                          SizedBox(
                            height: height * .01,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Rescheduled By',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 14,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                'Sooraj',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 14,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Resceduled To',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 14,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                '20-Nov-2023',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 14,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          const Line(),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Amount',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 17,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                '₹ 11300',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Gilroy',
                                  fontSize: 17,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                            ],
                          ),
                          const Line(),
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                '12-Nov-2023',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              const Spacer(),
                              Image.asset(
                                'images/whatsapp.png',
                                width: width * .08,
                              ),
                              SizedBox(
                                width: width * .02,
                              ),
                              Image.asset(
                                'images/call.png',
                                width: width * .07,
                              ),
                              SizedBox(
                                width: width * .02,
                              ),
                              Image.asset(
                                'images/location.png',
                                width: width * .07,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class Line extends StatelessWidget {
  const Line({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      width: width,
      height: 10,
      child: const Divider(
        color: otpgrey,
        thickness: .4,
      ),
    );
  }
}

class OrderedItems extends StatefulWidget {
  const OrderedItems({required this.invoicedScraps, super.key});
  final InvoicedScrap invoicedScraps;

  @override
  State<OrderedItems> createState() => _OrderedItemsState();
}

class _OrderedItemsState extends State<OrderedItems> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        top: 20,
        left: 4,
        right: 4,
      ), // padding around the grid
      itemCount: widget.invoicedScraps.scraps.length,
      shrinkWrap: true,
      // total number of items
      itemBuilder: (context, index) {
        final scrap = widget.invoicedScraps.scraps[index];
        return Container(
          decoration: BoxDecoration(
            color: peahcream,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                scrap.icon,
                width: width * .15,
              ),
              SizedBox(
                height: height * .01,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    scrap.scrapName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Gilroy',
                      fontSize: 15,
                      letterSpacing: .4,
                      color: otpgrey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

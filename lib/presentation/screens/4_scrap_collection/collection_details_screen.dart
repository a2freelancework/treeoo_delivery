// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/core/extensions/date_ext.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/core/utils/calculation_helper.dart';
import 'package:treeo_delivery/domain/orders/entity/my_collection.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/style.dart';

class CollectionDetailsScreen extends StatefulWidget {
  const CollectionDetailsScreen({required this.collection, super.key});
  final MyCollection collection;

  @override
  State<CollectionDetailsScreen> createState() =>
      _CollectionDetailsScreenState();
}

class _CollectionDetailsScreenState extends State<CollectionDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final vehicle = UserAuth.I.currentUser!.vehicle!;
    final title = widget.collection.type == ScrapType.scrap ? 'Scrap' : 'Waste';
    final tColor = widget.collection.type == ScrapType.scrap
        ? Pallete.scrapGreen
        : Pallete.wasteOrange;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: height * .065,
            ),
            AppbarSection(
              heading: 'Collected $title Details',
            ),
            SizedBox(
              height: height * .015,
            ),
            Padding(
              padding: EdgeInsets.only(left: width * .05, right: width * .05),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Vehicle Number',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: otpgrey,
                        ),
                      ),
                      Text(
                        vehicle.number, //'KL 16 A 8765',
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
                      const Text(
                        'Vehicle Name',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: otpgrey,
                        ),
                      ),
                      Text(
                        vehicle.name, //'MARUTHI',
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
                      const Text(
                        'Date',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: otpgrey,
                        ),
                      ),
                      Text(
                        widget.collection.date.toDate, //'12-nov-2022',
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
                  SizedBox(height: height * .02),
                  LayoutBuilder(
                    builder: (_, con) {
                      return Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: con.maxWidth * 0.3,
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                color: darkgreen,
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Item',
                                  style: tStyle15W600.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                width: con.maxWidth * 0.2,
                                height: 40,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                color: darkgreen,
                                alignment: Alignment.center,
                                child: Text(
                                  'Qty',
                                  style: tStyle15W600.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                width: con.maxWidth * 0.25,
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                color: darkgreen,
                                alignment: Alignment.center,
                                child: Text(
                                  'Price',
                                  style: tStyle15W600.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                width: con.maxWidth * 0.25,
                                height: 40,
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                color: darkgreen,
                                alignment: Alignment.center,
                                child: Text(
                                  'Total',
                                  style: tStyle15W600.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero, // padding around the grid
                            itemCount: widget.collection.items
                                .length, // total number of items
                            itemBuilder: (context, index) {
                              // final scrap = order.invoicedScraps!.scraps[index];
                              final color = Color.lerp(
                                tColor,
                                Colors.black,
                                index.isEven ? 0 : 0.15,
                              )!;
                              const padding = EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              );
                              final item =
                                  widget.collection.items.elementAt(index);
                              return ColoredBox(
                                color: color,
                                child: Row(
                                  children: [
                                    Container(
                                      width: con.maxWidth * 0.32,
                                      padding: padding,
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        item.itemName,
                                        style: tStyle15W600.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: con.maxWidth * 0.18,
                                      padding: padding,
                                      // color: color,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        item.qty.toString(),
                                        style: tStyle15W600.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: con.maxWidth * 0.25,
                                      padding: padding,
                                      // color: color,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '₹${item.amount}',
                                        style: tStyle15W600.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: con.maxWidth * 0.25,
                                      padding: padding,
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        // '₹${item.amount * item.qty}',
                                        '₹${CalculationHelper.stringToDouble('${item.amount * item.qty}')}',
                                        style: tStyle15W600.copyWith(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 1),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: height * .01),
                  const Line(),
                  SizedBox(height: height * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Qty : ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 16,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      Text(
                        widget.collection.totalQty.toString(), //'200',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 20,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Service Charge (${widget.collection.type == ScrapType.scrap ? kMSymbl : kPSymbl}) : ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 16,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      Text(
                        widget.collection.totalServiceCharge
                            .toString(), //'₹ 25000',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 20,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Round Off (${widget.collection.type == ScrapType.scrap ? kPSymbl : kMSymbl}) : ',
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 16,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      Text(
                        widget.collection.totalRoundOff.toString(), //'₹ 25000',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 20,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount : ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 16,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      Text(
                        widget.collection.totalPaidAmt.toString(), //'₹ 25000',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 20,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * .01),
                  const Line(),
                  SizedBox(height: height * .1),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

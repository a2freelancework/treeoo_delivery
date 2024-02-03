// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:treeo_delivery/core/extensions/date_ext.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/domain/orders/entity/my_collection.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class CollectionDetails extends StatefulWidget {
  const CollectionDetails({required this.collection, super.key});
  final MyCollection collection;

  @override
  State<CollectionDetails> createState() => _CollectionDetailsState();
}

class _CollectionDetailsState extends State<CollectionDetails> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final vehicle = UserAuth.I.currentUser!.vehicle!;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: height * .065,
            ),
            const AppbarSection(
              heading: 'Collection Details',
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
                        vehicle.number,//'KL 16 A 8765',
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
                        vehicle.name,//'MARUTHI',
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
                        widget.collection.date.toDate,//'12-nov-2022',
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
                    height: height * .02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ITEM',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'QTY',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(
                        width: width * .17,
                      ),
                      const Text(
                        'PRICE',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                  const Line(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero, // padding around the grid
                    itemCount:
                        widget.collection.items.length, // total number of items
                    itemBuilder: (context, index) {
                      final item = widget.collection.items.elementAt(index);
                      return Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: Container(
                          height: height * .05,
                          width: width,
                          decoration: BoxDecoration(
                            color: peahcream,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: width * .02,
                              ),
                              Text(
                                item.itemName,//'Cartoon Box',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              const Spacer(),
                              SizedBox(
                                width: width * .13,
                                height: height,
                                child: Center(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: item.qty.toString(),//'1',
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width * .1,
                              ),
                              SizedBox(
                                width: width * .12,
                                height: height,
                                child: Center(
                                  child: TextField(
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: item.amount.toString(),//'100',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  const Line(),
                  SizedBox(
                    height: height * .01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Qty - ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 16,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      Text(
                        widget.collection.totalQty.toString(),//'200',
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
                  SizedBox(
                    height: height * .01,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount - ',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Gilroy',
                          fontSize: 16,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      Text(
                        widget.collection.totalPaidAmt.toString(),//'₹ 25000',
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
                  SizedBox(
                    height: height * .01,
                  ),
                  const Line(),
                  SizedBox(
                    height: height * .1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

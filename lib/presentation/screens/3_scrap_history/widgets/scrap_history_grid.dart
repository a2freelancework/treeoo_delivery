
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class ScrapHistoryGrid extends StatelessWidget {
  const ScrapHistoryGrid({required this.controller, super.key});
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

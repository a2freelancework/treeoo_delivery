// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/core/extensions/context_ext.dart';
import 'package:treeo_delivery/core/extensions/date_ext.dart';
import 'package:treeo_delivery/core/utils/snack_bar.dart';
import 'package:treeo_delivery/core/utils/string_constants.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/domain/orders/usecase/order_usecases.dart';
import 'package:treeo_delivery/presentation/screens/3_order_history/completed_order_details_screen.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/helper_class/url_launcher_helper.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class OrderHistoryList extends StatelessWidget {
  const OrderHistoryList({
    required this.streamControl,
    required this.scrollControll,
    super.key,
  });
  final StreamController<Iterable<ScrapOrder>> streamControl;
  final ScrollController scrollControll;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: streamControl.stream,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            controller: scrollControll,
            padding: const EdgeInsets.all(8), // padding around the grid
            itemCount: snapshot.data!.length, // total number of items
            itemBuilder: (_, index) {
              final order = snapshot.data!.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {
                    if (order.status != OrderStatusConst.CANCELLED &&
                        order.status != OrderStatusConst.COMPLETED) {
                      _reschedule(
                        context: context,
                        id: order.id,
                        currentPickupDate: order.pickupDate,
                      );
                    } else if (order.status == OrderStatusConst.COMPLETED) {
                      context.push(CompletedOrderDetails(order: order));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: order.type == ScrapType.scrap
                          ? Pallete.scrapGreen
                          : Pallete.wasteOrange,
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
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color:
                                      order.status == OrderStatusConst.COMPLETED
                                          ? Colors.green
                                          : order.status ==
                                                  OrderStatusConst.CANCELLED
                                              ? Colors.red.shade400
                                              : Colors.orange.shade400,
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
                          if (order.status == OrderStatusConst.RESCHEDULED)
                            Column(
                              children: [
                                const Line(),
                                SizedBox(height: height * .01),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Resceduled To',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Gilroy',
                                        fontSize: 15,
                                        letterSpacing: .4,
                                        color: blackColor,
                                      ),
                                    ),
                                    Text(
                                      order.pickupDate.toDate,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Gilroy',
                                        fontSize: 14,
                                        letterSpacing: .4,
                                        color: blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          if (order.status == OrderStatusConst.COMPLETED)
                            Column(
                              children: [
                                SizedBox(height: height * .01),
                                const Line(),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Amount',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Gilroy',
                                        fontSize: 15,
                                        letterSpacing: .4,
                                        color: blackColor,
                                      ),
                                    ),
                                    Text(
                                      '₹ ${order.amtPayable}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Gilroy',
                                        fontSize: 17,
                                        letterSpacing: .4,
                                        color: blackColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          Column(
                            children: [
                              SizedBox(height: height * .01),
                              const Line(),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Address',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Gilroy',
                                      fontSize: 15,
                                      letterSpacing: .4,
                                      color: blackColor,
                                    ),
                                  ),
                                  const SizedBox(width: 40),
                                  Flexible(
                                    child: Text(
                                      order.address,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Gilroy',
                                        fontSize: 14,
                                        letterSpacing: .4,
                                        color: blackColor,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ],
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
                              if (order.status != OrderStatusConst.COMPLETED &&
                                  order.status != OrderStatusConst.CANCELLED &&
                                  order.status != OrderStatusConst.RESCHEDULED)
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Pickup Date:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Gilroy',
                                        fontSize: 15,
                                        letterSpacing: .4,
                                        color: blackColor,
                                      ),
                                    ),
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
                                  ],
                                ),
                              const Spacer(),
                              contactIconButton(
                                width: width,
                                onTap: () {
                                  UrlLaunchingHelper.whatsapp(order.phone);
                                },
                                icon: 'images/whatsapp.png',
                              ),
                              SizedBox(
                                width: width * .02,
                              ),
                              contactIconButton(
                                width: width,
                                onTap: () {
                                  UrlLaunchingHelper.phone(order.phone);
                                },
                                icon: 'images/call.png',
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

  Future<void> _reschedule({
    required BuildContext context,
    required String id,
    required DateTime currentPickupDate,
  }) async {
    var isLoading = false;

    DateTime? newDate;
    await showDialog<void>(
      context: context,
      barrierDismissible: !isLoading,
      builder: (_) => StatefulBuilder(
        builder: (_, changeState) {
          return AlertDialog(
            title: const Text('Reschedule Order'),
            content: Text(
              newDate != null
                  ? 'Selected Date: ${newDate!.toDate}'
                  : 'Select reschedule date',
            ),
            actions: !isLoading
                ? [
                    ElevatedButton(
                      onPressed: newDate != null
                          ? () {
                              if (currentPickupDate == newDate) {
                                AppSnackBar.showSnackBar(
                                  context,
                                  'Select another date',
                                );
                                return;
                              }
                              changeState(() {
                                isLoading = true;
                              });
                              _rescedule(
                                context: context,
                                id: id,
                                date: newDate!,
                              );
                            }
                          : null,
                      child: const Text('Save'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _showPopupdate(context: context).then((date) {
                          if (date != null) {
                            changeState(() {
                              newDate = date;
                            });
                          }
                        });
                      },
                      child: const Text('Select Date'),
                    ),
                  ]
                : [
                    const Center(child: CircularProgressIndicator()),
                  ],
          );
        },
      ),
    );
  }

  Widget contactIconButton({
    required double width,
    required String icon,
    required VoidCallback onTap,
  }) {
    return InkResponse(
      onTap: onTap,
      child: Image.asset(
        icon,
        width: width * .08,
      ),
    );
  }

  Future<DateTime?> _showPopupdate({
    required BuildContext context,
  }) async {
    final now = DateTime.now();
    final selectedDateTime = await showDatePicker(
      context: context,
      firstDate: now,
      initialDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    return selectedDateTime;
  }

  void _rescedule({
    required BuildContext context,
    required DateTime date,
    required String id,
  }) {
    OrderUsecases.I.rescheduleOrder(date: date, id: id).then((res) {
      res.fold(
        (f) {
          AppSnackBar.showSnackBar(context, 'Faild to reschedule order');
          Navigator.pop(context);
        },
        (r) {
          AppSnackBar.showSnackBar(
              context, 'Order rescheduled to ${date.toDate}');
          Navigator.pop(context);
        },
      );
    });
  }
}

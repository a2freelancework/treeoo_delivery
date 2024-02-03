// ignore_for_file: lines_longer_than_80_chars, constant_identifier_names

import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:treeo_delivery/core/extensions/date_ext.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/domain/orders/usecase/get_invoiced_scrap_data.dart';
import 'package:treeo_delivery/domain/orders/usecase/order_usecases.dart';
import 'package:treeo_delivery/presentation/screens/billsection/billview.dart';
import 'package:treeo_delivery/presentation/screens/billsection/scraps_cubit/scrap_cubit.dart';
import 'package:treeo_delivery/presentation/screens/orderscreen/order_rejection_reason.dart';
import 'package:treeo_delivery/presentation/screens/orderscreen/scraporders_screen.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class OrderDetails extends StatefulWidget {
  const OrderDetails({required this.order, super.key});
  final ScrapOrder order;

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  late ScrapOrder order;
  bool _isLoading = true;
  bool isSubmitted = false;

  String? dropdownValue;
  OrderStatus? _orderStatus;
  DateTime? rescheduleDate;
  String? orderRejectReason;

  final _getInvoicedScrapData = GetIt.I.get<GetInvoicedScrapData>();

  @override
  void initState() {
    super.initState();
    order = widget.order;
    getData();
  }

  Future<void> getData() async {
    final result = await _getInvoicedScrapData(order.id);
    result.fold(
      (f) => null,
      (invoicedScrap) {
        order =
            (order as ScrapOrderModel).copyWith(invoicedScraps: invoicedScrap);
        setState(() {
          _isLoading = false;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: height * .065),
                  const AppbarSection(heading: ' Order Details'),
                  SizedBox(height: height * .03),
                  Padding(
                    padding:
                        EdgeInsets.only(left: width * .05, right: width * .05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Order Id',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Gilroy',
                                fontSize: 15,
                                letterSpacing: .4,
                                color: otpgrey,
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
                        SizedBox(height: height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Status',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Gilroy',
                                fontSize: 15,
                                letterSpacing: .4,
                                color: otpgrey,
                              ),
                            ),
                            Text(
                              order.status,
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
                        SizedBox(height: height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Name',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Gilroy',
                                fontSize: 15,
                                letterSpacing: .4,
                                color: otpgrey,
                              ),
                            ),
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
                          ],
                        ),
                        SizedBox(height: height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Scheduled Date',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Gilroy',
                                fontSize: 15,
                                letterSpacing: .4,
                                color: otpgrey,
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
                        SizedBox(height: height * .015),
                        const Line(),
                        SizedBox(height: height * .015),
                        const Text(
                          'Adress',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gilroy',
                            fontSize: 15,
                            letterSpacing: .4,
                            color: blackColor,
                          ),
                        ),
                        SizedBox(height: height * .01),
                        Text(
                          order.address,
                          maxLines: 4,
                          textAlign: TextAlign.justify,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gilroy',
                            fontSize: 15,
                            letterSpacing: .4,
                            color: otpgrey,
                          ),
                        ),
                        SizedBox(height: height * .01),
                        const Line(),
                        SizedBox(height: height * .01),
                        // const Text(
                        //   'Comments',
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w500,
                        //     fontFamily: 'Gilroy',
                        //     fontSize: 15,
                        //     letterSpacing: .4,
                        //     color: blackColor,
                        //   ),
                        // ),
                        // SizedBox(
                        //   height: height * .01,
                        // ),
                        // const Text(
                        //   'Make A call before arrival',
                        //   maxLines: 4,
                        //   textAlign: TextAlign.justify,
                        //   style: TextStyle(
                        //     fontWeight: FontWeight.w500,
                        //     fontFamily: 'Gilroy',
                        //     fontSize: 15,
                        //     letterSpacing: .4,
                        //     color: otpgrey,
                        //   ),
                        // ),
                        SizedBox(height: height * .025),
                        const Text(
                          'Item List',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gilroy',
                            fontSize: 15,
                            letterSpacing: .4,
                            color: blackColor,
                          ),
                        ),

                        OrderedItems(invoicedScraps: order.invoicedScraps!),

                        SizedBox(height: height * .05),

                        // Container(
                        //   width: width,
                        //   height: height * .055,
                        //   decoration: BoxDecoration(
                        //     color: darkgreen,
                        //     borderRadius: BorderRadius.circular(10),
                        //   ),
                        //   child: Padding(
                        //     padding: EdgeInsets.only(
                        //       left: width * .05,
                        //       right: width * .05,
                        //     ),
                        //     child: DropdownButtonHideUnderline(
                        //       child: DropdownButton2<String>(
                        //         hint: const Center(
                        //           child: Text(
                        //             'Update Status',
                        //             style: TextStyle(
                        //               fontWeight: FontWeight.w600,
                        //               fontFamily: 'Gilroy',
                        //               fontSize: 15,
                        //               // letterSpacing: .8,
                        //               color: whiteColor,
                        //             ),
                        //           ),
                        //         ),
                        //         value: dropdownValue,
                        //         // iconSize: 24,
                        //         // elevation: 16,

                        //         onChanged: (String? newValue) {
                        //           if (newValue == 'On Progress') {
                        //             Navigator.of(context).push(
                        //               PageAnimationTransition(
                        //                 page: BlocProvider(
                        //                   create: (context) =>
                        //                       ScrapCubit()..fetchScraps(),
                        //                   child: BillViewScreen(order: order),
                        //                 ),
                        //                 pageAnimationType:
                        //                     FadeAnimationTransition(),
                        //               ),
                        //             );
                        //           } else {
                        //             setState(() {
                        //               dropdownValue = newValue;
                        //             });
                        //           }
                        //         },
                        //         items: prroflist
                        //             .map<DropdownMenuItem<String>>((value) {
                        //           return DropdownMenuItem<String>(
                        //             value: value,
                        //             child: Text(
                        //               value,
                        //               style: const TextStyle(
                        //                 fontWeight: FontWeight.w600,
                        //                 fontFamily: 'Gilroy',
                        //                 fontSize: 15,
                        //                 // letterSpacing: .8,
                        //                 color: blackColor,
                        //               ),
                        //             ),
                        //           );
                        //         }).toList(),
                        //         dropdownStyleData: DropdownStyleData(
                        //           maxHeight: height * .3,
                        //           width: width * .8,
                        //           decoration: BoxDecoration(
                        //             borderRadius: BorderRadius.circular(14),
                        //             color: peahcream,
                        //           ),
                        //           elevation: 16,
                        //           offset: const Offset(-20, 0),
                        //           scrollbarTheme: ScrollbarThemeData(
                        //             radius: const Radius.circular(40),
                        //             thickness:
                        //                 MaterialStateProperty.all<double>(6),
                        //             thumbVisibility:
                        //                 MaterialStateProperty.all<bool>(true),
                        //           ),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),

                        Container(
                          width: width,
                          height: height * .055,
                          decoration: BoxDecoration(
                            color: darkgreen,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: width * .05,
                              right: width * .05,
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<OrderStatus>(
                                hint: const Center(
                                  child: Text(
                                    'Update Status',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Gilroy',
                                      fontSize: 15,
                                      // letterSpacing: .8,
                                      color: whiteColor,
                                    ),
                                  ),
                                ),
                                value: _orderStatus,
                                // iconSize: 24,
                                // elevation: 16,
                                onChanged: (OrderStatus? newValue) async {
                                  rescheduleDate = null;
                                  orderRejectReason = null;

                                  if (newValue != null) {
                                    switch (newValue) {
                                      case OrderStatus.onProgress:
                                        _onProgress(context);
                                      case OrderStatus.onWay:
                                        setState(() {
                                          _orderStatus = newValue;
                                        });
                                      case OrderStatus.reschedule:
                                        await _rescheduleOrder(newValue);

                                      case (OrderStatus.cancelOrder ||
                                            OrderStatus.dropOrder):
                                        await _selectRejectionReason(
                                          isCancelOrder: newValue ==
                                              OrderStatus.cancelOrder,
                                          newValue: newValue,
                                        );
                                    }
                                  }
                                },
                                items: OrderStatus.values
                                    .map<DropdownMenuItem<OrderStatus>>(
                                        (value) {
                                  final dropDownText =
                                      (value == OrderStatus.reschedule &&
                                              rescheduleDate != null)
                                          ? '   [ ${rescheduleDate!.toDate} ]'
                                          : '';
                                  return DropdownMenuItem<OrderStatus>(
                                    value: value,
                                    child: Text(
                                      '${value.description} $dropDownText',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'Gilroy',
                                        fontSize: 15,
                                        // letterSpacing: .8,
                                        color: blackColor,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                dropdownStyleData: DropdownStyleData(
                                  maxHeight: 200,
                                  width: width - width * .1, // * .8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(14),
                                    color: peahcream,
                                  ),
                                  elevation: 16,
                                  offset: const Offset(-20, 0),
                                  scrollbarTheme: ScrollbarThemeData(
                                    radius: const Radius.circular(40),
                                    thickness:
                                        MaterialStateProperty.all<double>(6),
                                    thumbVisibility:
                                        MaterialStateProperty.all<bool>(true),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: height * .025),
                        Stack(
                          fit: StackFit.passthrough,
                          children: [
                            OrderContainer(
                              name: 'Submit',
                              onTap: () {
                                if (_orderStatus != null) {
                                  try {
                                    switch (_orderStatus!) {
                                      case OrderStatus.onWay:
                                        _updateOrderStatus(
                                          id: order.id,
                                          status: _orderStatus!,
                                        );

                                      case OrderStatus.reschedule:
                                        _updateOrderStatus(
                                          id: order.id,
                                          status: _orderStatus!,
                                          // ignore: unnecessary_null_checks
                                          reschedule: rescheduleDate!,
                                        );

                                      case (OrderStatus.cancelOrder ||
                                            OrderStatus.dropOrder):
                                        _updateOrderStatus(
                                          id: order.id,
                                          status: _orderStatus!,
                                          invoicedScrapRefId:
                                              order.invoicedScraps!.scrapRefId,
                                          // ignore: unnecessary_null_checks
                                          reason: orderRejectReason!,
                                        );

                                      case OrderStatus.onProgress:
                                    }
                                  } catch (e) {
                                    debugPrint('=== $e');
                                  }
                                }
                              },
                            ),
                            if (isSubmitted)
                              Container(
                                color: Colors.white60,
                                alignment: Alignment.center,
                                width: width * .9,
                                height: height * .055,
                                child: const CircularProgressIndicator(),
                              ),
                          ],
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     // CustomeContainer(name: 'Drop Order', containercolor: red),
                        //     CustomeContainer(
                        //       name: 'Cancel Order',
                        //       containercolor: red,
                        //       onnTap: () async {
                        //         await _cancelOrder(
                        //           id: order.id,
                        //           invoicedScrapRefId:
                        //               order.invoicedScraps!.scrapRefId,
                        //           reason: "We won't be here in that date.",
                        //         ).then((result) {
                        //           result.fold(
                        //             (l) => null,
                        //             (_) => Navigator.pushAndRemoveUntil(
                        //               context,
                        //               MaterialPageRoute<void>(
                        //                 builder: (context) =>
                        //                     const ScrapOrderScreen(),
                        //               ),
                        //               (route) => false,
                        //             ),
                        //           );
                        //         });
                        //       },
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _onProgress(BuildContext context) {
    Navigator.push(
      context,
      PageAnimationTransition(
        page: BlocProvider(
          create: (context) => ScrapCubit()..fetchScraps(),
          child: BillViewScreen(order: order),
        ),
        pageAnimationType: FadeAnimationTransition(),
      ),
    );
  }

  Future<void> _rescheduleOrder(OrderStatus? newValue) async {
    final today = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: today.add(const Duration(days: 1)),
      initialDate: today.add(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        _orderStatus = newValue;
        rescheduleDate = date;
      });
    }
  }

  Future<void> _selectRejectionReason({
    required bool isCancelOrder,
    OrderStatus? newValue,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => OrderRejectionReason(
          isCancelOrder: isCancelOrder,
          onReasonSelect: (reson) {
            orderRejectReason = reson;
            setState(() {
              _orderStatus = newValue;
            });
          },
        ),
      ),
    );
  }

  Future<void> _updateOrderStatus({
    required String id,
    required OrderStatus status,
    String? invoicedScrapRefId,
    String? reason,
    DateTime? reschedule,
  }) async {
    setState(() {
      isSubmitted = true;
    });
    await OrderUsecases.I
        .updateOrderStatus(
      id: order.id,
      status: status,
      invoicedScrapRefId: invoicedScrapRefId,
      reson: reason,
      reschedule: reschedule,
    )
        .then((result) {
      result.fold(
        (l) => null,
        (_) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<void>(
            builder: (context) => const ScrapOrderScreen(),
          ),
          (route) => false,
        ),
      );
    });
  }
}

enum OrderStatus implements Comparable<OrderStatus> {
  // confirmOrder(description: 'Confirm Order'),
  onProgress(description: 'On Progress'),
  onWay(description: 'On Way'),
  reschedule(description: 'Reschedule'),
  dropOrder(description: 'Drop Order'),
  cancelOrder(description: 'Cancel Order');

  const OrderStatus({required this.description});
  final String description;
  @override
  int compareTo(OrderStatus other) => index - other.index;
}

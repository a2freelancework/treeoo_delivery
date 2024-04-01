import 'dart:async';

import 'package:flutter/material.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:treeo_delivery/core/extensions/date_ext.dart';
import 'package:treeo_delivery/core/utils/snack_bar.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/domain/orders/usecase/order_usecases.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/orderdetails.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/helper_class/url_launcher_helper.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/search_box.dart';

class PendingOrderScreen extends StatefulWidget {
  const PendingOrderScreen({super.key});

  @override
  State<PendingOrderScreen> createState() => _PendingOrderScreenState();
}

class _PendingOrderScreenState extends State<PendingOrderScreen> {
  late final StreamController<Iterable<ScrapOrder>> _orderStreamControl;
  StreamSubscription<Iterable<ScrapOrder>>? _subscription;

  @override
  void initState() {
    super.initState();
    _orderStreamControl = StreamController();
    _loadOrders();
  }

  void _loadOrders([String? searchText]) {
    _subscription?.cancel(); // Cancel the previous subscription if it exists
    _subscription =
        OrderUsecases.I.getAllPendingAssignedOrders(searchText).listen((event) {
      _orderStreamControl.sink.add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: height * .065),
            
            const AppbarSection(
              heading: 'Pending Orders',
            ),
            SizedBox(
              height: height * .015,
            ),
            OrderContainer(
              name: 'All Orders',
              onTap: () {},
            ),
            SizedBox(height: height * .02),
            SearchBox(
              onEditingComplete: _loadOrders,
            ),
            CustomerdeatilList(
              orderStream: _orderStreamControl.stream,
            ),
          ],
        ),
      ),
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

// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/core/extensions/date_ext.dart';
import 'package:treeo_delivery/core/utils/calculation_helper.dart';
import 'package:treeo_delivery/core/utils/snack_bar.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/domain/orders/usecase/order_usecases.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/style.dart';

class CompletedOrderDetails extends StatefulWidget {
  const CompletedOrderDetails({required this.order, super.key});
  final ScrapOrder order;

  @override
  State<CompletedOrderDetails> createState() => _CompletedOrderDetailsState();
}

class _CompletedOrderDetailsState extends State<CompletedOrderDetails> {
  late ScrapOrder order;
  bool _isFetching = true;
  double _total = 0;
  @override
  void initState() {
    super.initState();
    getInvoicedScrap();
  }

  Future<void> getInvoicedScrap() async {
    final updatedOrder = await OrderUsecases.I
        .getInvoicedScrapData(widget.order as ScrapOrderModel);
    if (updatedOrder != null) {
      order = updatedOrder;
      _total = CalculationHelper.stringToDouble(
        order.invoicedScraps!.scraps
            .fold<double>(0, (p, sp) => p + sp.price * sp.qty)
            .toString(),
      );
      setState(() {
        _isFetching = false;
      });
    } else {
      // ignore: use_build_context_synchronously
      AppSnackBar.showSnackBar(context, 'Something went wrong');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final title = widget.order.type == ScrapType.scrap ? 'Scrap' : 'Waste';
    final tColor = widget.order.type == ScrapType.scrap
        ? Pallete.scrapGreen
        : Pallete.wasteOrange;
    return Scaffold(
      body: _isFetching
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: height * .065),
                  AppbarSection(
                    heading: '$title Invoice',
                  ),
                  SizedBox(height: height * .015),
                  Padding(
                    padding:
                        EdgeInsets.only(left: width * .05, right: width * .05),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Invoice Id:',
                              style: _labelStyle,
                            ),
                            Text(
                              order.orderId, //'KL 16 A 8765',
                              style: _valueStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Name:',
                              style: _labelStyle,
                            ),
                            Text(
                              order.customerName, //'KL 16 A 8765',
                              style: _valueStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Phone:',
                              style: _labelStyle,
                            ),
                            Text(
                              order.phone, //'MARUTHI',
                              style: _valueStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Address:',
                              style: _labelStyle,
                            ),
                            Flexible(
                              child: Text(
                                order.address, //'MARUTHI',
                                style: _valueStyle,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Date',
                              style: _labelStyle,
                            ),
                            Text(
                              order.completedDate?.toDate ??
                                  '', //'12-nov-2022',
                              style: _valueStyle,
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
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
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
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
                                  padding: EdgeInsets
                                      .zero, // padding around the grid
                                  itemCount: order.invoicedScraps!.scraps
                                      .length, // total number of items
                                  itemBuilder: (_, index) {
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
                                    final item = order.invoicedScraps!.scraps
                                        .elementAt(index);
                                    return ColoredBox(
                                      color: color,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: con.maxWidth * 0.32,
                                            padding: padding,
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              item.scrapName,
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
                                              '₹${item.price}',
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
                                              '₹${CalculationHelper.stringToDouble('${item.price * item.qty}')}',
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
                              style: _labelStyle,
                            ),
                            Text(
                              '${order.invoicedScraps!.scraps.fold<double>(0, (pv, s) => pv + s.qty)}', //'200',
                              style: _valueStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Service Charge (${order.type == ScrapType.scrap ? kMSymbl : kPSymbl}) : ',
                              style: _labelStyle,
                            ),
                            Text(
                              order.serviceCharge.toString(), //'₹ 25000',
                              style: _valueStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Round Off (${order.type == ScrapType.scrap ? kPSymbl : kMSymbl}) : ',
                              style: _labelStyle,
                            ),
                            Text(
                              order.roundOffAmt.toString(), //'₹ 25000',
                              style: _valueStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total : ',
                              style: _labelStyle,
                            ),
                            Text(
                              '₹$_total', //'₹ 25000',
                              style: _valueStyle,
                            ),
                          ],
                        ),
                        SizedBox(height: height * .01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Amount Payable : ',
                              style: _labelStyle,
                            ),
                            Text(
                              order.amtPayable.toString(), //'₹ 25000',
                              style: _valueStyle,
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

const _labelStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontFamily: 'Gilroy',
  fontSize: 15,
  letterSpacing: .4,
  color: otpgrey,
);

const _valueStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontFamily: 'Gilroy',
  fontSize: 15,
  letterSpacing: .4,
  color: blackColor,
);

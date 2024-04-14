// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/core/utils/calculation_helper.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';
// import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/style.dart';

class ItemListingWidget extends StatelessWidget {
  const ItemListingWidget({
    required this.order,
    required this.onTap,
    super.key,
  });
  final ScrapOrderModel order;
  final void Function(int index) onTap;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final kHeight01 = SizedBox(height: height * .01);
    final tColor = order.type == ScrapType.scrap
        ? Pallete.scrapGreen
        : Pallete.wasteOrange;
    return LayoutBuilder(
      builder: (_, con) {
        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: con.maxWidth * 0.3,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: darkgreen,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Item',
                    style: tStyle15W600.copyWith(color: Colors.white),
                  ),
                ),
                Container(
                  width: con.maxWidth * 0.2,
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: darkgreen,
                  alignment: Alignment.center,
                  child: Text(
                    'Qty',
                    style: tStyle15W600.copyWith(color: Colors.white),
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
                    style: tStyle15W600.copyWith(color: Colors.white),
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
                    style: tStyle15W600.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero, // padding around the grid
              itemCount: order.invoicedScraps?.scraps.length ??
                  0, // total number of items
              itemBuilder: (context, index) {
                final scrap = order.invoicedScraps!.scraps[index];
                final color =
                    Color.lerp(tColor, Colors.black, index.isEven ? 0 : 0.15)!;
                const padding = EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                );
                return GestureDetector(
                  onTap: () {
                    onTap(index);
                  },
                  child: ColoredBox(
                    color: color,
                    child: Row(
                      children: [
                        Container(
                          width: con.maxWidth * 0.32,
                          padding: padding,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            scrap.scrapName,
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
                            scrap.qty.toString(),
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
                            '₹${scrap.price}',
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
                            '₹${CalculationHelper.stringToDouble('${scrap.price * scrap.qty}')}',
                            style: tStyle15W600.copyWith(
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            kHeight01,
          ],
        );
      },
    );
  }

  
}

// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final kHeight01 = SizedBox(height: height * .01);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'ITEM',
              style: tStyle15W600,
            ),
            const Spacer(),
            const Text(
              'QTY',
              style: tStyle15W600,
            ),
            SizedBox(
              width: width * .17,
            ),
            const Text(
              'PRICE',
              style: tStyle15W600,
            ),
          ],
        ),
        const Line(),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero, // padding around the grid
          itemCount:
              order.invoicedScraps?.scraps.length ?? 0, // total number of items
          itemBuilder: (context, index) {
            final scrap = order.invoicedScraps!.scraps[index];
            return Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 4),
              child: InkWell(
                onTap: () {
                  onTap(index);
                },
                child: Container(
                  // height: height * .05,
                  // width: width,
                  constraints: BoxConstraints(
                    maxWidth: width,
                    minHeight: height * .05,
                  ),
                  padding: EdgeInsets.only(left: width * .02),
                  decoration: BoxDecoration(
                    color: order.type == ScrapType.scrap
                        ? Pallete.scrapGreen
                        : Pallete.wasteOrange,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          scrap.scrapName, //'Cartoon Box',
                          style: tStyle15W600,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 15,
                          ),
                          SizedBox(
                            width: width * .13,
                            // height: height,
                            child: Center(
                              child: Text(scrap.qty.toString()),
                              // TextField(
                              //   controller: tyController,
                              //   decoration: const InputDecoration(
                              //     border: InputBorder.none,
                              //   ),
                              // ),
                            ),
                          ),
                          SizedBox(width: width * .1),
                          SizedBox(
                            width: width * .12,
                            // height: height,
                            child: Center(
                              child: Text(scrap.price.toString()),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        kHeight01,
      ],
    );
  }
}

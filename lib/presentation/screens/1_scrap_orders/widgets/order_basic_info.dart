
import 'package:flutter/material.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/style.dart';

class OrderBasicInfo extends StatelessWidget {
  const OrderBasicInfo({
    required this.order,
    super.key,
  });

  final ScrapOrderModel order;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final kHeight02 = SizedBox(height: height * .02);
    return Column(
      children: [
        kHeight02,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Order Id',
              style: tStyle15,
            ),
            Text(
              order.orderId,
              style: tStyle15.copyWith(color: blackColor),
            ),
          ],
        ),
        SizedBox(height: height * .01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Name',
              style: tStyle15,
            ),
            Text(
              order.customerName, //'Abhilash',
              style: tStyle15.copyWith(color: blackColor),
            ),
          ],
        ),
        SizedBox(height: height * .01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: width * 0.3,
              child: const Text(
                'Address',
                style: tStyle15,
              ),
            ),
            Flexible(
              child: Text(
                order.address,
                style: tStyle15.copyWith(color: blackColor),
                textAlign: TextAlign.end,
              ),
            ),
          ],
        ),
        kHeight02,
      ],
    );
  }
}

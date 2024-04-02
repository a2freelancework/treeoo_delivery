import 'package:flutter/material.dart';
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/data/orders/model/invoiced_scrap.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class OrderedItems extends StatefulWidget {
  const OrderedItems({
    required this.invoicedScraps,
    required this.type,
    super.key,
  });
  final InvoicedScrap invoicedScraps;
  final ScrapType type;

  @override
  State<OrderedItems> createState() => _OrderedItemsState();
}

class _OrderedItemsState extends State<OrderedItems> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(
        top: 20,
        left: 4,
        right: 4,
      ), // padding around the grid
      itemCount: widget.invoicedScraps.scraps.length,
      shrinkWrap: true,
      // total number of items
      itemBuilder: (context, index) {
        final scrap = widget.invoicedScraps.scraps[index];
        return Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: widget.type == ScrapType.scrap
                ? Pallete.scrapGreen
                : Pallete.wasteOrange,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                // imageUrl: 
                scrap.icon,
                width: 30,
              ),
              SizedBox(height: height * .005),
              Text(
                scrap.scrapName,
                
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Gilroy',
                  fontSize: 14,
                  letterSpacing: .4,
                  color: otpgrey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }
}


import 'package:flutter/material.dart';
import 'package:treeo_delivery/data/orders/model/invoiced_scrap.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class OrderedItems extends StatefulWidget {
  const OrderedItems({required this.invoicedScraps, super.key});
  final InvoicedScrap invoicedScraps;

  @override
  State<OrderedItems> createState() => _OrderedItemsState();
}

class _OrderedItemsState extends State<OrderedItems> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
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
          decoration: BoxDecoration(
            color: peahcream,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                scrap.icon,
                width: width * .15,
              ),
              SizedBox(
                height: height * .01,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: Text(
                    scrap.scrapName,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Gilroy',
                      fontSize: 15,
                      letterSpacing: .4,
                      color: otpgrey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

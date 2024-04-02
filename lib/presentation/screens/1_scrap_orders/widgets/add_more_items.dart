import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treeo_delivery/core/extensions/context_ext.dart';
import 'package:treeo_delivery/data/orders/model/scrap_model.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/scraps_cubit/scrap_cubit.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/widgets/input_field.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/style.dart';

class AddMoreItems extends StatefulWidget {
  const AddMoreItems({
    required this.autoSearchOnSelected,
    required this.newItemQty,
    required this.newItemPrice,
    required this.onAddItemClick,
    super.key,
  });
  final void Function(ScrapModel?) autoSearchOnSelected;
  final TextEditingController newItemQty;
  final TextEditingController newItemPrice;
  final void Function() onAddItemClick;

  @override
  State<AddMoreItems> createState() => _AddMoreItemsState();
}

class _AddMoreItemsState extends State<AddMoreItems> {
  String itemSelected = '';
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final kHeight01 = SizedBox(height: height * .01);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        kHeight01,
        const Text(
          'Add More Items',
          style: tStyle15W600,
        ),
        // Search Scrap Item
        InkResponse(
          onTap: () async {
            final sp = await _searchPopup(context);
            widget.autoSearchOnSelected(sp);
            setState(() {
              itemSelected = sp?.scrapName ?? '';
            });
          },
          splashColor: Colors.transparent,
          child: Container(
            width: double.infinity,
            height: 50,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey),
            ),
            child: Text(
              itemSelected,
            ),
          ),
        ),

        SizedBox(height: height * .01),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: height * .06,
              width: width * .4,
              child: TextField(
                cursorColor: blackColor,
                controller: widget.newItemQty,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: whiteColor,
                  filled: true,
                  hintText: 'Qty',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: subtext),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: subtext),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 13,
                  height: 1,
                  color: blackColor,
                ),
                // maxLines: maxLines,
              ),
            ),
            SizedBox(
              height: height * .06,
              width: width * .4,
              child: TextField(
                cursorColor: blackColor,
                controller: widget.newItemPrice,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  fillColor: whiteColor,
                  filled: true,
                  hintText: 'Price',
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: subtext),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: subtext),
                  ),
                ),
                style: const TextStyle(
                  fontSize: 13,
                  height: 1,
                  color: blackColor,
                ),
                // maxLines: maxLines,
              ),
            ),
          ],
        ),
        SizedBox(height: height * .01),
        OrderContainer(
          name: 'Add item',
          onTap: () {
            setState(() {
              itemSelected = '';
            });
            widget.onAddItemClick();
          },
        ),
        kHeight01,
      ],
    );
  }

  Future<ScrapModel?> _searchPopup(BuildContext context) async {
    final searchCtrl = TextEditingController();
    var scrapList = <ScrapModel>[];
    var filteredList = <ScrapModel>[];
    return showDialog<ScrapModel?>(
      context: context,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: BlocProvider(
            create: (_) => context.read<ScrapCubit>(),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: BoxConstraints(
                minHeight: context.mqHeight * 0.5,
                maxHeight: context.mqHeight * 0.8,
                maxWidth: context.mqWidth * 0.9,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: InputField(
                          onChanged: (v) {
                            filteredList = scrapList
                                .where(
                                  (s) => s.scrapName
                                      .toLowerCase()
                                      .contains(v.toLowerCase()),
                                )
                                .toList();
                          },
                          controller: searchCtrl,
                          keyboardType: TextInputType.text,
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: IconButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.grey.shade300,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Flexible(
                    child: BlocBuilder<ScrapCubit, ScrapState>(
                      builder: (_, state) {
                        scrapList = filteredList = state.scraps;
                        return ListenableBuilder(
                          listenable: searchCtrl,
                          builder: (_, __) {
                            return ListView.builder(
                              itemCount: filteredList.length,
                              itemBuilder: (_, i) {
                                final s = filteredList[i];
                                return ListTile(
                                  onTap: () {
                                    Navigator.pop(context, s);
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    s.scrapName,
                                  ),
                                  horizontalTitleGap: 0,
                                  minVerticalPadding: 0,
                                  leading: const SizedBox(width: 10),
                                  splashColor: Colors.grey,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

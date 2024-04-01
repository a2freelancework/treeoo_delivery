// ignore_for_file: lines_longer_than_80_chars, inference_failure_on_instance_creation

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/core/utils/snack_bar.dart';
import 'package:treeo_delivery/data/orders/model/scrap_model.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/domain/orders/usecase/complete_order.dart';
import 'package:treeo_delivery/presentation/screens/billsection/scraps_cubit/scrap_cubit.dart';
import 'package:treeo_delivery/presentation/screens/deliverydashboard.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class BillViewScreen extends StatefulWidget {
  const BillViewScreen({required this.order, super.key});
  final ScrapOrder order;

  @override
  State<BillViewScreen> createState() => _BillViewScreenState();
}

class _BillViewScreenState extends State<BillViewScreen> {
  late ScrapOrderModel order;
  var _total = 0.0;
  var _amountPayable = 0.0;
  late final TextEditingController _serviceCharge;
  late final TextEditingController _roundOff;
  late final TextEditingController _newItemQty;
  late final TextEditingController _newItemPrice;
  late final TextEditingController _orderCode;

  final completeOrder = GetIt.I.get<CompleteOrder>();

  ScrapModel? _newScrap;
  List<ScrapModel> ls = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    order = (widget.order as ScrapOrderModel).clone();
    _serviceCharge = TextEditingController(text: '0.0');
    _roundOff = TextEditingController(text: '0.0');
    _newItemQty = TextEditingController();
    _newItemPrice = TextEditingController();
    _orderCode = TextEditingController();
    // ls = order.invoicedScraps?.scraps ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async {
        return await showPopup() ?? false;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(left: width * .05, right: width * .05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppbarSection(
                    heading: ' Order Details',
                    onBackTap: () {
                      showPopup().then((canGoback) {
                        if (canGoback ?? false) {
                          Navigator.pop(context);
                        }
                      });
                    },
                  ),
                  SizedBox(height: height * .02),
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
                        order.customerName, //'Abhilash',
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
                      SizedBox(
                        width: width * 0.3,
                        child: const Text(
                          'Address',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gilroy',
                            fontSize: 15,
                            letterSpacing: .4,
                            color: otpgrey,
                          ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          order.address,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Gilroy',
                            fontSize: 15,
                            letterSpacing: .4,
                            color: blackColor,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: height * .02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'ITEM',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      const Spacer(),
                      const Text(
                        'QTY',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(
                        width: width * .17,
                      ),
                      const Text(
                        'PRICE',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                    ],
                  ),
                  const Line(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero, // padding around the grid
                    itemCount: order.invoicedScraps?.scraps.length ??
                        0, // total number of items
                    itemBuilder: (context, index) {
                      final scrap = order.invoicedScraps!.scraps[index];
                      return Padding(
                        padding: const EdgeInsets.only(top: 4, bottom: 4),
                        child: InkWell(
                          onTap: () async {
                            await _showMyDialog(context: context, index: index);
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
                              color: peahcream,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Text(
                                    scrap.scrapName, //'Cartoon Box',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Gilroy',
                                      fontSize: 15,
                                      letterSpacing: .4,
                                      color: blackColor,
                                    ),
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
                  SizedBox(height: height * .01),
                  const Line(),
                  SizedBox(height: height * .01),
                  const Text(
                    'Add More Items',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Gilroy',
                      fontSize: 15,
                      letterSpacing: .4,
                      color: blackColor,
                    ),
                  ),

                  // Search Scrap Item
                  BlocBuilder<ScrapCubit, ScrapState>(
                    builder: (context, state) {
                      ls = state.scraps;
                      return AutoSearch(
                        options: ls,
                        onSelected: (selected) {
                          _newScrap = selected;
                          _newItemQty.text = selected.qty.toString();
                          _newItemPrice.text = selected.price.toString();
                        },
                      );
                    },
                  ),

                  SizedBox(height: height * .01),
                  // SizedBox(
                  //   height: height * .06,
                  //   width: width,
                  //   child: TextField(
                  //     cursorColor: blackColor,
                  //     controller: _newItemName,
                  //     decoration: InputDecoration(
                  //       fillColor: whiteColor,
                  //       filled: true,
                  //       hintText: 'Select Item',
                  //       focusedBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //         borderSide: const BorderSide(color: subtext),
                  //       ),
                  //       enabledBorder: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //         borderSide: const BorderSide(color: subtext),
                  //       ),
                  //     ),
                  //     style: const TextStyle(
                  //       fontSize: 13,
                  //       height: 1,
                  //       color: blackColor,
                  //     ),
                  //     // maxLines: maxLines,
                  //   ),
                  // ),
                  // SizedBox(height: height * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: height * .06,
                        width: width * .4,
                        child: TextField(
                          cursorColor: blackColor,
                          controller: _newItemQty,
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
                          controller: _newItemPrice,
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
                    onTap: _addNewItem,
                  ),
                  SizedBox(height: height * .01),
                  const Line(),
                  SizedBox(height: height * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Service charge: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(
                        height: height * .06,
                        width: width * 0.35,
                        child: TextField(
                          cursorColor: blackColor,
                          controller: _serviceCharge,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: whiteColor,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: subtext),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: subtext),
                            ),
                          ),
                          onChanged: (v) {
                            _calculateTotal();
                          },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Add Round off: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(
                        height: height * .06,
                        width: width * 0.35,
                        child: TextField(
                          cursorColor: blackColor,
                          controller: _roundOff,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: whiteColor,
                            filled: true,
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: subtext),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: subtext),
                            ),
                          ),
                          onChanged: (v) {
                            _calculateTotal();
                          },
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
                  const Line(),
                  SizedBox(height: height * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      Text(_total.toString()),
                    ],
                  ),
                  SizedBox(height: height * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Amount payable: ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: blackColor,
                        ),
                      ),
                      Text(_amountPayable.toString()),
                    ],
                  ),
                  SizedBox(height: height * .03),
                  const Line(),
                  SizedBox(height: height * .01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Enter Order Code ',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Gilroy',
                          fontSize: 15,
                          letterSpacing: .4,
                          color: Color(0xFF616161),
                        ),
                      ),
                      SizedBox(
                        height: height * .06,
                        width: width * 0.35,
                        child: TextField(
                          cursorColor: blackColor,
                          controller: _orderCode,
                          keyboardType: TextInputType.number,
                          maxLength: 4,
                          decoration: InputDecoration(
                            fillColor: whiteColor,
                            filled: true,
                            counter: const SizedBox.shrink(),
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

                  Stack(
                    children: [
                      OrderContainer(
                        name: 'Confirm Order',
                        onTap: () async {
                          if (UserAuth.I.currentUser?.orderCode ==
                              _orderCode.text) {
                            setState(() {
                              _isLoading = true;
                            });
                            await confirmOrder();
                          } else {
                            AppSnackBar.showSnackBar(
                              context,
                              'Enter valid order code',
                            );
                          }
                          setState(() {
                              _isLoading = false;
                            });
                        },
                      ),
                      if (_isLoading)
                        SizedBox(
                          width: width * .9,
                          height: height * .055,
                          child: const Center(
                            child: CircularProgressIndicator(color: Colors.white,),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: height * .1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool?> showPopup() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text('Leave'),
          content: const Text('Are you sure you want to exit?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialog({
    required BuildContext context,
    required int index,
  }) async {
    final scrap = order.invoicedScraps!.scraps[index];
    final qtyController = TextEditingController(text: scrap.qty.toString());
    final priceController = TextEditingController(text: scrap.price.toString());
    return showDialog<dynamic>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Scrap'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(scrap.scrapName),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: qtyController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Qty',
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: TextFormField(
                      controller: priceController,
                      decoration: const InputDecoration(
                        hintText: 'Enter Price',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                order.invoicedScraps!.scraps.removeAt(index);
                _calculateTotal();
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                final updated = scrap.copyWith(
                  price: double.tryParse(priceController.text.trim()) ?? 0,
                  qty: double.tryParse(qtyController.text.trim()) ?? 0,
                );
                order.invoicedScraps!.scraps[index] = updated;
                _calculateTotal();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _calculateTotal() {
    final roundOff = double.tryParse(_roundOff.text) ?? 0;
    final serviceCharge = double.tryParse(_serviceCharge.text) ?? 0;

    final total = order.invoicedScraps!.scraps
        .fold<double>(0, (pre, sp) => (sp.price * sp.qty) + pre);

    setState(() {
      _total = total;
      _amountPayable = _total + roundOff - serviceCharge;
    });
  }

  void _addNewItem() {
    final qty = double.tryParse(_newItemQty.text.trim());
    final price = double.tryParse(_newItemPrice.text.trim());
    if (qty != null && price != null && _newScrap != null) {
      _newScrap = _newScrap!.copyWith(price: price, qty: qty);
      order.invoicedScraps!.scraps.add(_newScrap!);
      FocusManager.instance.primaryFocus?.unfocus();
      _calculateTotal();
      _newItemPrice.clear();
      _newItemQty.clear();
      _newScrap = null;
    }
  }

  Future<void> confirmOrder() async {
    try {
      final s = order.invoicedScraps!.scraps.firstWhere((s) => s.qty <= 0.0);
      AppSnackBar.showSnackBar(
        context,
        'Quantity of ${s.scrapName} is ${s.qty} . Enter a valid quanity.',
      );
      return;
    } catch (e) {
      debugPrint('CONFIRM  $e');
    }

    var updatedOrder = order;
    final roundOff = double.tryParse(_roundOff.text) ?? 0;
    final serviceCharge = double.tryParse(_serviceCharge.text) ?? 0;
    updatedOrder = updatedOrder.copyWith(
      amtPayable: _amountPayable,
      roundOffAmt: roundOff,
      serviceCharge: serviceCharge,
    );

    final res = await completeOrder(order: updatedOrder);
    res.fold(
      (failure) {
        final snackBar = SnackBar(
          content: Text(failure.errorMessage),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      (_) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DeliveryDashboard()),
        );
      },
    );
  }

  @override
  void dispose() {
    _newItemQty.dispose();
    _newItemPrice.dispose();
    _serviceCharge.dispose();
    _roundOff.dispose();
    super.dispose();
  }
}

class AutoSearch extends StatelessWidget {
  const AutoSearch({
    required this.options,
    required this.onSelected,
    super.key,
  });
  final List<ScrapModel> options;
  final void Function(ScrapModel) onSelected;
  @override
  Widget build(BuildContext context) {
    return Autocomplete<ScrapModel>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text == '') {
          return const Iterable<ScrapModel>.empty();
        }
        return options.where(
          (scrap) => scrap.scrapName
              .toLowerCase()
              .contains(textEditingValue.text.toLowerCase()),
        );
      },
      displayStringForOption: (sp) {
        return sp.scrapName;
      },
      optionsViewBuilder: (_, callback, options) {
        return Material(
          child: SizedBox(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: options.map((opt) {
                  return GestureDetector(
                    onTap: () {
                      onSelected(opt);
                      callback(opt);
                    },
                    child: Container(
                      padding: const EdgeInsets.only(right: 40),
                      child: Card(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          child: Text(opt.scrapName),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ignore_for_file: lines_longer_than_80_chars, inference_failure_on_instance_creation, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:treeo_delivery/core/app_enums/scrap_type.dart';
import 'package:treeo_delivery/core/extensions/context_ext.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/core/utils/calculation_helper.dart';
import 'package:treeo_delivery/core/utils/snack_bar.dart';
import 'package:treeo_delivery/data/orders/model/scrap_model.dart';
import 'package:treeo_delivery/data/orders/model/scrap_order_model.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/domain/orders/usecase/complete_order.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/widgets/add_more_items.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/widgets/input_field.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/widgets/item_listing_widget.dart';
import 'package:treeo_delivery/presentation/screens/1_scrap_orders/widgets/order_basic_info.dart';
import 'package:treeo_delivery/presentation/screens/deliverydashboard.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';
import 'package:treeo_delivery/presentation/widget/style.dart';

class ConfirmOrderScreen extends StatefulWidget {
  const ConfirmOrderScreen({required this.order, super.key});
  final ScrapOrder order;

  @override
  State<ConfirmOrderScreen> createState() => _ConfirmOrderScreenState();
}


class _ConfirmOrderScreenState extends State<ConfirmOrderScreen> {
  late ScrapOrderModel order;
  late final ScrapType _type;
  var _total = 0.0;
  var _amountPayable = 0.0;
  late final TextEditingController _serviceCharge;
  late final TextEditingController _roundOff;
  late final TextEditingController _newItemQty;
  late final TextEditingController _newItemPrice;
  late final TextEditingController _orderCode;

  final completeOrder = GetIt.I.get<CompleteOrder>();

  ScrapModel? _newScrap;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    order = (widget.order as ScrapOrderModel).clone();
    _type = order.type;
    _serviceCharge = TextEditingController(text: '0.0');
    _roundOff = TextEditingController(text: '0.0');
    _newItemQty = TextEditingController();
    _newItemPrice = TextEditingController();
    _orderCode = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final kHeight01 = SizedBox(height: height * .01);
    return WillPopScope(
      onWillPop: () async {
        return await showPopup() ?? false;
      },
      child: Scaffold(
        backgroundColor: whiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(left: width * .05, right: width * .05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppbarSection(
                    heading: ' Confirm Order',
                    onBackTap: () {
                      showPopup().then((canGoback) {
                        if (canGoback ?? false) {
                          Navigator.pop(context);
                        }
                      });
                    },
                  ),
                  OrderBasicInfo(order: order),
                  ItemListingWidget(
                    order: order,
                    onTap: (index) async {
                      await _showMyDialog(
                        context: context,
                        index: index,
                      );
                    },
                  ),
                  const Line(),
                  AddMoreItems(
                    newItemPrice: _newItemPrice,
                    newItemQty: _newItemQty,
                    autoSearchOnSelected: (selected) {
                      _newScrap = selected;
                      _newItemQty.text = (selected?.qty ?? '').toString();
                      _newItemPrice.text = (selected?.price ?? '').toString();
                    },
                    onAddItemClick: _addNewItem,
                  ),
                  const Line(),
                  kHeight01,
                  LabeledInputField(
                    label:
                        'Add Service charge (${_type == ScrapType.scrap ? kMSymbl : kPSymbl}): ',
                    controller: _serviceCharge,
                    onChanged: (v) {
                      _calculateTotal();
                    },
                  ),
                  kHeight01,
                  LabeledInputField(
                    label:
                        'Add Round off (${_type == ScrapType.scrap ? kPSymbl : kMSymbl}): ',
                    controller: _roundOff,
                    onChanged: (v) {
                      _calculateTotal();
                    },
                  ),
                  kHeight01,
                  const Line(),
                  kHeight01,
                  AddedResult(
                    label: 'Total: ',
                    amount: _total,
                  ),
                  kHeight01,
                  AddedResult(
                    label: 'Amount payable: ',
                    amount: _amountPayable,
                  ),
                  // kHeight02,
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _type == ScrapType.scrap
                          ? '( $_total + ${double.tryParse(_roundOff.text) ?? 0} - ${double.tryParse(_serviceCharge.text) ?? 0} )'
                          : '( $_total + ${double.tryParse(_serviceCharge.text) ?? 0} - ${double.tryParse(_roundOff.text) ?? 0} )',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const Line(),
                  kHeight01,
                  LabeledInputField(
                    label: 'Enter Order Code ',
                    controller: _orderCode,
                    keyboardType: TextInputType.text,
                  ),
                  kHeight01,
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
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  kHeight01,
                ],
              ),
            ),
          ),
        ),
      ),
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
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        hintText: 'Enter Qty',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
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
                  price: CalculationHelper.stringToDouble(priceController.text),
                  qty: CalculationHelper.stringToDouble(
                    qtyController.text,
                    isQty: true,
                  ),
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

  void _calculateTotal() {
    final roundOff = CalculationHelper.stringToDouble(_roundOff.text);
    final serviceCharge = CalculationHelper.stringToDouble(_serviceCharge.text);

    final ttl = order.invoicedScraps!.scraps
        .fold<double>(0, (pre, sp) => (sp.price * sp.qty) + pre);

    setState(() {
      _total = CalculationHelper.stringToDouble('$ttl');
      if (_type == ScrapType.scrap) {
        _amountPayable = CalculationHelper.stringToDouble(
          '${_total + roundOff - serviceCharge}',
        );
      } else {
        _amountPayable = CalculationHelper.stringToDouble(
          '${_total + serviceCharge - roundOff}',
        );
      }
    });
  }

  void _addNewItem() {
    if (_newScrap != null) {
      if (order.invoicedScraps?.scraps.contains(_newScrap) ?? false) {
        AppSnackBar.showSnackBar(context, 'Item already added');
        return;
      } else {
        final qty = double.tryParse(
          _newItemQty.text.trim().replaceFirst(RegExp(r'^\D*'), ''),
        );
        final price = double.tryParse(
          _newItemPrice.text.trim().replaceFirst(RegExp(r'^\D*'), ''),
        );
        if (qty != null && price != null) {
          _newScrap = _newScrap!.copyWith(
            price: CalculationHelper.stringToDouble(_newItemPrice.text),
            qty:
                CalculationHelper.stringToDouble(_newItemQty.text, isQty: true),
          );
          order.invoicedScraps!.scraps.add(_newScrap!);
          FocusManager.instance.primaryFocus?.unfocus();
          _calculateTotal();
          _newItemPrice.clear();
          _newItemQty.clear();
          _newScrap = null;
        }
      }
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
        AppSnackBar.showSnackBar(
          context,
          'Order Completed Successfully!',
        );
        context.pushAndRemoveUntil(const DeliveryDashboard());
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

class AddedResult extends StatelessWidget {
  const AddedResult({
    required this.amount,
    required this.label,
    super.key,
  });

  final double amount;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: tStyle15W600,
        ),
        Text(
          '₹$amount',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

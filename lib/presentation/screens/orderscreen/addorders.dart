// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:treeo_delivery/core/extensions/date_ext.dart';
import 'package:treeo_delivery/core/utils/snack_bar.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/presentation/screens/orderscreen/add_new_order_cubit/add_new_order_cubit.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class AddOrders extends StatefulWidget {
  const AddOrders({super.key});

  @override
  State<AddOrders> createState() => _AddOrdersState();
}

class _AddOrdersState extends State<AddOrders> {
  late final TextEditingController _ph;
  late final TextEditingController _name;
  late final TextEditingController _date;
  late final TextEditingController _addrtess;
  final _key = GlobalKey<FormState>();
  DateTime? _pickupDate;

  bool showCustomerOtherDetailsPage = false;

  final ValueNotifier<bool> _loader = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _ph = TextEditingController(text: '1234567890');
    _name = TextEditingController(text: 'l');
    _date = TextEditingController();
    _addrtess = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AddNewOrderCubit, AddNewOrderState>(
        listenWhen: (_, state) => state is AddNewOrderPlaced || state is AddNewOrderError,
        listener: (_, state) {
          if (state is AddNewOrderPlaced) {
            Navigator.pop(context);
          }else if (state is AddNewOrderError){
            AppSnackBar.showSnackBar(context, 'Something wnt wrong. Please try again.');
          }
        },
        buildWhen: (_, state) => state is! AddNewOrderPlaced,
        builder: (context, state) {
          var showLoading = false;
          ScrapOrder? order;
          if (state is AddNewOrderInitial || state is UserAlreadyExist) {
            showCustomerOtherDetailsPage = false;
            if (state is UserAlreadyExist) {
              order = state.order;
            }
          } else if (state is NewUserState) {
            showCustomerOtherDetailsPage = true;
          } else if (state is AddNewOrderLoading) {
            showLoading = true;
          }

          if (!showCustomerOtherDetailsPage) {
            return Stack(
              children: [
                Form(
                  key: _key,
                  child: Column(
                    children: [
                      SizedBox(height: size.height * .065),
                      const AppbarSection(heading: 'Add Orders'),
                      SizedBox(height: size.height * .05),
                      CustomTextfeild(
                        searchterm: 'Customer name',
                        controller: _name,
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Enter customer name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * .02),
                      CustomTextfeild(
                        searchterm: 'Customer Mobile no.',
                        keyboardType: TextInputType.phone,
                        inputFormatters: phonInputFormat,
                        controller: _ph,
                        validator: (v) {
                          if (v == null || v.trim().length != 10) {
                            return 'Enter valid number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: size.height * .02),
                      Stack(
                        children: [
                          OrderContainer(
                            name: 'Verify Customer',
                            onTap: () {
                              if (_key.currentState!.validate()) {
                                context.read<AddNewOrderCubit>().verifyUser(
                                      phone: _ph.text,
                                    );
                              }
                            },
                          ),
                          if (showLoading)
                            Container(
                              color: Colors.white38,
                              width: size.width * .9,
                              height: size.height * .055,
                              alignment: Alignment.center,
                              child: const CircularProgressIndicator(),
                            ),
                        ],
                      ),
                      SizedBox(height: size.height * .02),
                    ],
                  ),
                ),

                // Overlay
                if (order != null)
                  Positioned(
                    width: size.width,
                    height: size.height,
                    child: ColoredBox(
                      color: Colors.black38,
                      child: Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              width: size.shortestSide * 0.8,
                              height: size.shortestSide * 0.8,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                children: [
                                  const Spacer(),
                                  const CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    minRadius: 30,
                                    child: Icon(
                                      Icons.person,
                                      color: Color(0xFFE0E0E0),
                                      size: 50,
                                    ),
                                  ),
                                  const Spacer(),
                                  const Text(
                                    'User already exist. Do you want to create new order under this user?',
                                    style: TextStyle(fontSize: 16),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Spacer(
                                    flex: 3,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Cancel',
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _loader.value = true;
                                          context
                                              .read<AddNewOrderCubit>()
                                              .addOrderForExistingUser(order!);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: darkgreen,
                                        ),
                                        child: const Text(
                                          'Continue',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                            ValueListenableBuilder(
                              valueListenable: _loader,
                              builder: (_, val, __) {
                                return val
                                    ? const CircularProgressIndicator()
                                    : const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          } else {
            return Form(
              key: _key,
              child: Column(
                children: [
                  SizedBox(height: size.height * .065),
                  const AppbarSection(heading: 'Add Orders'),
                  SizedBox(height: size.height * .05),
                  CustomTextfeild(
                    searchterm: 'Customer name',
                    controller: _name,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Enter customer name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * .02),
                  CustomTextfeild(
                    searchterm: 'Customer Mobile no.',
                    inputFormatters: phonInputFormat,
                    controller: _ph,
                    readOnly: true,
                  ),
                  SizedBox(height: size.height * .02),
                  CustomTextfeild(
                    searchterm: 'Pick up time.',
                    keyboardType: TextInputType.phone,
                    controller: _date,
                    suffixIcon: InkWell(
                      onTap: () async {
                        final date = await _selectDate();
                        if (date != null) {
                          _date.text = date.toDate;
                          _pickupDate = date;
                        }
                      },
                      child: const Icon(Icons.calendar_month),
                    ),
                    readOnly: true,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Select pickup date';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * .02),
                  CustomTextfeild(
                    searchterm: 'Address.',
                    keyboardType: TextInputType.text,
                    controller: _addrtess,
                    validator: (val) {
                      if (val == null || val.trim().isEmpty) {
                        return 'Enter valid address';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: size.height * .02),
                  Stack(
                    children: [
                      OrderContainer(
                        name: 'Create Order',
                        onTap: () {
                          if (_key.currentState!.validate()) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<AddNewOrderCubit>().createOrder(
                                  name: _name.text.trim(),
                                  phone: _ph.text.trim(),
                                  address: _addrtess.text.trim(),
                                  pickupDate: _pickupDate!,
                                );
                          }
                        },
                      ),
                      if (showLoading)
                        Container(
                          color: Colors.white38,
                          width: size.width * .9,
                          height: size.height * .055,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                    ],
                  ),
                  SizedBox(height: size.height * .02),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<DateTime?> _selectDate() async {
    final today = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: today,
      initialDate: today,
      lastDate: DateTime(2100),
    );
    return date;
  }
}

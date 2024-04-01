import 'dart:async';

import 'package:flutter/material.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/domain/orders/usecase/order_usecases.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';

class ScrapOrderScreen extends StatefulWidget {
  const ScrapOrderScreen({super.key});

  @override
  State<ScrapOrderScreen> createState() => _ScrapOrderScreenState();
}

class _ScrapOrderScreenState extends State<ScrapOrderScreen> {
  late final StreamController<Iterable<ScrapOrder>> _orderStreamControl;
  StreamSubscription<Iterable<ScrapOrder>>? _subscription;

  @override
  void initState() {
    super.initState();
    _orderStreamControl = StreamController();
    _loadOrders();
  }

  void _loadOrders([String? searchText]) {
    _subscription?.cancel(); // Cancel the previous subscription if it exists
    _subscription =
        OrderUsecases.I.getAllPendingAssignedOrders(searchText).listen((event) {
      _orderStreamControl.sink.add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: height * .065),
            
            const AppbarSection(
              heading: 'Pending Orders',
            ),
            SizedBox(
              height: height * .015,
            ),
            OrderContainer(
              name: 'All Orders',
              onTap: () {},
            ),
            SizedBox(height: height * .02),
            SearchBox(
              onEditingComplete: _loadOrders,
            ),
            CustomerdeatilList(
              orderStream: _orderStreamControl.stream,
            ),
          ],
        ),
      ),
    );
  }
}

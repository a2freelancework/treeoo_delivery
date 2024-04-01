// ignore_for_file: prefer_final_fields

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/domain/orders/orders_const_info.dart';
import 'package:treeo_delivery/domain/orders/usecase/order_usecases.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';

class ScrapHistory extends StatefulWidget {
  const ScrapHistory({super.key});

  @override
  State<ScrapHistory> createState() => _ScrapHistoryState();
}

class _ScrapHistoryState extends State<ScrapHistory> {


  late final StreamController<Iterable<ScrapOrder>> _orderStreamControl;
  late final ValueNotifier<bool> _bottomLoader;
  late final ScrollController _scrol;
  StreamSubscription<Iterable<ScrapOrder>>? _subscription;
  Iterable<ScrapOrder> _ordersList = [];
  
    int _page = firstPage;

  @override
  void initState() {
    super.initState();
    _orderStreamControl = StreamController();
    _scrol = ScrollController();
    _bottomLoader = ValueNotifier(false);
    _scrol.addListener(_scrollListener);
    _loadInvoices(_page);
  }
  
  void _scrollListener() {
    final pos = _scrol.position;
    if (!_bottomLoader.value &&
        pos.pixels == pos.maxScrollExtent &&
        _ordersList.length == _page * ordersPerPage) {
      _bottomLoader.value = true;
      _loadInvoices(++_page);
    }
  }
  
  void _loadInvoices(int limit) {
    _subscription?.cancel(); // Cancel the previous subscription if it exists
    _subscription = OrderUsecases.I.stream(page: limit).listen((event) {
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
            const AppbarSection(heading: 'Scrap History'),
            SizedBox(height: height * .015),
            
            SearchBox(
              onEditingComplete: (text) {

              },
            ),
            SizedBox(height: height * .015),
            RescheduledCustomerData(
              controller: _orderStreamControl,
            ),
          ],
        ),
      ),
    );
  }
}

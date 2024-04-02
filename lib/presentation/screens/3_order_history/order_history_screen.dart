// ignore_for_file: prefer_final_fields, lines_longer_than_80_chars

import 'dart:async';

import 'package:flutter/cupertino.dart' show CupertinoActivityIndicator;
import 'package:flutter/material.dart';
import 'package:treeo_delivery/domain/orders/entity/scrap_order_entity.dart';
import 'package:treeo_delivery/domain/orders/orders_const_info.dart';
import 'package:treeo_delivery/domain/orders/usecase/order_usecases.dart';
import 'package:treeo_delivery/presentation/screens/3_order_history/widgets/order_history_listview.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  late final StreamController<Iterable<ScrapOrder>> _orderStreamControl;
  late final ValueNotifier<bool> _bottomLoader;
  late final ScrollController _scrol;
  StreamSubscription<Iterable<ScrapOrder>>? _subscription;
  // Iterable<ScrapOrder> _ordersList = [];

  int _page = firstPage;

  @override
  void initState() {
    super.initState();
    _orderStreamControl = StreamController();
    _scrol = ScrollController()..addListener(_listener);
    _bottomLoader = ValueNotifier(false);
    _loadInvoices(_page);
  }

  void _listener() {
    final pos = _scrol.position;
    if (!_bottomLoader.value &&
        pos.pixels == pos.maxScrollExtent 
        // &&  _ordersList.length == _page * ordersPerPage
        ) {
      _bottomLoader.value = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        _loadInvoices(++_page);
      });
    }
  }

  void _loadInvoices(int limit) {
    _subscription?.cancel(); // Cancel the previous subscription if it exists
    _subscription = OrderUsecases.I.stream(page: limit).listen((event) {
      _orderStreamControl.sink.add(event);
      _bottomLoader.value = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: height * .065),
              const AppbarSection(heading: 'Scrap History'),
              SizedBox(height: height * .015),
              // SearchBox(
              //   onEditingComplete: (text) {
              //   },
              // ),
              SizedBox(height: height * .015),
              Flexible(
                child: OrderHistoryList(
                  scrollControll: _scrol,
                  streamControl: _orderStreamControl,
                  // onScrollChange: _listener,
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 50,
            child: ValueListenableBuilder(
              valueListenable: _bottomLoader,
              builder: (_, isloading, __) {
                return isloading
                    ? const CupertinoActivityIndicator(
                        color: darkgreen,
                        radius: 20,
                      )
                    : const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrol.dispose();
    _orderStreamControl.close();
    super.dispose();
  }
}

// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class OrderRejectionReason extends StatefulWidget {
  const OrderRejectionReason({
    required this.onReasonSelect,
    required this.isCancelOrder,
    super.key,
  });

  final bool isCancelOrder;
  final void Function(String reason) onReasonSelect;

  @override
  State<OrderRejectionReason> createState() => _OrderRejectionReasonState();
}

class _OrderRejectionReasonState extends State<OrderRejectionReason> {
  String? _selectedReason;
  late final TextEditingController _ctrl;
  late String appbarTitle;
  late List<String> reasons;
  @override
  void initState() {
    super.initState();
    appbarTitle = widget.isCancelOrder ? 'Cancel Order' : 'Drop Order';
    reasons = widget.isCancelOrder ? _resonToCancel : _resonToDrop;
    _ctrl = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          appbarTitle,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: darkgreen,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey.shade200,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'Why are you canceling this order?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView(
                children: reasons
                    .map(
                      (r) => RadioListTile<String>(
                        value: r,
                        groupValue: _selectedReason,
                        title: Text(r),
                        onChanged: (val) {
                          setState(() {
                            _selectedReason = val;
                          });
                          if (val != 'Other') {
                            _ctrl.clear();
                          }
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            if (_selectedReason == 'Other')
              TextFormField(
                controller: _ctrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  focusedBorder: OutlineInputBorder(),
                  border: OutlineInputBorder(),
                  // enabledBorder:
                ),
              ),
            const SizedBox(
              height: 80,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ListenableBuilder(
        listenable: _ctrl,
        builder: (_, __) {
          return ElevatedButton(
            onPressed: _selectedReason == null ||
                    (_selectedReason == 'Other' && _ctrl.text.trim().isEmpty)
                ? null
                : () {
                    widget.onReasonSelect(
                      _selectedReason == 'Other'
                          ? _ctrl.text.trim()
                          : _selectedReason!,
                    );
                    Navigator.pop(context);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: darkgreen,
              minimumSize: const Size(200, 50),
            ),
            child: const Text(
              'Submit',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          );
        },
      ),
    );
  }
}

const _resonToCancel = [
  'Not acceptable items',
  'Customer is out of station',
  'Items were already sold',
  'Customer requested to cancel',
  "Customer don't pickup the call",
  'Other',
];

const _resonToDrop = [
  "I'm sick",
  'Vehicle is break down',
  'I have an urgent pickup',
  'I am not near to the address',
  'Other',
];

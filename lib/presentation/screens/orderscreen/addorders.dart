import 'package:flutter/material.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';
class AddOrders extends StatefulWidget {
  const AddOrders({super.key});

  @override
  State<AddOrders> createState() => _AddOrdersState();
}

class _AddOrdersState extends State<AddOrders> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              height: height * .065,
            ),
            const AppbarSection(
              heading: 'Add Orders',
            ),
            SizedBox(
              height: height * .05,
            ),
            const CustomTextfeild(
              searchterm: 'Customer name',
            ),
            SizedBox(
              height: height * .02,
            ),
            const CustomTextfeild(
              searchterm: 'Customer Mobile no.',
            ),
            SizedBox(
              height: height * .02,
            ),
            OrderContainer(
              name: 'Verify Customer',
              onTap: () {},
            ),
            SizedBox(
              height: height * .02,
            ),
          ],
        ),
      ),
    );
  }
}

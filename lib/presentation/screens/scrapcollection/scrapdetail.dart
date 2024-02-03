import 'package:flutter/material.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';


class ScrapDetail extends StatefulWidget {
  const ScrapDetail({super.key});

  @override
  State<ScrapDetail> createState() => _ScrapDetailState();
}

class _ScrapDetailState extends State<ScrapDetail> {
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
              heading: ' Scrap Collection',
            ),
            const Scarpdetailcard(),
          ],
        ),
      ),
    );
  }
}

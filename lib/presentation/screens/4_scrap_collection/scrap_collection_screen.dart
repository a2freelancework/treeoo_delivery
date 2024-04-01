import 'package:flutter/material.dart';
import 'package:treeo_delivery/presentation/screens/4_scrap_collection/widgets/scrap_collection_grid.dart';
import 'package:treeo_delivery/presentation/widget/appbarsection.dart';


class ScrapCollectionScreen extends StatefulWidget {
  const ScrapCollectionScreen({super.key});

  @override
  State<ScrapCollectionScreen> createState() => _ScrapCollectionScreenState();
}

class _ScrapCollectionScreenState extends State<ScrapCollectionScreen> {
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
            const ScrapCollectionGrid(),
          ],
        ),
      ),
    );
  }
}

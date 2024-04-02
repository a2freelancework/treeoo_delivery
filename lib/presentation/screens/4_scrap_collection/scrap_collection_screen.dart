import 'package:flutter/material.dart';
import 'package:treeo_delivery/presentation/screens/4_scrap_collection/scrap_collection_cubit/collection_helper.dart';
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
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            SizedBox(
              height: height * .065,
            ),
            const AppbarSection(
              heading: ' My Collections',
            ),
            const TabBar(
              tabs: [
                Tab(icon: Text('Scraps')),
                Tab(icon: Text('Waste')),
              ],
            ),
            Flexible(
              child: TabBarView(
                children: [
                  ScrapCollectionGrid(
                    stream: CollectionHelper.scrapCollections(),
                  ),
                  ScrapCollectionGrid(
                    stream: CollectionHelper.wasteCollections(),
                  ),
                ],
              ),
            ),
            // const ScrapCollectionGrid(),
          ],
        ),
      ),
    );
  }
}

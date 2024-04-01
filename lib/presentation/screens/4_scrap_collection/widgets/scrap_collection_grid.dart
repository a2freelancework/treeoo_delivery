
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_animation_transition/animations/fade_animation_transition.dart';
import 'package:page_animation_transition/page_animation_transition.dart';
import 'package:treeo_delivery/core/services/user_auth_service.dart';
import 'package:treeo_delivery/presentation/screens/4_scrap_collection/scrap_collection_cubit/scrap_collection_cubit.dart';
import 'package:treeo_delivery/presentation/screens/4_scrap_collection/collection_details_screen.dart';
import 'package:treeo_delivery/presentation/widget/reusable_colors.dart';

class ScrapCollectionGrid extends StatelessWidget {
  const ScrapCollectionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final vehicle = UserAuth.I.currentUser!.vehicle!;
    return BlocBuilder<ScrapCollectionCubit, ScrapCollectionState>(
      builder: (context, state) {
        if (state is ScrapCollectionLoaded) {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(8), // padding around the grid
            itemCount: state.collection.length, // total number of items
            itemBuilder: (context, index) {
              final collection = state.collection.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageAnimationTransition(
                        page: CollectionDetailsScreen(collection: collection),
                        pageAnimationType: FadeAnimationTransition(),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: peahcream,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    width: width,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                UserAuth.I.currentUser!.name, //'sooraj',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                vehicle.number, //'KL 16 A 7654',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: red,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                UserAuth.I.currentUser!.phone, //'8848990138',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                              Text(
                                vehicle.name, //'Maruthi Super Carry',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Gilroy',
                                  fontSize: 15,
                                  letterSpacing: .4,
                                  color: blackColor,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * .01,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        } else if (state is ScrapCollectionError) {
          return Center(
            child: Text(state.message),
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

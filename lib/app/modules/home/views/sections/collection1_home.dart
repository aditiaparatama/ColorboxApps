import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:colorbox/app/modules/home/controllers/homecollections_controller.dart';
import 'package:colorbox/app/modules/home/views/widgets/item_card_ending.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/item_card.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class CollectionHome1 extends GetView<HomeController> {
  final int id;
  final int index;
  const CollectionHome1({Key? key, required this.id, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    HomeCollectionsController homeCollectionController =
        Get.put(HomeCollectionsController(), tag: index.toString());
    homeCollectionController.fetchCollectionProduct(id, defaultSortBy);
    return GetBuilder<HomeCollectionsController>(
        init: homeCollectionController,
        tag: index.toString(),
        builder: (_) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              height: Get.height * .45,
              child: (homeCollectionController.collection.products.isEmpty)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : GridView.builder(
                      itemCount:
                          homeCollectionController.collection.products.length,
                      scrollDirection: Axis.horizontal,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 24,
                        crossAxisSpacing: 24,
                        childAspectRatio: 5 / 2.6,
                      ),
                      itemBuilder: (_, i) {
                        var calcu1 = int.parse(homeCollectionController
                                .collection.products[i].variants[0].price!
                                .replaceAll(".00", "")) /
                            int.parse(homeCollectionController.collection
                                .products[i].variants[0].compareAtPrice!
                                .replaceAll(".00", ""));

                        return (i ==
                                (homeCollectionController
                                        .collection.products.length -
                                    1))
                            ? ItemCardEnding(
                                calcu1: calcu1,
                                collection: homeCollectionController.collection,
                                homeCollection: {
                                  "title": controller.collections[0].title,
                                  "subjectid":
                                      controller.collections[0].subjectid
                                },
                                i: i,
                              )
                            : GestureDetector(
                                onTap: () =>
                                    Get.toNamed(Routes.PRODUCT, arguments: {
                                  "product": homeCollectionController
                                      .collection.products[i],
                                  "idCollection":
                                      homeCollectionController.collection.id,
                                  "handle": homeCollectionController
                                      .collection.products[i].handle
                                }),
                                child: ItemCard(
                                  onPress: () {},
                                  controller: homeCollectionController,
                                  product: homeCollectionController
                                      .collection.products[i],
                                  index: i,
                                  compareAtPrice: homeCollectionController
                                      .collection
                                      .products[i]
                                      .variants[0]
                                      .compareAtPrice!
                                      .replaceAll(".00", ""),
                                  price: homeCollectionController
                                      .collection.products[i].variants[0].price!
                                      .replaceAll(".00", ""),
                                  image: homeCollectionController
                                      .collection.products[i].image[0],
                                  title: homeCollectionController
                                      .collection.products[i].title,
                                  totalInventory: homeCollectionController
                                      .collection.products[i].totalInventory,
                                ),
                              );
                      }),
            ),
          );
        });
  }
}

import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:colorbox/app/modules/home/controllers/homecollections_controller.dart';
import 'package:colorbox/app/modules/home/views/widgets/item_card.dart';
import 'package:colorbox/app/modules/home/views/widgets/item_card_ending.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class CollectionHome1 extends GetView<HomeCollectionsController> {
  var homeCollection = Get.put(HomeController());
  final String? id;

  CollectionHome1(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var control = Get.put(HomeCollectionsController());

    control.fetchCollectionProduct(int.parse(id!), defaultSortBy);
    return GetBuilder<HomeCollectionsController>(
        init: Get.put(HomeCollectionsController()),
        builder: (controller) {
          return SizedBox(
            height: Get.height * .45,
            child: (controller.collection.products.isEmpty)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: controller.collection.products.length,
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 24,
                      childAspectRatio: 5 / 2.6,
                    ),
                    itemBuilder: (_, i) {
                      var calcu1 = int.parse(controller
                              .collection.products[i].variants[0].price!
                              .replaceAll(".00", "")) /
                          int.parse(controller.collection.products[i]
                              .variants[0].compareAtPrice!
                              .replaceAll(".00", ""));

                      return (i == (controller.collection.products.length - 1))
                          ? ItemCardEnding(
                              calcu1: calcu1,
                              collection: controller.collection,
                              homeCollection: {
                                "title": homeCollection.collections[0].title,
                                "subjectid":
                                    homeCollection.collections[0].subjectid
                              },
                              i: i,
                            )
                          : ItemCard(
                              calcu1: calcu1,
                              collection: controller.collection,
                              i: i,
                            );
                    }),
          );
        });
  }
}

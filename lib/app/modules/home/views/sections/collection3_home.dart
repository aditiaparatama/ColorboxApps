import 'package:colorbox/app/modules/home/controllers/homecollections_controller.dart';
import 'package:colorbox/app/modules/home/views/widgets/item_card.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class CollectionHome3 extends GetView<HomeCollectionsController> {
  var formatter = NumberFormat('###,000');
  final String? id;

  CollectionHome3(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var control = Get.put(HomeCollectionsController());

    control.fetchCollectionProduct3(int.parse(id!), defaultSortBy);
    return GetBuilder<HomeCollectionsController>(
        init: Get.put(HomeCollectionsController()),
        builder: (controller) {
          return SizedBox(
            height: Get.height * .45,
            child: (controller.collection3.products.isEmpty)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: controller.collection3.products.length,
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 24,
                      crossAxisSpacing: 30,
                      childAspectRatio: 2.0,
                    ),
                    itemBuilder: (_, i) {
                      var calcu1 = int.parse(controller
                              .collection3.products[i].variants[0].price!
                              .replaceAll(".00", "")) /
                          int.parse(controller.collection3.products[i]
                              .variants[0].compareAtPrice!
                              .replaceAll(".00", ""));
                      int calcu2 = (100 - calcu1 * 100).ceil();

                      return ItemCard(
                        calcu2: calcu2,
                        collection: controller.collection3,
                        i: i,
                      );
                    }),
          );
        });
  }
}

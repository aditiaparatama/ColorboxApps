import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class CollectionsProductView extends StatelessWidget {
  final String? id;

  // ignore: prefer_const_constructors_in_immutables
  CollectionsProductView(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(CollectionsController(), tag: "similiar");

    controller.fetchCollectionProduct(int.parse(id!), 4);
    return GetBuilder<CollectionsController>(
        tag: "similiar",
        init: controller,
        builder: (_) {
          return (controller.collection.products.isEmpty)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.collection.products.length,
                  // scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 0,
                    crossAxisSpacing: 16,
                    childAspectRatio: 4.1 / 9,
                  ),
                  itemBuilder: (_, i) {
                    return GestureDetector(
                      onTap: () {
                        // Get.back();
                        Get.offNamed(Routes.PRODUCT,
                            arguments: {
                              "product": controller.collection.products[i],
                              "idCollection": controller.collection.id,
                              "handle": controller.collection.products[i].handle
                            },
                            preventDuplicates: false);
                      },
                      child: ItemCard(
                          onPress: () {},
                          controller: controller,
                          product: controller.collection.products[i],
                          compareAtPrice: controller.collection.products[i]
                              .variants[0].compareAtPrice!
                              .replaceAll(".00", ""),
                          price: controller
                              .collection.products[i].variants[0].price!
                              .replaceAll(".00", ""),
                          image: controller.collection.products[i].image[0],
                          title: controller.collection.products[i].title,
                          totalInventory:
                              controller.collection.products[i].totalInventory,
                          index: i),
                    );
                  });
        });
  }
}

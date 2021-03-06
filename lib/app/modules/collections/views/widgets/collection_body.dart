import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/item_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollectionBody extends StatelessWidget {
  const CollectionBody({
    Key? key,
    required this.controller,
    required ScrollController sControl,
  })  : _sControl = sControl,
        super(key: key);

  final CollectionsController controller;
  final ScrollController _sControl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          height: MediaQuery.of(context).size.height * .80,
          // Get.height - (controller.nextLoad.value ? Get.height * 0.1 : 140),
          // height: Get.height - (controller.nextLoad.value ? 170 : 140),
          child: GridView.builder(
              controller: _sControl,
              itemCount: controller.collection.products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 3,
                crossAxisSpacing: 3,
                childAspectRatio: 0.6,
              ),
              itemBuilder: (_, i) {
                return GestureDetector(
                  onTap: () => Get.toNamed(Routes.PRODUCT,
                      arguments: controller.collection.products[i]),
                  child: ItemCard(
                    title: controller.collection.products[i].title!,
                    image: controller.collection.products[i].image[0],
                    price: controller.collection.products[i].variants[0].price!
                        .replaceAll(".00", ""),
                    compareAtPrice: (controller.collection.products[i]
                                .variants[0].compareAtPrice ==
                            null)
                        ? "0"
                        : controller
                            .collection.products[i].variants[0].compareAtPrice!
                            .replaceAll(".00", ""),
                    onPress: () {},
                  ),
                );
              }),
        ),
        controller.nextLoad.value
            ? const Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

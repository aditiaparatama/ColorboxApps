import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/widgets/item_card.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/constance.dart';
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
        Flexible(
          child: SizedBox(
            child: GridView.builder(
                padding: const EdgeInsets.all(0),
                controller: _sControl,
                itemCount: controller.collection.products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  childAspectRatio: 2.6 / 5,
                ),
                itemBuilder: (_, i) {
                  return GestureDetector(
                    onTap: () => Get.toNamed(Routes.PRODUCT, arguments: {
                      "product": controller.collection.products[i],
                      "idCollection": controller.collection.id
                    }),
                    child: ItemCard(
                      title: controller.collection.products[i].title!,
                      image: controller.collection.products[i].image[0],
                      price: controller
                          .collection.products[i].variants[0].price!
                          .replaceAll(".00", ""),
                      compareAtPrice: (controller.collection.products[i]
                                  .variants[0].compareAtPrice ==
                              null)
                          ? "0"
                          : controller.collection.products[i].variants[0]
                              .compareAtPrice!
                              .replaceAll(".00", ""),
                      onPress: () {},
                    ),
                  );
                }),
          ),
        ),
        controller.nextLoad.value
            ? Container(
                padding: const EdgeInsets.all(12),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: colorTextBlack,
                  ),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

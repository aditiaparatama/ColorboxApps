import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../../globalvar.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class CollectionsHomeView extends GetView<CollectionsController> {
  var formatter = NumberFormat('###,000');
  @override
  Widget build(BuildContext context) {
    var control = Get.put(CollectionsController());
    control.fetchCollectionProduct(newArrival, defaultSortBy);
    return GetBuilder<CollectionsController>(
        init: Get.put(CollectionsController()),
        builder: (controller) {
          return SizedBox(
            height: Get.height * .4,
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
                      mainAxisSpacing: 3,
                      crossAxisSpacing: 3,
                      childAspectRatio: 1.8,
                    ),
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        onTap: () => Get.toNamed(Routes.PRODUCT, arguments: {
                          "product": controller.collection.products[i],
                          "idCollection": controller.collection.id,
                          "handle": controller.collection.products[i].handle
                        }),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  controller.collection.products[i].image[0],
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                          value: downloadProgress.progress),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: CustomText(
                                text: controller.collection.products[i].title,
                                textOverflow: TextOverflow.fade,
                              ),
                            ),
                            (controller.collection.products[i].variants[0]
                                        .compareAtPrice!
                                        .replaceAll(".00", "") ==
                                    "0")
                                ? Text(
                                    "Rp " +
                                        formatter.format(int.parse(controller
                                            .collection
                                            .products[i]
                                            .variants[0]
                                            .price!
                                            .replaceAll(".00", ""))),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )
                                : Row(
                                    children: [
                                      const Text(
                                        "Rp ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        formatter.format(int.parse(controller
                                                .collection
                                                .products[i]
                                                .variants[0]
                                                .compareAtPrice!
                                                .replaceAll(".00", ""))) +
                                            " ",
                                        style: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                      Text(
                                        formatter.format(int.parse(controller
                                            .collection
                                            .products[i]
                                            .variants[0]
                                            .price!
                                            .replaceAll(".00", ""))),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 229, 57, 53)),
                                      ),
                                    ],
                                  ),
                          ],
                        ),
                      );
                    }),
          );
        });
  }
}

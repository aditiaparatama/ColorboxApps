import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../../../globalvar.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class CollectionsProductView extends GetView<CollectionsController> {
  var formatter = NumberFormat('###,000');
  @override
  Widget build(BuildContext context) {
    var control = Get.put(CollectionsController());
    control.fetchCollectionProduct(NewArrival);
    return GetBuilder<CollectionsController>(
        init: Get.put(CollectionsController()),
        builder: (controller) {
          return SizedBox(
            height: Get.height * .43,
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
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 5,
                      childAspectRatio: 2.0,
                    ),
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        onTap: () => Get.toNamed(Routes.PRODUCT,
                            arguments: controller.collection.products),
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 4, vertical: 10),
                              child: CustomText(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                text: controller.collection.products[i].title,
                                // text: controller.collection.products[i].title,
                                textOverflow: TextOverflow.fade,
                              ),
                            ),
                            (controller.collection.products[i].variants[0]
                                        .compareAtPrice! ==
                                    "0")
                                ? CustomText(
                                    text: "Rp " +
                                        formatter.format(int.parse(controller
                                            .collection
                                            .products[i]
                                            .variants[0]
                                            .price!
                                            .replaceAll(".00", ""))),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  )
                                : Row(
                                    children: [
                                      CustomText(
                                        text: "Rp " +
                                            formatter.format(int.parse(
                                                controller
                                                    .collection
                                                    .products[i]
                                                    .variants[0]
                                                    .compareAtPrice!
                                                    .replaceAll(".00", ""))) +
                                            "  ",
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromRGBO(
                                            155, 155, 155, 1),
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                      Container(
                                        width: 30.0,
                                        height: 20.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color.fromRGBO(
                                              187, 9, 21, 1),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            '20%',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              height: 1,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                            const SizedBox(height: 5),
                            Column(
                              children: [
                                CustomText(
                                  text: "Rp " +
                                      formatter.format(int.parse(controller
                                          .collection
                                          .products[i]
                                          .variants[0]
                                          .price!
                                          .replaceAll(".00", ""))),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: const Color.fromARGB(255, 229, 57, 53),
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

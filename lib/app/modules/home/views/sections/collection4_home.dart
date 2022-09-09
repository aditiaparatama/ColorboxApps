import 'package:colorbox/app/modules/home/controllers/homecollections_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class CollectionHome4 extends GetView<HomeCollectionsController> {
  var formatter = NumberFormat('###,000');
  final String? id;

  CollectionHome4(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var control = Get.put(HomeCollectionsController());

    control.fetchCollectionProduct4(int.parse(id!), defaultSortBy);
    return GetBuilder<HomeCollectionsController>(
        init: Get.put(HomeCollectionsController()),
        builder: (controller) {
          return SizedBox(
            height: Get.height * .45,
            child: (controller.collection4.products.isEmpty)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: controller.collection4.products.length,
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
                              .collection4.products[i].variants[0].price!
                              .replaceAll(".00", "")) /
                          int.parse(controller.collection4.products[i]
                              .variants[0].compareAtPrice!
                              .replaceAll(".00", ""));
                      int calcu2 = (100 - calcu1 * 100).ceil();

                      return GestureDetector(
                        onTap: () => Get.toNamed(Routes.PRODUCT, arguments: {
                          "product": controller.collection4.products[i],
                          "idCollection": controller.collection4.id
                        }),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  controller.collection4.products[i].image[0],
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
                                text: controller.collection4.products[i].title,
                                textOverflow: TextOverflow.ellipsis,
                              ),
                            ),
                            (controller.collection4.products[i].variants[0]
                                        .compareAtPrice! ==
                                    "0")
                                ? CustomText(
                                    text: "Rp " +
                                        formatter.format(int.parse(controller
                                            .collection4
                                            .products[i]
                                            .variants[0]
                                            .price!
                                            .replaceAll(".00", ""))),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                            text: "Rp " +
                                                formatter.format(int.parse(
                                                    controller
                                                        .collection4
                                                        .products[i]
                                                        .variants[0]
                                                        .compareAtPrice!
                                                        .replaceAll(
                                                            ".00", ""))) +
                                                "  ",
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            color: const Color.fromRGBO(
                                                155, 155, 155, 1),
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                          Container(
                                            width: 33.0,
                                            height: 20.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: const Color.fromRGBO(
                                                  187, 9, 21, 1),
                                            ),
                                            child: Center(
                                              child: Text(
                                                calcu2.toString() + '%',
                                                style: const TextStyle(
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
                                          Row(
                                            children: [
                                              CustomText(
                                                text: "Rp " +
                                                    formatter.format(int.parse(
                                                        controller
                                                            .collection4
                                                            .products[i]
                                                            .variants[0]
                                                            .price!
                                                            .replaceAll(
                                                                ".00", ""))),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: const Color.fromARGB(
                                                    255, 229, 57, 53),
                                              ),
                                            ],
                                          ),
                                        ],
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

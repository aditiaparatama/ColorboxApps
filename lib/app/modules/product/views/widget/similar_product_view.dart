import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/constance.dart';
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
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 2.6 / 5,
                  ),
                  itemBuilder: (_, i) {
                    var calcu1 = int.parse(controller
                            .collection.products[i].variants[0].price!
                            .replaceAll(".00", "")) /
                        int.parse(controller
                            .collection.products[i].variants[0].compareAtPrice!
                            .replaceAll(".00", ""));

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CachedNetworkImage(
                            imageUrl:
                                controller.collection.products[i].image[0],
                            imageBuilder: (context, imageProvider) =>
                                AspectRatio(
                              aspectRatio: 2.08 / 3,
                              child: Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    Image.asset("assets/images/Image.jpg"),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                          const SizedBox(height: 12),
                          CustomText(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            text: controller.collection.products[i].title,
                            textOverflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          (controller.collection.products[i].variants[0]
                                          .compareAtPrice! ==
                                      "0" ||
                                  controller.collection.products[i].variants[0]
                                          .compareAtPrice! ==
                                      controller.collection.products[i]
                                          .variants[0].price!)
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
                              : Column(
                                  children: [
                                    Row(
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
                                          fontSize: 10,
                                          fontWeight: FontWeight.w400,
                                          color: colorTextGrey,
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                        const SizedBox(width: 5),
                                        Container(
                                          width: 30.0,
                                          height: 15.0,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(2),
                                            color: colorSaleRed,
                                          ),
                                          child: Center(
                                            child: Text(
                                              (100 - calcu1 * 100)
                                                      .ceil()
                                                      .toString() +
                                                  '%',
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
                                    const SizedBox(height: 4),
                                    Column(
                                      children: [
                                        Row(
                                          children: [
                                            CustomText(
                                              text: "Rp " +
                                                  formatter.format(int.parse(
                                                      controller
                                                          .collection
                                                          .products[i]
                                                          .variants[0]
                                                          .price!
                                                          .replaceAll(
                                                              ".00", ""))),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: colorTextRed,
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
                  });
        });
  }
}

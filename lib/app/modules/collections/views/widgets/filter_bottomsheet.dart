import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/modules/collections/views/widgets/item_filter_bottomsheet.dart';
import 'package:colorbox/app/modules/collections/views/widgets/price_filter_bottomsheet.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void filterBottomSheet() {
  CollectionsController controller = Get.put(CollectionsController());

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.only(top: 27, right: 24, bottom: 16, left: 24),
      height: Get.height *
          ((controller.filterColor != "" ||
                  controller.filterSize != "" ||
                  controller.filterPrice != "")
              ? .4
              : .35),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: GetBuilder<CollectionsController>(builder: (_) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    InkWell(
                        onTap: () => Get.back(),
                        child: const Icon(
                          Icons.close,
                          size: 16,
                        )),
                    const SizedBox(width: 8),
                    const CustomText(
                      text: "Filter Berdasarkan",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    controller.resetFilter(page: true);
                    Get.back();
                  },
                  child: const CustomText(
                    text: "Hapus Semua",
                    color: Color(0xFF115AC8),
                    fontSize: 12,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              separatorBuilder: (_, index) => const Divider(),
              itemCount: controller.collection.filters!.length,
              itemBuilder: (_, index) {
                return InkWell(
                  onTap: () => (controller.collection.filters![index].label!
                              .toLowerCase() ==
                          "harga")
                      ? priceFilterBottomSheet()
                      : itemFilterBottomSheet(index),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomText(
                              text: controller.collection.filters![index].label,
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            )
                          ],
                        ),
                        (controller.filterSize != "" &&
                                controller.collection.filters![index].label ==
                                    "Size")
                            ? Column(
                                children: [
                                  const SizedBox(height: 8),
                                  CustomText(
                                    text:
                                        "(${controller.filterSize.toUpperCase()})",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        (controller.filterColor != "" &&
                                controller.collection.filters![index].label ==
                                    "Color")
                            ? Column(
                                children: [
                                  const SizedBox(height: 8),
                                  CustomText(
                                    text:
                                        "(${controller.filterColor.toUpperCase()})",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              )
                            : const SizedBox(),
                        (controller.filterPrice != "" &&
                                controller.collection.filters![index].label ==
                                    "Harga")
                            ? Column(
                                children: [
                                  const SizedBox(height: 8),
                                  CustomText(
                                    text: "(${controller.filterPrice})",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ],
                              )
                            : const SizedBox()
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        );
      }),
    ),
    isDismissible: true,
    enableDrag: false,
    isScrollControlled: true,
  );
}

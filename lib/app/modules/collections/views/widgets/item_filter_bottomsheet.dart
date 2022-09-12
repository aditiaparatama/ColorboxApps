import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/helper/custom_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

void itemFilterBottomSheet(int index) {
  CollectionsController controller = Get.put(CollectionsController());

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.only(top: 27, right: 24, bottom: 16, left: 24),
      height: Get.height * .5,
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
                    CustomText(
                      text: controller.collection.filters![index].label!,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    (controller.collection.filters![index].label == "Color")
                        ? controller.filterChange("Color", "")
                        : controller.filterChange("Size", "");
                  },
                  child: const CustomText(
                    text: "Hapus",
                    color: Color(0xFF115AC8),
                    fontSize: 12,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            SingleChildScrollView(
              child: SizedBox(
                height: Get.height * .35,
                child: ListView.separated(
                  separatorBuilder: (_, index) => const Divider(
                    color: colorDiver,
                    thickness: 1,
                  ),
                  itemCount:
                      controller.collection.filters![index].values!.length,
                  itemBuilder: (_, i) {
                    return InkWell(
                      onTap: () {
                        controller.filterChange(
                            controller.collection.filters![index].label!
                                .toLowerCase(),
                            controller.collection.filters![index].values![i]
                                .toLowerCase());
                        Get.back();
                        Get.back();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (controller.collection.filters![index].label ==
                                    "Color")
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 18,
                                        width: 18,
                                        decoration: BoxDecoration(
                                            color: customColors(controller
                                                .collection
                                                .filters![index]
                                                .values![i]),
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(50))),
                                      ),
                                      const SizedBox(width: 16),
                                      CustomText(
                                        text: controller.collection
                                            .filters![index].values![i],
                                        fontSize: 14,
                                      ),
                                    ],
                                  )
                                : CustomText(
                                    text: controller
                                        .collection.filters![index].values![i],
                                    fontSize: 14,
                                    fontWeight:
                                        (controller.filterColor.toLowerCase() ==
                                                    controller
                                                        .collection
                                                        .filters![index]
                                                        .values![i]
                                                        .toLowerCase() ||
                                                controller.filterSize
                                                        .toLowerCase() ==
                                                    controller
                                                        .collection
                                                        .filters![index]
                                                        .values![i]
                                                        .toLowerCase())
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                            (controller.filterColor.toLowerCase() ==
                                        controller.collection.filters![index]
                                            .values![i]
                                            .toLowerCase() ||
                                    controller.filterSize ==
                                        controller.collection.filters![index]
                                            .values![i]
                                            .toLowerCase())
                                ? SvgPicture.asset("assets/icon/bx-check.svg")
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
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

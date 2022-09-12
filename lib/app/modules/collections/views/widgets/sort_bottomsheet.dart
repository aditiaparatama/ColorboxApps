import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

void sortBottomSheet(id) {
  CollectionsController controller = Get.put(CollectionsController());
  var sortByContext = int.parse(id.replaceAll("gid://shopify/Collection/", ""));
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.only(top: 27, right: 24, bottom: 16, left: 24),
      height: Get.height * .4,
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
              children: [
                InkWell(
                    onTap: () => Get.back(),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                    )),
                const SizedBox(width: 8),
                const CustomText(
                  text: "Urut Berdasarkan :",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            const SizedBox(
              height: 24,
            ),
            InkWell(
              onTap: () {
                controller.fetchCollectionProduct(sortByContext, 2);
                Get.back();
              },
              child: checklistWidget(2, "Produk Terbaru", controller),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
            InkWell(
              onTap: () {
                controller.fetchCollectionProduct(sortByContext, 1);
                Get.back();
              },
              child: checklistWidget(1, "Popularitas", controller),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
            InkWell(
              onTap: () {
                controller.fetchCollectionProduct(sortByContext, 3);
                Get.back();
              },
              child: checklistWidget(3, "Harga Tinggi ke Rendah", controller),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
            InkWell(
              onTap: () {
                controller.fetchCollectionProduct(sortByContext, 4);
                Get.back();
              },
              child: checklistWidget(4, "Harga Rendah ke Tinggi", controller),
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

Widget checklistWidget(
    int sortBy, String text, CollectionsController controller) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      CustomText(
        text: text,
        fontSize: 14,
        fontWeight: (sortBy == controller.orderBy)
            ? FontWeight.bold
            : FontWeight.normal,
      ),
      (sortBy == controller.orderBy)
          ? SvgPicture.asset("assets/icon/bx-check.svg")
          : const SizedBox()
    ]),
  );
}

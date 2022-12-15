import 'package:colorbox/app/modules/product/controllers/product_controller.dart';
import 'package:colorbox/app/modules/product/views/widget/footer_widget.dart';
import 'package:colorbox/app/widgets/custom_radio.dart';
import 'package:colorbox/app/widgets/custom_radio_color.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void selectVariantBottomSheet(String handle) async {
  ProductController controller =
      Get.put(ProductController(), tag: "selectVariant");
  controller.ukuran = "";
  await controller.getProductByHandle(handle);

  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.only(top: 24, right: 0, bottom: 16, left: 0),
      height: Get.height * .5,
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16)),
      ),
      child: GetBuilder(
          init: controller,
          tag: "selectVariant",
          builder: (_) {
            return Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(
                            Icons.close,
                            size: 18,
                          )),
                    ),
                    const CustomText(
                      text: "Pilih Variasi",
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ],
                ),
                (controller.product.options.length > 1)
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Pilih Warna : " + controller.warna,
                              fontSize: 14,
                              color: colorTextBlack,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: Get.width,
                              height: 25,
                              child: CustomRadioColor(
                                controller: controller,
                                listData: controller.product.options[1].values
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const SizedBox(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      CustomText(
                        text: "Pilih Ukuran : " + controller.ukuran,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 16),
                      if (controller.variant!.inventoryQuantity! <= 5 &&
                          controller.sizeTemp != null &&
                          controller.variant!.inventoryQuantity! != 0)
                        CustomText(
                          text: 'Tersisa ' +
                              controller.variant!.inventoryQuantity.toString() +
                              ' produk lagi !',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorSaleRed,
                        ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: Get.width,
                        height: 40,
                        child: CustomRadio(
                          listData:
                              controller.product.options[0].values.toList(),
                          controller: controller,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                FooterWidget(
                  handle,
                  tag: "selectVariant",
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

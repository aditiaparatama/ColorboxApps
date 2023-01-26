import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/product/controllers/product_controller.dart';
import 'package:colorbox/app/modules/product/views/widget/select_variant_bottomsheet.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:get/get.dart';

class FooterWidget extends GetView<ProductController> {
  final String handle;
  // ignore: annotate_overrides, overridden_fields
  final String? tag;
  final bool? openModal;
  const FooterWidget(this.handle, {Key? key, this.tag, this.openModal = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(ProductController()),
        tag: tag,
        builder: (_) {
          return Container(
            height: 80,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.05),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, -5), // changes position of shadow
                ),
              ],
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  fixedSize: Size(Get.width, 48),
                  backgroundColor: colorTextBlack,
                  disabledBackgroundColor: colorTextGrey),
              onPressed: (controller.ukuran == '' &&
                          controller.product.totalInventory! > 0) ||
                      controller.variant!.inventoryQuantity! > 0
                  ? () {
                      if (controller.ukuran == "" && openModal!) {
                        selectVariantBottomSheet(handle);
                        return;
                      }
                      Smartlook.instance.trackEvent('BTN_KERANJANG');
                      Get.find<CartController>().addCart(
                          controller.variant!.id!, context, controller.ukuran,
                          variants: controller.variant);
                    }
                  : null,
              child: (controller.ukuran == '' &&
                          controller.product.totalInventory! > 0) ||
                      controller.variant!.inventoryQuantity! > 0
                  ? const CustomText(
                      text: "Tambahkan ke keranjang",
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    )
                  : const CustomText(
                      text: "Produk Habis",
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
            ),
          );
        });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/product/controllers/product_controller.dart';
import 'package:colorbox/app/modules/product/views/widget/footer_widget.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_radio.dart';
import 'package:colorbox/app/widgets/custom_radio_color.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

void claimBottomSheet(String handle) {
  ProductController controller = Get.put(ProductController(), tag: "claim");

  Get.bottomSheet(
    SafeArea(
      child: Container(
        padding:
            const EdgeInsets.only(top: 27, right: 24, bottom: 16, left: 24),
        height: Get.height * .68,
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16)),
        ),
        child: GetBuilder<ProductController>(
            tag: "claim",
            initState: (_) async => await controller.getProductByHandle(handle),
            dispose: (_) {
              Get.delete<ProductController>(tag: "claim");
            },
            builder: (_) {
              return (controller.product.id == null)
                  ? loadingCircular()
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => Get.back(),
                                child:
                                    SvgPicture.asset("assets/icon/x-mark.svg"),
                              ),
                              const SizedBox(width: 8),
                              const CustomText(
                                text: "Klaim Free Gift",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              )
                            ],
                          ),
                          const SizedBox(height: 24),
                          //Foto
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(
                                height: 183,
                                width: 127,
                                child: CachedNetworkImage(
                                  imageUrl: controller.product.image[0],
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          Center(
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: CustomText(
                                        text: controller.product.title,
                                        fontSize: 14,
                                        textOverflow: TextOverflow.fade,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    GestureDetector(
                                      onTap: () => Get.toNamed(Routes.PRODUCT,
                                          arguments: {
                                            "product": controller.product,
                                            "idCollection":
                                                controller.product.idCollection,
                                            "handle": controller.product.handle
                                          }),
                                      child: Row(
                                        children: [
                                          const CustomText(
                                            text: "Lihat Detail Produk",
                                            fontSize: 14,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          SvgPicture.asset(
                                              "assets/icon/arrow-small-left.svg")
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          const SizedBox(height: 24),
                          //variant warna
                          (controller.product.options.length > 1)
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text:
                                            "Pilih Warna : " + controller.warna,
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
                                          listData: controller
                                              .product.options[1].values
                                              .toList(),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                          //variant size
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                                    controller.variant!.inventoryQuantity! !=
                                        0 &&
                                    controller.ukuran != '')
                                  CustomText(
                                    text: 'Tersisa ' +
                                        controller.variant!.inventoryQuantity
                                            .toString() +
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
                                    controller: controller,
                                    listData: controller
                                        .product.options[0].values
                                        .toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          FooterWidget(
                            handle,
                            tag: "claim",
                            openModal: false,
                            claim: true,
                          ),
                        ],
                      ),
                    );
            }),
      ),
    ),
    isDismissible: true,
    enableDrag: false,
    isScrollControlled: true,
  );
}

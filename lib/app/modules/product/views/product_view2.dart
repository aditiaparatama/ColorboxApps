import 'package:colorbox/app/modules/collections/views/widgets/search_collection.dart';
import 'package:colorbox/app/modules/product/views/widget/carousel_slider_product.dart';
import 'package:colorbox/app/modules/product/views/widget/share_social_media.dart';
import 'package:colorbox/app/modules/product/views/widget/similar_product_view.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_radio_color.dart';
import 'package:colorbox/app/widgets/appbar_custom.dart';
import 'package:colorbox/app/widgets/custom_radio.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class ProductView2 extends GetView<ProductController> {
  @override
  Widget build(BuildContext context) {
    controller.product = Get.arguments["product"];
    controller.variant = controller.product.variants[0];
    var collection = Get.arguments["idCollection"]
        .replaceAll('gid://shopify/Collection/', '');

    var calcu1 = int.parse(controller.variant!.price!.replaceAll(".00", "")) /
        int.parse(controller.variant!.compareAtPrice!.replaceAll(".00", ""));
    int calcu2 = (100 - calcu1 * 100).ceil();

    // ignore: avoid_print
    return GetBuilder<ProductController>(
        init: Get.put(ProductController()),
        builder: (control) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: AppBarCustom(
                widget: SearchCollection(),
              ),
            ),
            body: SizedBox(
              height: Get.height,
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                CarouselWithIndicatorProduct(
                                    controller: controller),
                                Positioned(
                                  bottom: 16,
                                  right: 16,
                                  child: InkWell(
                                    // onTap: () {
                                    //   var url = str1.toString();
                                    //   launchUrlString(url,
                                    //       mode: LaunchMode
                                    //           .externalNonBrowserApplication);
                                    // },
                                    // onTap: () => Get.toNamed(Routes.CART,
                                    //     arguments: "collection"),
                                    // onTap: () => openBrowserTab(),
                                    child: CircleAvatar(
                                      radius: 16.0,
                                      child: SvgPicture.asset(
                                          "assets/icon/bx-heart.svg"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  CustomText(
                                    text: controller.product.title!,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color.fromRGBO(33, 33, 33, 1),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      CustomText(
                                        text:
                                            "SKU : " + controller.variant!.sku!,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromRGBO(
                                            155, 155, 155, 1),
                                      ),
                                    ],
                                  ),
                                  (controller.product.variants[0]
                                                  .compareAtPrice ==
                                              "0" ||
                                          controller.product.variants[0]
                                                  .compareAtPrice ==
                                              controller
                                                  .product.variants[0].price)
                                      ? CustomText(
                                          text: "Rp " +
                                              formatter.format(int.parse(
                                                  controller.variant!.price!
                                                      .replaceAll(".00", ""))),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                        )
                                      : Column(
                                          children: [
                                            const SizedBox(height: 6),
                                            Row(
                                              children: [
                                                CustomText(
                                                  text: "Rp " +
                                                      formatter.format(
                                                          int.parse(controller
                                                              .variant!.price!
                                                              .replaceAll(
                                                                  ".00", ""))),
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w700,
                                                  color: const Color.fromRGBO(
                                                      187, 9, 21, 1),
                                                ),
                                                const SizedBox(width: 8),
                                                CustomText(
                                                  text: "Rp " +
                                                      formatter.format(
                                                          int.parse(controller
                                                              .variant!
                                                              .compareAtPrice!
                                                              .replaceAll(
                                                                  ".00", ""))) +
                                                      "  ",
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: colorTextGrey,
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                ),
                                                const SizedBox(width: 4),
                                                Container(
                                                  width: 30.0,
                                                  height: 15.0,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2),
                                                    color: colorSaleRed,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      calcu2.toString() + '%',
                                                      style: const TextStyle(
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white,
                                                        height: 1,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(color: colorDiver, height: 8),
                            const SizedBox(height: 16),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEEF2F6),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6)),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    CircleAvatar(
                                      radius: 16.0,
                                      child: SvgPicture.asset(
                                          "assets/icon/icon-free-shipping.svg"),
                                      backgroundColor: Colors.transparent,
                                    ),
                                    const SizedBox(width: 8),
                                    const CustomText(
                                      text:
                                          'Dapatkan potongan ongkir Rp 30.000 tanpa \n minimum pembelian untuk JABODETABEK',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(color: colorDiver, height: 8),
                            const SizedBox(height: 16),
                            (controller.product.options.length > 1)
                                ? Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text: controller
                                              .product.options[1].name!
                                              .replaceAll(
                                            controller.product.options[1].name!,
                                            "Pilih Warna : " +
                                                controller.product.options[1]
                                                    .values[0],
                                          ),
                                          fontSize: 14,
                                          color: colorTextBlack,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        const SizedBox(height: 16),
                                        SizedBox(
                                          width: Get.width,
                                          height: 25,
                                          child: CustomRadioColor(
                                            listData: controller
                                                .product.options[1].values
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 16),
                            Container(color: colorDiver, height: 8),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 16),
                                  CustomText(
                                    text: controller.product.options[0].name!
                                        .replaceAll(
                                            controller.product.options[0].name!,
                                            "Pilih Ukuran : " +
                                                controller.ukuran),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  const SizedBox(height: 16),
                                  if (controller.variant!.inventoryQuantity! <=
                                      5)
                                    CustomText(
                                      text: 'Tersisa ' +
                                          controller.variant!.inventoryQuantity
                                              .toString() +
                                          ' produk lagi !',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: colorSaleRed,
                                    ),
                                  SizedBox(
                                    width: Get.width,
                                    height: 40,
                                    child: CustomRadio(
                                      listData: controller
                                          .product.options[0].values
                                          .toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Container(color: colorDiver, height: 8),
                            const SizedBox(height: 16),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: GFAccordion(
                                title: 'Panduan Ukuran',
                                textStyle: const TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                margin: EdgeInsets.zero,
                                titlePadding: EdgeInsets.zero,
                                contentChild: Column(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          "https://cdn.shopify.com/s/files/1/0423/9120/8086/files/size-guide.png?v=1662956296",
                                      fit: BoxFit.fitWidth,
                                      width: Get.width,
                                    ),
                                  ],
                                ),
                                collapsedIcon: const Icon(Icons.add),
                                expandedIcon: const Icon(Icons.minimize),
                                collapsedTitleBackgroundColor: Colors.white,
                                expandedTitleBackgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                thickness: 1,
                                color: colorBorderGrey,
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: GFAccordion(
                                title: 'Detail Produk',
                                textStyle: const TextStyle(
                                    color: colorTextBlack,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                margin: EdgeInsets.zero,
                                titlePadding: EdgeInsets.zero,
                                contentChild:
                                    Html(data: controller.product.description),
                                collapsedIcon: const Icon(Icons.add),
                                expandedIcon: const Icon(Icons.minimize),
                                collapsedTitleBackgroundColor: Colors.white,
                                expandedTitleBackgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Divider(
                                thickness: 1,
                                color: colorBorderGrey,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(16, 24, 16, 16),
                              child: Row(children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      var url =
                                          'https://wa.me/628111717250?text=Halo Admin Colorbox, saya ingin bertanya tentang produk ini: https://colorbox.co.id/products/' +
                                              controller.product.handle!;
                                      await launchUrlString(url,
                                          mode: LaunchMode.externalApplication);
                                    },
                                    child: Container(
                                      height: 64,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6)),
                                        border:
                                            Border.all(color: colorBorderGrey),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icon/bx-hubungi-kami.svg"),
                                          const SizedBox(height: 10),
                                          const CustomText(
                                            text: 'Hubungi Kami',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: InkWell(
                                    onTap: () {
                                      bottomSheet(controller.product.handle!);
                                    },
                                    child: Container(
                                      height: 64,
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(6)),
                                        border:
                                            Border.all(color: colorBorderGrey),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icon/bx-berbagi.svg"),
                                          const SizedBox(height: 10),
                                          const CustomText(
                                            text: 'Berbagi',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                            const Divider(
                              height: 30,
                              thickness: 10,
                              color: Color.fromRGBO(249, 248, 248, 1),
                            ),
                            const SizedBox(),
                            const SizedBox(height: 5),
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              child: CustomText(
                                text: 'Produk Serupa \n',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              child: Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CollectionsProductView(collection),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    height: 80,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.05),
                          spreadRadius: 1,
                          blurRadius: 6,
                          offset:
                              const Offset(0, -5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(Get.width, 48),
                        primary: const Color.fromRGBO(33, 33, 33, 1),
                      ),
                      onPressed: controller.variant!.inventoryQuantity == 0
                          ? null
                          : () {
                              Get.find<CartController>().addCart(
                                  controller.variant!.id!,
                                  context,
                                  controller.ukuran);
                            },
                      child: controller.variant!.inventoryQuantity == 0
                          ? const CustomText(
                              text: "Produk Habis",
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            )
                          : const CustomText(
                              text: "Tambahkan ke keranjang",
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

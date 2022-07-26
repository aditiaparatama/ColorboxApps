import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/product/views/similar_product_view.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_radio.dart';
import 'package:colorbox/app/widgets/custom_radio_color.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import '../controllers/product_controller.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class ProductView2 extends GetView<ProductController> {
  var formatter = NumberFormat('###,000');
  var desk1 = 'testing';

  @override
  Widget build(BuildContext context) {
    controller.product = Get.arguments;
    controller.variant = controller.product.variants[0];

    return GetBuilder<ProductController>(
        init: Get.put(ProductController()),
        builder: (control) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Column(
              children: [
                const SizedBox(height: 40),

                Stack(
                  children: [
                    Container(
                      height: Get.height * .87,
                      padding: const EdgeInsets.only(
                          right: 20, left: 20, bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CarouselSlider.builder(
                              itemCount: controller.product.image.length,
                              options: CarouselOptions(
                                autoPlay: false,
                                aspectRatio: 0.75,
                                enlargeCenterPage: true,
                              ),
                              itemBuilder: (context, index, realIdx) {
                                return CachedNetworkImage(
                                  imageUrl: controller.product.image[index],
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      // borderRadius: const BorderRadius.all(
                                      //     Radius.circular(12)),
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
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: CustomText(
                                text: controller.product.title,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 10),
                            (controller.product.variants[0].compareAtPrice ==
                                    "0")
                                ? CustomText(
                                    text: "Rp " +
                                        formatter.format(int.parse(controller
                                            .variant!.price!
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
                                                    .variant!.compareAtPrice!
                                                    .replaceAll(".00", ""))) +
                                            "  ",
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: const Color.fromRGBO(
                                            155, 155, 155, 1),
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                      Container(
                                        width: 40.0,
                                        height: 30.0,
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
                                              fontSize: 14,
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
                                          .variant!.price!
                                          .replaceAll(".00", ""))),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: const Color.fromARGB(255, 229, 57, 53),
                                ),
                              ],
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 10),
                            //   child: CustomText(
                            //     text: "SKU: " + controller.variant!.sku!,
                            //     fontSize: sfontDefault,
                            //   ),
                            // ),
                            const Divider(
                              height: 30,
                              thickness: 10,
                              color: Color.fromRGBO(249, 248, 248, 1),
                            ),
                            const SizedBox(),
                            const SizedBox(height: 5),
                            (controller.product.options.length > 1)
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text:
                                            'controller.product.options[1].name'
                                                .replaceAll(
                                          'controller.product.options[1].name',
                                          "Pilih Warna : " +
                                              controller
                                                  .product.options[1].values[0],
                                        ),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        height: 30.0,
                                        width: 30.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(50),
                                          ),
                                        ),
                                        child: SizedBox(
                                          width: Get.width,
                                          height: 50,
                                          child: CustomRadioColor(
                                            listData: controller
                                                .product.options[1].values
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            const Divider(
                              height: 30,
                              thickness: 10,
                              color: Color.fromRGBO(249, 248, 248, 1),
                            ),
                            const SizedBox(),
                            const SizedBox(height: 5),
                            CustomText(
                              text: 'controller.product.options[0].name'
                                  .replaceAll(
                                      'controller.product.options[0].name',
                                      "Pilih Ukuran : " + controller.ukuran
                                      // controller.variant!.options[0].value!
                                      ),
                              // cont
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: Get.width,
                              height: 50,
                              child: CustomRadio(
                                listData: controller.product.options[0].values
                                    .toList(),
                              ),
                            ),
                            const Divider(
                              height: 30,
                              thickness: 10,
                              color: Color.fromRGBO(249, 248, 248, 1),
                            ),
                            const SizedBox(),
                            const SizedBox(height: 5),
                            const GFAccordion(
                              title: 'Panduan Ukuran',
                              margin: EdgeInsets.only(left: 0),
                              titlePadding: EdgeInsets.only(
                                left: 0,
                                top: 10,
                                bottom: 10,
                              ),
                              content:
                                  'GetFlutter is an open source library that comes with pre-build 1000+ UI components.',
                              collapsedIcon: Icon(Icons.add),
                              expandedIcon: Icon(Icons.minimize),
                              collapsedTitleBackgroundColor: Colors.white,
                              expandedTitleBackgroundColor: Colors.white,
                            ),
                            const Divider(thickness: 1),
                            GFAccordion(
                              title: 'Detail Produk',
                              margin: const EdgeInsets.only(left: 0),
                              titlePadding: const EdgeInsets.only(
                                left: 0,
                                top: 10,
                                bottom: 10,
                              ),
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                              content: controller.product.description!,
                              collapsedIcon: const Icon(Icons.add),
                              expandedIcon: const Icon(Icons.minimize),
                              collapsedTitleBackgroundColor: Colors.white,
                              expandedTitleBackgroundColor: Colors.white,
                            ),
                            const Divider(thickness: 1),
                            const Divider(),
                            const CustomText(
                              text: 'Produk Serupa \n',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CollectionsProductView(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    headerProduct(),
                  ],
                ),

                // ignore: avoid_unnecessary_containers
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(Get.width, 50),
                      primary: const Color.fromRGBO(33, 33, 33, 1),
                    ),
                    onPressed: controller.variant!.inventoryQuantity == 0
                        ? null
                        : () {
                            Get.find<CartController>()
                                .addCart(controller.variant!.id!);
                          },
                    child: controller.variant!.inventoryQuantity == 0
                        ? const CustomText(
                            text: "Produk Habis",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                        : const CustomText(
                            text: "Tambahkan ke keranjang",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                  ),
                )
              ],
            ),
          );
        });
  }

  Widget headerProduct() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => Get.back(),
            child: const Icon(Icons.arrow_back),
          ),
          InkWell(
            onTap: () => Get.toNamed(Routes.CART, arguments: "collection"),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Center(
                    child: SvgPicture.asset("assets/icon/bx-shopping-bag.svg"),
                  ),
                ),
                Get.find<CartController>().cart.lines!.isNotEmpty
                    ? Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(left: 15, bottom: 5),
                        child: Container(
                          width: 15,
                          height: 15,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.red),
                          child: CustomText(
                            text: Get.find<CartController>()
                                .cart
                                .lines!
                                .length
                                .toString(),
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}

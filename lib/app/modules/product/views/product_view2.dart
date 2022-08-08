import 'package:colorbox/app/modules/product/views/similar_product_view.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_radio_color.dart';
import 'package:colorbox/app/widgets/custom_radio.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class ProductView2 extends GetView<ProductController> {
  var formatter = NumberFormat('###,000');

  @override
  Widget build(BuildContext context) {
    controller.product = Get.arguments["product"];
    controller.variant = controller.product.variants[0];
    var collection = Get.arguments["idCollection"]
        .replaceAll('gid://shopify/Collection/', '');

    var calcu1 = int.parse(controller.variant!.price!.replaceAll(".00", "")) /
        int.parse(controller.variant!.compareAtPrice!.replaceAll(".00", ""));
    int calcu2 = (100 - calcu1 * 100).ceil();

    return GetBuilder<ProductController>(
        init: Get.put(ProductController()),
        builder: (control) {
          // print(controller.product.type);

          // print(control.userModel.id);
          // print(controller.product.id);
          // print(controller.product.variants[0].id);

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
                            Stack(
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
                                Positioned(
                                  bottom: 16,
                                  right: 10,
                                  child: InkWell(
                                    onTap: () => Get.toNamed(Routes.CART,
                                        arguments: "collection"),
                                    child: CircleAvatar(
                                      radius: 16.0,
                                      child: SvgPicture.asset(
                                          "assets/icon/bx-heart.svg"),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: CustomText(
                                text: controller.product.title,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(33, 33, 33, 1),
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  )
                                : Column(
                                    children: [
                                      Row(
                                        children: [
                                          CustomText(
                                            text: "Rp " +
                                                formatter.format(int.parse(
                                                    controller.variant!
                                                        .compareAtPrice!
                                                        .replaceAll(
                                                            ".00", ""))) +
                                                "  ",
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: const Color.fromRGBO(
                                                155, 155, 155, 1),
                                            decoration:
                                                TextDecoration.lineThrough,
                                          ),
                                          Container(
                                            width: 44.0,
                                            height: 28.0,
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
                                          Row(
                                            children: [
                                              CustomText(
                                                text: "Rp " +
                                                    formatter.format(int.parse(
                                                        controller
                                                            .variant!.price!
                                                            .replaceAll(
                                                                ".00", ""))),
                                                fontSize: 18,
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
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 10),
                            //   child: CustomText(
                            //     text: "SKU: " + controller.variant!.sku!,
                            //     fontSize: 14,
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
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        height: 32.0,
                                        width: 32.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 2.0,
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
                                      "Pilih Ukuran : " + controller.ukuran),
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 5),
                            SizedBox(
                              width: Get.width,
                              height: 40,
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
                            const SizedBox(height: 5),
                            GFAccordion(
                              title: 'Panduan Ukuran',
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              margin: const EdgeInsets.only(left: 0),
                              titlePadding: const EdgeInsets.only(
                                left: 0,
                                top: 10,
                                bottom: 10,
                              ),
                              contentChild: Column(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: controller.customUkuran(
                                        controller.product.type.toString()),
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
                            const Divider(thickness: 1),
                            GFAccordion(
                              title: 'Detail Produk',
                              textStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600),
                              margin: const EdgeInsets.only(left: 0),
                              titlePadding: const EdgeInsets.only(
                                left: 0,
                                top: 10,
                                bottom: 10,
                              ),
                              contentChild:
                                  Html(data: controller.product.description),
                              collapsedIcon: const Icon(Icons.add),
                              expandedIcon: const Icon(Icons.minimize),
                              collapsedTitleBackgroundColor: Colors.white,
                              expandedTitleBackgroundColor: Colors.white,
                            ),
                            const Divider(thickness: 1),
                            const Divider(),
                            const CustomText(
                              text: 'Produk Serupa \n',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  CollectionsProductView(collection),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    headerProduct(context),
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
                )
              ],
            ),
          );
        });
  }

  Widget headerProduct(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => Get.back(),
                    child: CircleAvatar(
                      radius: 16.0,
                      child: SvgPicture.asset("assets/icon/bx-arrow-left.svg"),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () =>
                        Get.toNamed(Routes.CART, arguments: "collection"),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: CircleAvatar(
                            radius: 16.0,
                            backgroundColor: Colors.white.withOpacity(0.5),
                            child: SvgPicture.asset(
                                "assets/icon/bx-share-alt.svg"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () =>
                        Get.toNamed(Routes.CART, arguments: "collection"),
                    // onTap: () => showDialog<String>(
                    //   context: context,
                    //   builder: (BuildContext context) => AlertDialog(
                    //     title: const Text('AlertDialog Title'),
                    //     content: Text("ini saya"),
                    //     actions: <Widget>[
                    //       TextButton(
                    //         onPressed: () => Navigator.pop(context, 'Cancel'),
                    //         child: const Text('Cancel'),
                    //       ),
                    //       TextButton(
                    //         onPressed: () => Navigator.pop(context, 'OK'),
                    //         child: const Text('OK'),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 0),
                          child: Center(
                            child: CircleAvatar(
                              radius: 16.0,
                              child: SvgPicture.asset(
                                  "assets/icon/bx-handbag.svg"),
                            ),
                          ),
                        ),
                        Get.find<CartController>().cart.lines!.isNotEmpty
                            ? Container(
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.only(left: 15, bottom: 5),
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
            ],
          ),
        ],
      ),
    );
  }
}

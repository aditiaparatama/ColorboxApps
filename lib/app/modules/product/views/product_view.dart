import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_radio.dart';
import 'package:colorbox/app/widgets/custom_radio_color.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class ProductView extends GetView<ProductController> {
  var formatter = NumberFormat('###,000');

  @override
  Widget build(BuildContext context) {
    // controller.product = Get.arguments;
    controller.variant = controller.product.variants[0];

    return GetBuilder<ProductController>(
        init: Get.put(ProductController()),
        builder: (control) {
          return Scaffold(
            appBar: AppBar(
              title: GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.CART);
                },
                child: CachedNetworkImage(
                  imageUrl:
                      "https://cdn.shopify.com/s/files/1/0584/9363/2674/files/new-Logo-bar.png?v=1654500845",
                  imageBuilder: (context, imageProvider) => Container(
                    width: Get.width - 150,
                    height: 25,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              actions: [
                InkWell(
                  onTap: () {},
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 10,
                    ),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Center(
                            child: SvgPicture.asset(
                                "assets/icon/bx-shopping-bag.svg"),
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
                ),
              ],
            ),
            body: Column(
              children: [
                Container(
                  height: Get.height * .82,
                  padding: const EdgeInsets.only(
                      top: 10, right: 20, left: 20, bottom: 10),
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
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(12)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
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
                            fontSize: sfontTitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        (controller.product.variants[0].compareAtPrice == null)
                            ? CustomText(
                                text: "Rp " +
                                    formatter.format(int.parse(controller
                                        .variant!.price!
                                        .replaceAll(".00", ""))),
                                fontWeight: FontWeight.bold,
                                fontSize: sfontPrice,
                              )
                            : Row(
                                children: [
                                  CustomText(
                                    text: "Rp " +
                                        formatter.format(int.parse(controller
                                            .variant!.compareAtPrice!
                                            .replaceAll(".00", ""))) +
                                        "  ",
                                    fontSize: sfontPromo,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  CustomText(
                                    text: "Rp " +
                                        formatter.format(int.parse(controller
                                            .variant!.price!
                                            .replaceAll(".00", ""))),
                                    fontSize: sfontPrice,
                                    fontWeight: FontWeight.bold,
                                    color:
                                        const Color.fromARGB(255, 229, 57, 53),
                                  ),
                                ],
                              ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: CustomText(
                            text: "SKU: " + controller.variant!.sku!,
                            fontSize: sfontDefault,
                          ),
                        ),
                        const Divider(),
                        CustomText(
                          text: controller.product.options[0].name,
                          fontSize: sfontDefault,
                        ),
                        SizedBox(
                          width: Get.width,
                          height: 50,
                          child: CustomRadio(
                            controller: controller,
                            listData:
                                controller.product.options[0].values.toList(),
                          ),
                        ),
                        const Divider(),
                        (controller.product.options.length > 1)
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: controller.product.options[1].name,
                                    fontSize: sfontDefault,
                                  ),
                                  SizedBox(
                                    width: Get.width,
                                    height: 50,
                                    child: CustomRadioColor(
                                      controller: controller,
                                      listData: controller
                                          .product.options[1].values
                                          .toList(),
                                    ),
                                  ),
                                ],
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ),
                // ignore: avoid_unnecessary_containers
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(Get.width, 50),
                      backgroundColor: colorTextBlack,
                    ),
                    onPressed: controller.variant!.inventoryQuantity == 0
                        ? null
                        : () {
                            // Get.find<CartController>()
                            //     .addCart(controller.variant!.id!);
                            // Get.offNamed(Routes.CART);
                          },
                    child: controller.variant!.inventoryQuantity == 0
                        ? const CustomText(
                            text: "Sold Out",
                            color: Colors.white,
                            fontSize: 16,
                          )
                        : const CustomText(
                            text: "Add Cart",
                            color: Colors.white,
                            fontSize: 16,
                          ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

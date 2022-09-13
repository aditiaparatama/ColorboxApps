import 'package:colorbox/app/modules/collections/views/widgets/search_collection.dart';
import 'package:colorbox/app/modules/product/views/similar_product_view.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_radio_color.dart';
import 'package:colorbox/app/widgets/appbar_custom.dart';
import 'package:colorbox/app/widgets/custom_radio.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:carousel_slider/carousel_slider.dart';
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

    // ignore: avoid_print
    return GetBuilder<ProductController>(
        init: Get.put(ProductController()),
        builder: (control) {
          // print(control.userModel.id!);
          // var str1 =
          //     'https://cloud.smartwishlist.webmarked.net/v6/savewishlist.php/?callback=jQuery22306539739531735338_1662970872627&product_id=' +
          //         controller
          //             .product.id!
          //             .replaceAll('gid://shopify/Product/', '')
          //             .toString() +
          //         '&variant_id=' +
          //         controller.product.variants[0].id!
          //             .replaceAll('gid://shopify/ProductVariant/', '')
          //             .toString() +
          //         '&wishlist_id=42391208086fi8qdjr1lot&customer_id=' +
          //         control.userModel.id!
          //             .replaceAll('gid://shopify/Customer/', '') +
          //         '&action=add&hostname=colorbox.co.id&variant=0&store_id=42391208086&_=1662969706415';

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(56),
              child: AppBarCustom(
                widget: SearchCollection(),
              ),
            ),
            body: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: Get.height * .78,
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
                                    height: 550,
                                    autoPlay: false,
                                    viewportFraction: 1,
                                    aspectRatio: 1 / 1,
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
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                              child: CustomText(
                                text: controller.product.title,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromRGBO(33, 33, 33, 1),
                              ),
                            ),
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
                                : Padding(
                                    padding: const EdgeInsets.only(left: 16),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            CustomText(
                                              text: "SKU : " +
                                                  controller.variant!.sku!,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: const Color.fromRGBO(
                                                  155, 155, 155, 1),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: CustomText(
                                                      text: "Rp " +
                                                          formatter.format(int
                                                              .parse(controller
                                                                  .variant!
                                                                  .price!
                                                                  .replaceAll(
                                                                      ".00",
                                                                      ""))),
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color:
                                                          const Color.fromRGBO(
                                                              187, 9, 21, 1),
                                                    ),
                                                  ),
                                                  CustomText(
                                                    text: "Rp " +
                                                        formatter.format(
                                                            int.parse(controller
                                                                .variant!
                                                                .compareAtPrice!
                                                                .replaceAll(
                                                                    ".00",
                                                                    ""))) +
                                                        "  ",
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w400,
                                                    color: const Color.fromRGBO(
                                                        155, 155, 155, 1),
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                  ),
                                                  Container(
                                                    width: 35.0,
                                                    height: 18.0,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2),
                                                      color:
                                                          const Color.fromRGBO(
                                                              187, 9, 21, 1),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        calcu2.toString() + '%',
                                                        style: const TextStyle(
                                                          fontSize: 12,
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
                                        ),
                                      ],
                                    ),
                                  ),
                            const Divider(height: 3),
                            const Divider(
                              height: 30,
                              thickness: 10,
                              color: Color.fromRGBO(249, 248, 248, 1),
                            ),
                            const SizedBox(height: 5),
                            // ignore: avoid_unnecessary_containers
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(238, 242, 246, 1),
                                  border: Border.all(
                                      width: 1.0,
                                      color: const Color.fromRGBO(
                                          238, 242, 246, 1)),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(6)),
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 16, 10, 16),
                                  child: Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 16.0,
                                        child: SvgPicture.asset(
                                            "assets/icon/icon-free-shipping.svg"),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.only(left: 10),
                                        child: CustomText(
                                          text:
                                              'Dapatkan potongan ongkir Rp 30.000 tanpa \n minimum pembelian untuk JABODETABEK',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const Divider(
                              height: 30,
                              thickness: 10,
                              color: Color.fromRGBO(249, 248, 248, 1),
                            ),
                            (controller.product.options.length > 1)
                                ? Padding(
                                    padding:
                                        const EdgeInsets.only(left: 16, top: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          text:
                                              'controller.product.options[1].name'
                                                  .replaceAll(
                                            'controller.product.options[1].name',
                                            "Pilih Warna : " +
                                                controller.product.options[1]
                                                    .values[0],
                                          ),
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        const SizedBox(height: 16),
                                        Container(
                                          height: 24.0,
                                          width: 24.0,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 2.0,
                                            ),
                                            borderRadius:
                                                const BorderRadius.all(
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
                                    ),
                                  )
                                : const SizedBox(),
                            const Divider(height: 3),
                            const Divider(
                              height: 30,
                              thickness: 10,
                              color: Color.fromRGBO(249, 248, 248, 1),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 4),
                              child: CustomText(
                                text: 'controller.product.options[0].name'
                                    .replaceAll(
                                        'controller.product.options[0].name',
                                        "Pilih Ukuran : " + controller.ukuran),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            const SizedBox(height: 16),
                            if (controller.variant!.inventoryQuantity! <= 5)
                              Padding(
                                padding: const EdgeInsets.only(left: 16),
                                child: CustomText(
                                  text: 'Tersisa ' +
                                      controller.variant!.inventoryQuantity
                                          .toString() +
                                      ' produk lagi !',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: const Color.fromRGBO(187, 9, 21, 1),
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.only(left: 16),
                              child: SizedBox(
                                width: Get.width,
                                height: 40,
                                child: CustomRadio(
                                  listData: controller.product.options[0].values
                                      .toList(),
                                ),
                              ),
                            ),
                            const Divider(height: 3),
                            const Divider(
                              height: 30,
                              thickness: 10,
                              color: Color.fromRGBO(249, 248, 248, 1),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: GFAccordion(
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
                            const Divider(thickness: 1),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: GFAccordion(
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
                            ),
                            const Divider(thickness: 1),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        const url =
                                            "https://wa.me/628111717250?text=Hello";
                                        await launchUrlString(url,
                                            mode:
                                                LaunchMode.externalApplication);
                                      },
                                      child: Container(
                                        height: 64,
                                        width: 180,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color.fromRGBO(
                                                    229, 232, 235, 1))),
                                        child: Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                                    ),
                                    InkWell(
                                      onTap: () {
                                        bottomSheet();
                                      },
                                      child: Container(
                                        height: 64,
                                        width: 156,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color.fromRGBO(
                                                    229, 232, 235, 1))),
                                        child: Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
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
                  ],
                ),

                // ignore: avoid_unnecessary_containers
                Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
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
                  ),
                )
              ],
            ),
          );
        });
  }

  void bottomSheet() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(defaultPadding),
        height: Get.height * .41,
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                    )),
                const CustomText(
                  text: "Berbagi :",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(Get.width, 20),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                // controller.fetchCollectionProduct(sortByContext, 1);
                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: 'Popularitas',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    child: InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 16.0,
                        child: SvgPicture.asset("assets/icon/bx-check.svg"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(Get.width, 10),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                // controller.fetchCollectionProduct(sortByContext, 2);
                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: 'Produk Terbaru',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    child: InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 16.0,
                        child: SvgPicture.asset("assets/icon/bx-check.svg"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(Get.width, 10),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                // controller.fetchCollectionProduct(sortByContext, 3);
                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: 'Harga Tinggi ke Rendah',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    child: InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 16.0,
                        child: SvgPicture.asset("assets/icon/bx-check.svg"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(Get.width, 10),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                // controller.fetchCollectionProduct(sortByContext, 4);
                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: 'Harga Rendah ke Tinggi',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  SizedBox(
                    child: InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 16.0,
                        child: SvgPicture.asset("assets/icon/bx-check.svg"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: false,
    );
  }
}

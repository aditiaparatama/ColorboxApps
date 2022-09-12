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
    // ignore: avoid_print
    print(controller.variant!.inventoryQuantity.toString());

    return GetBuilder<ProductController>(
        init: Get.put(ProductController()),
        builder: (control) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(56),
              child: AppBar(
                title: const SearchCollection(),
                centerTitle: false,
                elevation: 3,
                leadingWidth: 36,
                leading: IconButton(
                    padding: const EdgeInsets.all(16),
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back)),
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
                                    Container(
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
                                    Container(
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
}

class SearchCollection extends StatelessWidget {
  const SearchCollection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 36,
          width: 250,
          child: TextFormField(
            onTap: () => Get.toNamed(Routes.SEARCH),
            cursorColor: const Color.fromRGBO(155, 155, 155, 1),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(250, 250, 250, 1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  width: 1.0,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
              disabledBorder: InputBorder.none,
              labelStyle: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(155, 155, 155, 1)),
              hintText: "Cari produk disini",
              hintStyle:
                  const TextStyle(fontSize: 12, color: Color(0xFF9B9B9B)),
              filled: true,
              fillColor: const Color.fromRGBO(250, 250, 250, 1),
              suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.SEARCH),
                  child: SvgPicture.asset("assets/icon/bx-search1.svg"),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          child: InkWell(
            onTap: () => showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('AlertDialog Title'),
                content: const Text("ini saya"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 16.0,
                  backgroundColor: Colors.white.withOpacity(0.5),
                  child: SvgPicture.asset("assets/icon/bx-share-alt.svg"),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          child: InkWell(
            onTap: () => Get.toNamed(Routes.CART, arguments: "collection"),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 16.0,
                      child: SvgPicture.asset("assets/icon/bx-handbag.svg"),
                    ),
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
        ),
      ],
    );
  }
}

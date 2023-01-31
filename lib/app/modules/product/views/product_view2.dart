import 'package:colorbox/app/modules/discount/controllers/discount_controller.dart';
import 'package:colorbox/app/modules/product/views/widget/carousel_slider_product.dart';
import 'package:colorbox/app/modules/product/views/widget/footer_widget.dart';
import 'package:colorbox/app/modules/product/views/widget/section_cs.dart';
import 'package:colorbox/app/modules/product/views/widget/similar_product_view.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/appbar_new.dart';
import 'package:colorbox/app/widgets/bottomsheet_widget.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_radio_color.dart';
import 'package:colorbox/app/widgets/custom_radio.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/helper/item_creator_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:getwidget/getwidget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;

import '../controllers/product_controller.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class ProductView2 extends StatelessWidget {
  // var tempAnnouncement = [];
  final ProductController controller = Get.put(ProductController());
  final DiscountController discountController = Get.put(DiscountController());

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  final List<String> _idCollection = [Get.arguments["idCollection"]];
  dynamic collection =
      Get.arguments["idCollection"].replaceAll('gid://shopify/Collection/', '');
  final String _handle = Get.arguments["handle"];

  Future<void> initializeSettings() async {
    await controller.getProductByHandle(_handle);
    await callWishlist(controller);

    //Simulate other services for 3 seconds
    await Future.delayed(const Duration(milliseconds: 100));
  }

  Future<void> callWishlist(ProductController control) async {
    await control.wishlistController.fetchWishlist();
    if (control.wishlistController.wishlist.items != null &&
        control.wishlistController.wishlist.items.isNotEmpty) {
      control.existWishlist = control.wishlistController.wishlist.items
          .indexWhere((e) =>
              e['product_id'] ==
              control.product.id!.replaceAll("gid://shopify/Product/", ""));

      control.wishlistAdded = (control.existWishlist >= 0) ? true : false;
    }

    await discountController.groupingDiscountAutomatic(_idCollection);
  }

  @override
  Widget build(BuildContext context) {
    Smartlook.instance.trackEvent('PDP');
    // ignore: avoid_print
    return FutureBuilder(
        future: initializeSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.white, body: loadingCircular());
          }
          analytics.logViewItem(
            currency: "IDR",
            value: double.parse(controller.product.variants[0].price!),
            items: [itemCreator(controller.product)],
          );
          return GetBuilder<ProductController>(
              init: Get.put(ProductController()),
              builder: (control) {
                var compareAtPrice = control.product.variants[0].compareAtPrice;
                var price = control.product.variants[0].price;

                return Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  appBar: const PreferredSize(
                    preferredSize: Size.fromHeight(56),
                    child: AppBarNew(title: ""),
                  ),
                  body: SafeArea(
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
                                          controller: control),
                                      Positioned(
                                        bottom: 16,
                                        right: 16,
                                        child: InkWell(
                                          onTap: () async {
                                            if (controller.userModel.email ==
                                                null) {
                                              await modalAlert(
                                                  context,
                                                  "Masuk Akun",
                                                  const CustomText(
                                                    text:
                                                        "Masuk akun untuk menambahkan produk ke wishlist",
                                                    fontSize: 14,
                                                    textAlign: TextAlign.center,
                                                    textOverflow:
                                                        TextOverflow.fade,
                                                  ),
                                                  [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 12),
                                                      child: CustomButton(
                                                        backgroundColor:
                                                            colorTextBlack,
                                                        color: Colors.white,
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          Get.toNamed(
                                                              Routes.PROFILE);
                                                        },
                                                        //return false when click on "No"
                                                        text: 'Masuk Akun',
                                                        fontSize: 14,
                                                        height: 48,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 12),
                                                      child: CustomButton(
                                                        backgroundColor:
                                                            Colors.white,
                                                        color: colorNeutral100,

                                                        onPressed: () =>
                                                            Navigator.of(
                                                                    context)
                                                                .pop(false),
                                                        //return false when click on "No"
                                                        text: 'Kembali',
                                                        fontSize: 14,
                                                        height: 48,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 24)
                                                  ]);
                                              return;
                                            }
                                            controller.wishlistAdded =
                                                !controller.wishlistAdded;
                                            controller.update();
                                            await controller.wishlistController
                                                .actionWishlist(
                                                    controller.product.id!,
                                                    controller.variant!.id!,
                                                    action: (controller
                                                                .existWishlist >=
                                                            0)
                                                        ? "remove"
                                                        : "add");

                                            await callWishlist(control);
                                            // controller.update();
                                          },
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.white.withOpacity(0.5),
                                            radius: 16.0,
                                            child: SvgPicture.asset((controller
                                                    .wishlistAdded)
                                                ? "assets/icon/Heart.svg"
                                                : "assets/icon/bx-heart.svg"),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 16),
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Flexible(
                                              flex: 3,
                                              child: CustomText(
                                                text: control.product.title!,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: colorNeutral100,
                                                textOverflow: TextOverflow.fade,
                                              ),
                                            ),
                                            Flexible(
                                              flex: 1,
                                              child: CustomText(
                                                text: "Rp " +
                                                    formatter.format(int.parse(
                                                        price!.replaceAll(
                                                            ".00", ""))),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                                color: (compareAtPrice == "0" ||
                                                        compareAtPrice == price)
                                                    ? colorNeutral100
                                                    : colorDangerMain,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            CustomText(
                                              text: (control.variant!.sku ??
                                                      "") +
                                                  " | " +
                                                  (control.variant!.barcode ??
                                                      ""),
                                              fontSize: 12,
                                              fontWeight: FontWeight.w400,
                                              color: colorNeutral70,
                                            ),
                                            if (compareAtPrice != "0" &&
                                                compareAtPrice != "")
                                              CustomText(
                                                text: "Rp " +
                                                    formatter.format(int.parse(
                                                        compareAtPrice!
                                                            .replaceAll(
                                                                ".00", ""))),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: colorNeutral70,
                                                decoration:
                                                    TextDecoration.lineThrough,
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(color: colorDiver, height: 4),
                                  if (discountController
                                      .listingDiscountAutomatic.isNotEmpty) ...[
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      child: const CustomText(
                                        text: "Promo",
                                        fontWeight: FontWeight.w500,
                                        color: colorNeutral100,
                                      ),
                                    ),
                                    Container(
                                      constraints:
                                          const BoxConstraints(maxHeight: 52),
                                      child: ListView.separated(
                                          shrinkWrap: true,
                                          separatorBuilder: (context, index) =>
                                              const SizedBox(width: 16),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: discountController
                                              .listingDiscountAutomatic.length,
                                          itemBuilder: (_, i) {
                                            // String desc = discountController
                                            //     .listingDiscountAutomatic[i]
                                            //     .deskripsi
                                            //     .replaceAll(" •", ",");
                                            Color colorBorder = (discountController
                                                        .listingDiscountAutomatic[
                                                            i]
                                                        .type ==
                                                    "code")
                                                ? const Color(0xFFFFADD7)
                                                : const Color(0xFFB896E8);
                                            return GestureDetector(
                                              onTap: () {
                                                bottomSheetWidget(
                                                    "Detail Promo",
                                                    discountController
                                                        .listingDiscountAutomatic[
                                                            i]
                                                        .title,
                                                    discountController
                                                        .listingDiscountAutomatic[
                                                            i]
                                                        .deskripsi);
                                              },
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  (p.extension(discountController
                                                              .listingDiscountAutomatic[
                                                                  i]
                                                              .icon!
                                                              .split("?")[0]) ==
                                                          ".svg")
                                                      ? SvgPicture.network(
                                                          discountController
                                                              .listingDiscountAutomatic[
                                                                  i]
                                                              .icon!)
                                                      : CachedNetworkImage(
                                                          imageUrl:
                                                              discountController
                                                                  .listingDiscountAutomatic[
                                                                      i]
                                                                  .icon!),
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                8, 8, 12, 8),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color:
                                                                    colorBorder),
                                                            borderRadius: const BorderRadius
                                                                    .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        8),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        8))),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            CustomText(
                                                              text: discountController
                                                                      .listingDiscountAutomatic[
                                                                          i]
                                                                      .title ??
                                                                  "",
                                                              color:
                                                                  colorNeutral100,
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                              textOverflow:
                                                                  TextOverflow
                                                                      .fade,
                                                            ),
                                                            const SizedBox(
                                                                height: 4),
                                                            const CustomText(
                                                              text:
                                                                  "Lihat Detail",
                                                              fontSize: 12,
                                                              color:
                                                                  colorNeutral90,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned(
                                                          top: 12,
                                                          right: -4,
                                                          child: customCircle(
                                                              colorBorder)),
                                                      Positioned(
                                                          bottom: 12,
                                                          right: -4,
                                                          child: customCircle(
                                                              colorBorder))
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                    const SizedBox(height: 16),
                                    Container(color: colorDiver, height: 4),
                                  ],
                                  const SizedBox(height: 16),
                                  (control.product.options.length > 1)
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CustomText(
                                                text: "Pilih Warna : " +
                                                    controller.warna,
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
                                                  listData: control
                                                      .product.options[1].values
                                                      .toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox(),
                                  const SizedBox(height: 16),
                                  Container(color: colorDiver, height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 16),
                                        CustomText(
                                          text: "Pilih Ukuran : " +
                                              control.ukuran,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        const SizedBox(height: 16),
                                        if (control.variant!.inventoryQuantity! <= 5 &&
                                            control.sizeTemp != null &&
                                            control.variant!
                                                    .inventoryQuantity! !=
                                                0 &&
                                            control.ukuran != '')
                                          CustomText(
                                            text: 'Tersisa ' +
                                                control
                                                    .variant!.inventoryQuantity
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
                                            listData: control
                                                .product.options[0].values
                                                .toList(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Container(color: colorDiver, height: 4),
                                  const SizedBox(height: 16),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
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
                                                "https://widget.delamibrands.com/colorbox/mobile/Size-Guidline.png",
                                            fit: BoxFit.fitWidth,
                                            width: Get.width,
                                          ),
                                        ],
                                      ),
                                      collapsedIcon: const CustomText(
                                        text: "+",
                                        fontSize: 28,
                                      ),
                                      expandedIcon: const CustomText(
                                        text: "-",
                                        fontSize: 28,
                                      ),
                                      collapsedTitleBackgroundColor:
                                          Colors.white,
                                      expandedTitleBackgroundColor:
                                          Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Divider(
                                      thickness: 1,
                                      color: colorBorderGrey,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16),
                                    child: GFAccordion(
                                      title: 'Detail Produk',
                                      textStyle: const TextStyle(
                                          color: colorTextBlack,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600),
                                      margin: EdgeInsets.zero,
                                      titlePadding: EdgeInsets.zero,
                                      contentChild: Html(
                                          data: control.product.description),
                                      collapsedIcon: const CustomText(
                                        text: "+",
                                        fontSize: 28,
                                      ),
                                      expandedIcon: const CustomText(
                                        text: "-",
                                        fontSize: 28,
                                      ),
                                      collapsedTitleBackgroundColor:
                                          Colors.white,
                                      expandedTitleBackgroundColor:
                                          Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16),
                                    child: Divider(
                                      thickness: 1,
                                      color: colorBorderGrey,
                                    ),
                                  ),
                                  //Customer Service
                                  const SectionCS(),
                                  Container(color: colorDiver, height: 4),
                                  const SizedBox(),
                                  const SizedBox(height: 5),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 20),
                                    child: CustomText(
                                      text: 'Produk Serupa \n',
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          CollectionsProductView(collection),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FooterWidget(_handle),
                      ],
                    ),
                  ),
                );
              });
        });
  }

  Container customCircle(Color colorBorder) {
    return Container(
      height: 8,
      width: 8,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 1,
            color: colorBorder,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
    );
  }

  Widget bagWidget() {
    return GetBuilder<CartController>(
        init: Get.put(CartController()),
        builder: (cartController) {
          return Center(
            child: InkWell(
              onTap: () => Get.toNamed(Routes.CART),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                    ),
                    child: SvgPicture.asset(
                      "assets/icon/shopping-bag.svg",
                    ),
                  ),
                  cartController.cart.lines!.isNotEmpty
                      ? Positioned(
                          top: 0,
                          right: 10,
                          child: Container(
                            width: 15,
                            height: 15,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.red),
                            child: CustomText(
                              text:
                                  cartController.cart.totalQuantity!.toString(),
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          );
        });
  }
}

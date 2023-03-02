import 'dart:math';
import 'package:colorbox/app/modules/cart/models/cart_model.dart';
import 'package:colorbox/app/modules/cart/views/widget/voucher_widget.dart';
import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/modules/control/menu_model.dart';
import 'package:colorbox/app/modules/control/sub_menu_model.dart';
import 'package:colorbox/app/modules/home/views/widgets/announcement_home.dart';
import 'package:colorbox/app/modules/home/views/widgets/item_card_ending.dart';
import 'package:colorbox/app/modules/profile/views/address/address_form.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/empty_page.dart';
import 'package:colorbox/app/widgets/item_card_bxgy.dart';
import 'package:colorbox/app/widgets/item_card_cart.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:colorbox/app/modules/cart/views/widget/item_cart_widget.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import '../controllers/cart_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class CartView extends GetView<CartController> {
  final CollectionsController collectionsController =
      Get.put(CollectionsController(), tag: "cart");
  final CollectionsController collectionsBxGyController =
      Get.put(CollectionsController(), tag: "BxGy");
  int index = 0;
  int indexDiscount = 0, indexBxGy = -1;
  int indexCollection = 0;
  int selisihOrder = 0;
  double totalPotongan = 0, selisihBuyXgetY = 0;
  bool freeGift = false, appliedFreeGift = false;

  Future<void> initializeSettings() async {
    totalPotongan = 0;
    selisihBuyXgetY = 0;
    freeGift = false;
    await controller.getCart2();
    // await controller.discountController.getDiscountAutomatic();
    if (controller.discountController.discountAutomatic.isNotEmpty) {
      var indexRandom = Random();
      // var temp = controller.discountController.discountAutomatic
      //     .indexWhere((element) => element.typename == "DiscountAutomaticBxgy");
      indexBxGy = controller.discountController.discountAutomatic
          .indexWhere((element) => element.typename == "DiscountAutomaticBxgy");
      indexDiscount = (controller
              .discountController.discountAutomatic.isNotEmpty)
          ? indexRandom
              .nextInt(controller.discountController.discountAutomatic.length)
          : 0;

      int looping = 0;
      while (controller.discountController.discountAutomatic.isNotEmpty &&
          controller.discountController.discountAutomatic.length > 1 &&
          indexDiscount == indexBxGy) {
        if (looping > 10) break;
        indexDiscount = indexRandom
            .nextInt(controller.discountController.discountAutomatic.length);
        looping += 1;
      }

      indexCollection = (controller.discountController
              .discountAutomatic[indexDiscount].collections!.isNotEmpty)
          ? indexRandom.nextInt(controller.discountController
              .discountAutomatic[indexDiscount].collections!.length)
          : 0;

      await collectionsController.fetchCollectionProduct(
          int.parse(controller
              .discountController
              .discountAutomatic[indexDiscount]
              .collections![indexCollection]
              .id!
              .replaceAll('gid://shopify/Collection/', '')),
          2);

      if (indexBxGy >= 0) {
        await collectionsBxGyController.fetchCollectionProduct(
            int.parse(controller.discountController.discountAutomatic[indexBxGy]
                .collections![0].id!
                .replaceAll('gid://shopify/Collection/', '')),
            2);
      }
      for (final x in controller.cart.lines ?? []) {
        int i = controller.discountController.discountAutomatic[indexBxGy]
            .customerBuys!.collections!
            .indexWhere((e) => x.merchandise!.idCollection!.contains(e.id));
        if (i >= 0) {
          selisihBuyXgetY = selisihBuyXgetY +
              (double.parse(x.merchandise!.price!) * x.quantity!.toDouble());
        }

        if (double.parse(x.merchandise!.price!.replaceAll(".00", "")).ceil() -
                double.parse(x.discountAllocations!.amount ?? "0.0").ceil() ==
            0) {
          freeGift = true;
          break;
        }
      }
    }

    //Simulate other services for 3 seconds
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    Smartlook.instance.trackEvent('CART');
    return FutureBuilder(
        future: initializeSettings(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: Colors.white, body: loadingCircular());
          }
          return GetBuilder<CartController>(
              init: Get.put(CartController()),
              builder: (c) {
                selisihBuyXgetY = 0;
                selisihOrder = (controller.discountController
                        .discountAutomaticTotalOrder.isNotEmpty)
                    ? int.parse(controller
                            .discountController
                            .discountAutomaticTotalOrder[0]
                            .minimumRequirement!
                            .greaterThanOrEqualToSubtotal!
                            .replaceAll('.0', '')) -
                        int.parse(controller.cart.estimatedCost!.subtotalAmount!
                            .replaceAll(".0", ""))
                    : 0;
                if (controller.listHabis.isNotEmpty) {
                  for (final x in controller.listHabis) {
                    selisihOrder = selisihOrder +
                        int.parse(x.merchandise!.price!.replaceAll(".00", ""));
                  }
                }

                for (final x in controller.cart.lines ?? []) {
                  if (indexBxGy >= 0) {
                    int i = controller.discountController
                        .discountAutomatic[indexBxGy].customerBuys!.collections!
                        .indexWhere(
                            (e) => x.merchandise!.idCollection!.contains(e.id));
                    if (i >= 0) {
                      selisihBuyXgetY = selisihBuyXgetY +
                          (double.parse(x.merchandise!.price!) *
                              x.quantity!.toDouble());
                    }

                    if (double.parse(
                                    x.merchandise!.price!.replaceAll(".00", ""))
                                .ceil() -
                            double.parse(x.discountAllocations!.amount ?? "0.0")
                                .ceil() ==
                        0) {
                      freeGift = true;
                      break;
                    } else {
                      freeGift = false;
                    }
                  }
                }
                return Scaffold(
                    resizeToAvoidBottomInset: false,
                    appBar: const PreferredSize(
                        preferredSize: Size.fromHeight(56),
                        child: AppBarDefault(
                          text: "Keranjang",
                        )),
                    backgroundColor: Colors.white,
                    // bottomSheet: bottomCart(),
                    body: SafeArea(
                        child: Stack(
                      children: [
                        Column(children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (controller.homeController.maintenance)
                                    AnnouncementHome(
                                      controller: controller.homeController,
                                      pTop: 24,
                                      pBottom: 0,
                                    ),
                                  if (controller
                                          .discountController
                                          .discountAutomaticTotalOrder
                                          .isNotEmpty &&
                                      controller.cart.lines!.isNotEmpty &&
                                      controller.discountController
                                          .discountAutomatic.isEmpty &&
                                      (controller.cart.discountCodes == null ||
                                          controller
                                              .cart.discountCodes!.isEmpty ||
                                          controller.cart.discountCodes![0]
                                                  .code ==
                                              ""))
                                    Container(
                                      width: Get.width,
                                      color: (selisihOrder > 0)
                                          ? colorBoxInfo
                                          : colorBoxSuccess,
                                      padding: const EdgeInsets.all(16),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset((selisihOrder > 0)
                                              ? "assets/icon/bag-illustration.svg"
                                              : "assets/icon/popper.svg"),
                                          const SizedBox(width: 8),
                                          Flexible(
                                            child: (selisihOrder > 0)
                                                ? GestureDetector(
                                                    onTap: () => Get.until(
                                                        (route) =>
                                                            Get.currentRoute ==
                                                            "/controlv2"),
                                                    child: RichText(
                                                      text: TextSpan(
                                                          text:
                                                              "Tambah Rp ${formatter.format(selisihOrder)} untuk mendapatkan potongan Rp ${formatter.format(int.parse(controller.discountController.discountAutomaticTotalOrder[0].customerGets!.value!.amount!))}. ",
                                                          style: const TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  colorTextBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                          children: const [
                                                            TextSpan(
                                                                text:
                                                                    "Tambah produk",
                                                                style: TextStyle(
                                                                    color:
                                                                        colorTextBlack,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline))
                                                          ]),
                                                    ),
                                                  )
                                                : CustomText(
                                                    text:
                                                        "Yaay kamu mendapatkan potongan Rp ${formatter.format(int.parse(controller.discountController.discountAutomaticTotalOrder[0].customerGets!.value!.amount!))} karena telah memenuhi minimum order",
                                                    fontSize: 12,
                                                    color: colorTextSuccess,
                                                    textOverflow:
                                                        TextOverflow.fade,
                                                  ),
                                          )
                                        ],
                                      ),
                                    ),
                                  SizedBox(
                                    child: (c.cart.lines!.isEmpty)
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 40),
                                            child: EmptyPage(
                                              image: Image.asset(
                                                "assets/icon/BAG.gif",
                                                height: 180,
                                              ),
                                              textHeader:
                                                  "Keranjang Kamu Kosong",
                                              textContent:
                                                  "Ayo segera belanja dan tambahkan produk kedalam keranjang",
                                            ),
                                          )
                                        : ListView.separated(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            separatorBuilder:
                                                (context, index) =>
                                                    const Divider(
                                                      color: colorDiver,
                                                      thickness: 1,
                                                    ),
                                            itemCount: c.cart.lines!.length,
                                            itemBuilder: (_, index) {
                                              int temp = -1;
                                              Menu? collectionPromo =
                                                  Menu.empty();
                                              for (final x in c
                                                  .cart
                                                  .lines![index]
                                                  .merchandise!
                                                  .idCollection!) {
                                                for (final y in controller
                                                    .discountController
                                                    .discountAutomatic) {
                                                  temp = y.collections!
                                                      .indexWhere(
                                                          (e) => e.id == x);
                                                  if (temp >= 0) {
                                                    collectionPromo = Menu(
                                                        subMenu: List<
                                                            SubMenu>.empty(),
                                                        title: y.title,
                                                        subjectID: int.parse(y
                                                            .collections![temp]
                                                            .id!
                                                            .replaceAll(
                                                                "gid://shopify/Collection/",
                                                                "")));

                                                    break;
                                                  }
                                                }
                                                if (temp >= 0) break;
                                              }

                                              return ItemCartWidget(
                                                formatter: formatter,
                                                controller: controller,
                                                index: index,
                                                collectionPromo:
                                                    collectionPromo,
                                              );
                                            }),
                                  ),
                                  if (controller.discountController
                                          .discountAutomatic.isNotEmpty &&
                                      indexBxGy >= 0 &&
                                      selisihBuyXgetY >=
                                          double.parse(controller
                                                  .discountController
                                                  .discountAutomatic[indexBxGy]
                                                  .minimumRequirement!
                                                  .greaterThanOrEqualToSubtotal ??
                                              "0") &&
                                      !freeGift)
                                    GetBuilder<CollectionsController>(
                                        init: collectionsBxGyController,
                                        tag: "BxGy",
                                        builder: (_) {
                                          return Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                color: colorDiver,
                                                height: 8,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 16,
                                                    top: 24,
                                                    bottom: 16),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                            "assets/icon/Gift.svg"),
                                                        const SizedBox(
                                                            width: 4),
                                                        CustomText(
                                                          text: controller
                                                                  .discountController
                                                                  .discountAutomatic[
                                                                      indexBxGy]
                                                                  .title ??
                                                              "Free Gift",
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 8),
                                                    CustomText(
                                                      text:
                                                          "Selamat ! Setiap pembelanjaan min. Rp ${formatter.format(int.parse(controller.discountController.discountAutomatic[indexBxGy].minimumRequirement!.greaterThanOrEqualToSubtotal!.replaceAll(".0", "")))} berhak mendapatkan hadiah (Pilih produk dibawah) :",
                                                      fontSize: 12,
                                                      textOverflow:
                                                          TextOverflow.fade,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                height: 250,
                                                padding: const EdgeInsets.only(
                                                    left: 16),
                                                child: (collectionsBxGyController
                                                        .collection
                                                        .products
                                                        .isEmpty)
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : GridView.builder(
                                                        shrinkWrap: true,
                                                        itemCount:
                                                            collectionsBxGyController
                                                                .collection
                                                                .products
                                                                .length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 1,
                                                          mainAxisSpacing: 12,
                                                          crossAxisSpacing: 12,
                                                          childAspectRatio:
                                                              4.18 / 2,
                                                        ),
                                                        itemBuilder: (_, i) {
                                                          var calcu1 = int.parse(
                                                                  collectionsBxGyController
                                                                      .collection
                                                                      .products[
                                                                          i]
                                                                      .variants[
                                                                          0]
                                                                      .price!
                                                                      .replaceAll(
                                                                          ".00",
                                                                          "")) /
                                                              int.parse(collectionsBxGyController
                                                                  .collection
                                                                  .products[i]
                                                                  .variants[0]
                                                                  .compareAtPrice!
                                                                  .replaceAll(
                                                                      ".00",
                                                                      ""));
                                                          return (i ==
                                                                      (collectionsBxGyController
                                                                              .collection
                                                                              .products
                                                                              .length -
                                                                          1) &&
                                                                  i != 0)
                                                              ? ItemCardEnding(
                                                                  calcu1:
                                                                      calcu1,
                                                                  collection:
                                                                      collectionsBxGyController
                                                                          .collection,
                                                                  homeCollection: {
                                                                    "title": collectionsBxGyController
                                                                        .collection
                                                                        .title,
                                                                    "subjectid": int.parse(collectionsBxGyController
                                                                        .collection
                                                                        .id!
                                                                        .replaceAll(
                                                                            "gid://shopify/Collection/",
                                                                            ""))
                                                                  },
                                                                  i: i,
                                                                  isCart: true,
                                                                )
                                                              : ItemCardBxGy(
                                                                  calcu1:
                                                                      calcu1,
                                                                  collection:
                                                                      collectionsBxGyController
                                                                          .collection,
                                                                  i: i,
                                                                );
                                                        }),
                                              ),
                                              const SizedBox(height: 40)
                                            ],
                                          );
                                        }),
                                  if (controller.discountController
                                          .discountAutomatic.isNotEmpty &&
                                      controller
                                              .discountController
                                              .discountAutomatic[indexDiscount]
                                              .typename !=
                                          "DiscountAutomaticBxgy")
                                    GetBuilder<CollectionsController>(
                                        init: Get.put(CollectionsController(),
                                            tag: "cart"),
                                        tag: "cart",
                                        builder: (_) {
                                          return Column(
                                            children: [
                                              Container(
                                                color: colorDiver,
                                                height: 8,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 24, bottom: 16),
                                                child: CustomText(
                                                  text: controller
                                                          .discountController
                                                          .discountAutomatic[
                                                              indexDiscount]
                                                          .title ??
                                                      "",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 16),
                                                height: 250,
                                                child: (collectionsController
                                                        .collection
                                                        .products
                                                        .isEmpty)
                                                    ? const Center(
                                                        child:
                                                            CircularProgressIndicator(),
                                                      )
                                                    : GridView.builder(
                                                        itemCount:
                                                            collectionsController
                                                                .collection
                                                                .products
                                                                .length,
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        gridDelegate:
                                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                                          crossAxisCount: 1,
                                                          mainAxisSpacing: 12,
                                                          crossAxisSpacing: 12,
                                                          childAspectRatio:
                                                              5 / 2.61,
                                                        ),
                                                        itemBuilder: (_, i) {
                                                          var calcu1 = int.parse(
                                                                  collectionsController
                                                                      .collection
                                                                      .products[
                                                                          i]
                                                                      .variants[
                                                                          0]
                                                                      .price!
                                                                      .replaceAll(
                                                                          ".00",
                                                                          "")) /
                                                              int.parse(collectionsController
                                                                  .collection
                                                                  .products[i]
                                                                  .variants[0]
                                                                  .compareAtPrice!
                                                                  .replaceAll(
                                                                      ".00",
                                                                      ""));
                                                          return (i ==
                                                                      (collectionsController
                                                                              .collection
                                                                              .products
                                                                              .length -
                                                                          1) &&
                                                                  i != 0)
                                                              ? ItemCardEnding(
                                                                  calcu1:
                                                                      calcu1,
                                                                  collection:
                                                                      collectionsController
                                                                          .collection,
                                                                  homeCollection: {
                                                                    "title": collectionsController
                                                                        .collection
                                                                        .title,
                                                                    "subjectid": int.parse(collectionsController
                                                                        .collection
                                                                        .id!
                                                                        .replaceAll(
                                                                            "gid://shopify/Collection/",
                                                                            ""))
                                                                  },
                                                                  i: i,
                                                                  isCart: true,
                                                                )
                                                              : ItemCardCart(
                                                                  calcu1:
                                                                      calcu1,
                                                                  collection:
                                                                      collectionsController
                                                                          .collection,
                                                                  i: i,
                                                                );
                                                        }),
                                              ),
                                              const SizedBox(height: 40)
                                            ],
                                          );
                                        }),
                                ],
                              ),
                            ),
                          ),
                          bottomCart(context),
                        ]),
                        (c.checkoutTap) ? loadingCircular() : const SizedBox()
                      ],
                    )));
              });
        });
  }

  Widget bottomCart(BuildContext context) {
    return GetBuilder<CartController>(builder: (c) {
      final _cartItems = controller.cart.lines;
      // double? totalPotongan;
      double? totalHarga = 0;

      for (Line y in _cartItems ?? []) {
        if (y.merchandise!.inventoryQuantity! > 0) {
          totalHarga = totalHarga! +
              (double.parse(y.merchandise!.price!) * y.quantity!.toDouble());
        }
      }

      if (controller.discountRunning.isNotEmpty) {
        totalPotongan = 0;

        for (Line x in _cartItems ?? []) {
          totalPotongan = totalPotongan +
              double.parse(x.discountAllocations!.amount ?? "0").round();
        }
      }
      if (controller.cart.discountCodes != null &&
          controller.cart.discountCodes!.isNotEmpty &&
          controller.cart.discountCodes![0].code != "") {
        totalPotongan = 0;

        if (controller.cart.discountAllocations == null ||
            controller.cart.discountAllocations!.isEmpty) {
          for (final x in _cartItems ?? []) {
            totalPotongan = totalPotongan +
                double.parse(x.discountAllocations!.amount ?? "0");
          }
        } else {
          for (final x in controller.cart.discountAllocations ?? []) {
            totalPotongan = totalPotongan + double.parse(x.amount!);
          }
        }
      }

      if (controller.cart.discountAllocations != null &&
          controller.cart.discountAllocations!.isNotEmpty &&
          controller.discountController.discountAutomaticTotalOrder.isEmpty) {
        totalPotongan =
            double.parse(controller.cart.discountAllocations![0].amount!);
      }

      if (controller
              .discountController.discountAutomaticTotalOrder.isNotEmpty &&
          controller.discountController.discountAutomatic.isEmpty &&
          selisihOrder <= 0 &&
          (controller.cart.discountCodes == null ||
              controller.cart.discountCodes!.isEmpty ||
              controller.cart.discountCodes![0].code == "")) {
        totalPotongan = double.parse(controller.discountController
            .discountAutomaticTotalOrder[0].customerGets!.value!.amount!);
      }

      totalHarga = totalHarga! - totalPotongan;

      return Container(
        height: (controller.show.value) ? 218 : 160,
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
        child: Column(
          children: [
            const VoucherWidget(),
            const SizedBox(height: 24),
            (controller.show.value)
                ? SizedBox(
                    child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: "Subtotal Produk",
                            fontSize: 12,
                            color: colorTextGrey,
                          ),
                          CustomText(
                            text:
                                "Rp  ${formatter.format((totalHarga + totalPotongan).round())}",
                            fontSize: 12,
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: "Potongan Harga",
                            fontSize: 12,
                            color: colorTextGrey,
                          ),
                          (totalPotongan != 0)
                              ? CustomText(
                                  text:
                                      "-Rp ${formatter.format(totalPotongan.round())}",
                                  fontSize: 12,
                                )
                              : const CustomText(
                                  text: "Rp 0",
                                  fontSize: 12,
                                )
                        ],
                      ),
                      const SizedBox(height: 16)
                    ],
                  ))
                : const SizedBox(),
            InkWell(
              onTap: () {
                controller.show.value = !controller.show.value;
                controller.update();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CustomText(
                        text: "Total Harga",
                        fontSize: 14,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          CustomText(
                            text:
                                "Rp ${(c.cart.estimatedCost == null || c.cart.estimatedCost!.totalAmount! == "0.0") ? "0" : formatter.format((totalHarga).round())}",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(width: 4),
                          Icon((controller.show.value)
                              ? Icons.keyboard_arrow_up
                              : Icons.keyboard_arrow_down)
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: (controller.homeController.maintenance)
                        ? null
                        : (c.cart.estimatedCost!.totalAmount == "0.0" &&
                                c.cart.estimatedCost!.subtotalAmount == "0.0")
                            ? null
                            : (c.checkoutTap)
                                ? null
                                : () async {
                                    c.checkoutTap = true;
                                    c.update();
                                    await c.getCheckoutUrl();
                                    var profile =
                                        Get.find<SettingsController>();
                                    await profile.fetchingUser();
                                    c.checkoutTap = false;
                                    (profile.userModel.displayName == null)
                                        ? Get.toNamed(Routes.PROFILE,
                                            arguments: [c, "cart"])
                                        : (profile.userModel.addresses !=
                                                    null &&
                                                profile.userModel.addresses!
                                                    .isNotEmpty)
                                            ? (controller.listHabis.length > 0)
                                                ? showAlert(context)
                                                : Get.toNamed(Routes.CHECKOUT)
                                            : Get.to(AddressForm(null, true));

                                    c.update();
                                  },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(156, 48),
                        backgroundColor: colorTextBlack,
                        disabledBackgroundColor: colorTextGrey,
                        padding: const EdgeInsets.all(14)),
                    child: const CustomText(
                      text: "Checkout",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<bool> showAlert(BuildContext context) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: const CustomText(
              text: 'Stok Tidak Tersedia',
              fontSize: 14,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.bold,
            ),
            content: const CustomText(
              text:
                  'Produk yang kamu pesan ada yang tidak tersedia. Lanjutkan checkout tanpa produk tersebut?',
              fontSize: 12,
              textOverflow: TextOverflow.fade,
              textAlign: TextAlign.center,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(
                  backgroundColor: colorTextBlack,
                  color: Colors.white,
                  onPressed: () {
                    Get.back();
                    Get.toNamed(Routes.CHECKOUT);
                    controller.checkoutTap = false;
                    controller.update();
                  },
                  //return true when click on "Yes"
                  text: 'Lanjutkan Checkout',
                  fontSize: 14,
                  height: 48,
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: CustomButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                    controller.checkoutTap = false;
                    controller.update();
                  },
                  //return false when click on "No"
                  text: 'Kembali',
                  fontSize: 14,
                  height: 48,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ) ??
        false; //if showDialouge had returned null, then return false
  }
}

import 'dart:math';
import 'package:colorbox/app/modules/cart/views/widget/voucher_widget.dart';
import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/modules/discount/controllers/discount_controller.dart';
import 'package:colorbox/app/modules/profile/views/address/address_form.dart';
import 'package:colorbox/app/widgets/appbar_default.dart';
import 'package:colorbox/app/widgets/empty_page.dart';
import 'package:colorbox/app/widgets/item_card_cart.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:colorbox/app/modules/cart/views/widget/item_cart_widget.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import '../controllers/cart_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class CartView extends GetView<CartController> {
  final DiscountController discountController = Get.put(DiscountController());
  final CollectionsController collectionsController =
      Get.put(CollectionsController());
  int index = 0;

  Future<void> initializeSettings() async {
    await discountController.getDiscountAutomatic();
    if (discountController.discountAutomatic.isNotEmpty) {
      var indexRandom = Random();
      int index =
          (discountController.discountAutomatic[0].collections!.isNotEmpty)
              ? indexRandom.nextInt(
                  discountController.discountAutomatic[0].collections!.length)
              : 0;

      await collectionsController.fetchCollectionProduct(
          int.parse(discountController
              .discountAutomatic[0].collections![index].id!
              .replaceAll('gid://shopify/Collection/', '')),
          2);
    }

    //Simulate other services for 3 seconds
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
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
                        child: Column(children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                child: (c.cart.lines!.isEmpty)
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 40),
                                        child: EmptyPage(
                                          image: Image.asset(
                                            "assets/icon/BAG.gif",
                                            height: 180,
                                          ),
                                          textHeader: "Keranjang Kamu Kosong",
                                          textContent:
                                              "Ayo segera belanja dan tambahkan produk kedalam keranjang",
                                        ),
                                      )
                                    : ListView.separated(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        separatorBuilder: (context, index) =>
                                            const Divider(
                                              color: colorDiver,
                                              thickness: 1,
                                            ),
                                        itemCount: c.cart.lines!.length,
                                        itemBuilder: (_, index) =>
                                            ItemCartWidget(
                                              formatter: formatter,
                                              controller: controller,
                                              index: index,
                                            )),
                              ),
                              (discountController.discountAutomatic.isEmpty)
                                  ? const SizedBox()
                                  : GetBuilder<CollectionsController>(
                                      init: Get.put(CollectionsController()),
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
                                                text: discountController
                                                        .discountAutomatic[0]
                                                        .title ??
                                                    "",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Container(
                                              padding: const EdgeInsets.only(
                                                  left: 16),
                                              height: 200,
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
                                                            3 / 1.3,
                                                      ),
                                                      itemBuilder: (_, i) {
                                                        var calcu1 = int.parse(
                                                                collectionsController
                                                                    .collection
                                                                    .products[i]
                                                                    .variants[0]
                                                                    .price!
                                                                    .replaceAll(
                                                                        ".00",
                                                                        "")) /
                                                            int.parse(
                                                                collectionsController
                                                                    .collection
                                                                    .products[i]
                                                                    .variants[0]
                                                                    .compareAtPrice!
                                                                    .replaceAll(
                                                                        ".00",
                                                                        ""));

                                                        return ItemCardCart(
                                                          calcu1: calcu1,
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
                      bottomCart(),
                    ])));
              });
        });
  }

  Widget bottomCart() {
    return GetBuilder<CartController>(builder: (c) {
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
                            color: Color(0xFF777777),
                          ),
                          CustomText(
                            text:
                                "Rp ${formatter.format(double.parse(controller.cart.estimatedCost!.subtotalAmount!.replaceAll(".0", "")).ceil())}",
                            fontSize: 12,
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: "Subtotal Voucher",
                            fontSize: 12,
                            color: Color(0xFF777777),
                          ),
                          (controller.cart.discountAllocations!.isNotEmpty)
                              ? CustomText(
                                  text:
                                      "-Rp ${formatter.format(double.parse(controller.cart.discountAllocations![0].amount!.replaceAll(".0", "")).ceil())}",
                                  fontSize: 12,
                                )
                              : const CustomText(
                                  text: "-Rp 0",
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
                                "Rp ${(c.cart.estimatedCost == null || c.cart.estimatedCost!.totalAmount! == "0.0") ? "0" : formatter.format(double.parse(c.cart.estimatedCost!.totalAmount!.replaceAll(".0", "")).ceil())}",
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
                    onPressed: (c.cart.estimatedCost!.totalAmount == "0.0" &&
                            c.cart.estimatedCost!.subtotalAmount == "0.0")
                        ? null
                        : () async {
                            await c.getCheckoutUrl();
                            var profile = Get.find<SettingsController>();
                            await profile.fetchingUser();
                            (profile.userModel.displayName == null)
                                ? Get.toNamed(Routes.PROFILE,
                                    arguments: [c, "cart"])
                                : (profile.userModel.addresses != null &&
                                        profile.userModel.addresses!.isNotEmpty)
                                    ? Get.toNamed(Routes.CHECKOUT)
                                    : Get.to(AddressForm(null, true));
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
}

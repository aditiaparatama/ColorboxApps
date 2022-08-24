import 'package:colorbox/app/modules/cart/views/widget/voucher_widget.dart';
import 'package:colorbox/app/modules/profile/views/address/address_form.dart';
import 'package:colorbox/app/widgets/empty_page.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:colorbox/app/modules/cart/views/widget/item_cart_widget.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import '../controllers/cart_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class CartView extends GetView<CartController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
        init: Get.put(CartController()),
        builder: (c) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(56),
                child: AppBar(
                  title: const CustomText(
                    text: "Keranjang",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  centerTitle: false,
                  elevation: 3,
                  shadowColor: Colors.grey.withOpacity(0.3),
                  leadingWidth: 36,
                  leading: IconButton(
                      padding: const EdgeInsets.all(16),
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close)),
                ),
              ),
              bottomSheet: bottomCart(),
              body: SizedBox(
                child: (c.cart.lines!.isEmpty)
                    ? EmptyPage(
                        image: SvgPicture.asset(
                          "assets/icon/State_Cart_No_Result.svg",
                        ),
                        textHeader: "Keranjang Kamu Kosong",
                        textContent:
                            "Ayo segera tambahkan produk kedalam keranjang",
                      )
                    : ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              color: colorDiver,
                              thickness: 1,
                            ),
                        itemCount: c.cart.lines!.length,
                        itemBuilder: (_, index) => ItemCartWidget(
                              formatter: formatter,
                              controller: controller,
                              index: index,
                            )),
              ));
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
              color: Colors.grey.withOpacity(0.8),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 7), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            const VoucherWidget(),
            const SizedBox(height: 24),
            (controller.show.value &&
                    controller.cart.discountAllocations!.isNotEmpty)
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
                                "Rp ${formatter.format(int.parse(controller.cart.estimatedCost!.subtotalAmount!.replaceAll(".0", "")))}",
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
                          CustomText(
                            text:
                                "-Rp ${formatter.format(int.parse(controller.cart.discountAllocations![0].amount!.replaceAll(".0", "")))}",
                            fontSize: 12,
                          )
                        ],
                      ),
                      const SizedBox(height: 16)
                    ],
                  ))
                : const SizedBox(),
            InkWell(
              onTap: (controller.cart.discountAllocations!.isEmpty)
                  ? null
                  : () {
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
                                "Rp ${(c.cart.estimatedCost!.totalAmount! == "0.0") ? "0" : formatter.format(double.parse(c.cart.estimatedCost!.totalAmount!.replaceAll(".0", "")).ceil())}",
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
                    onPressed: (c.cart.estimatedCost!.totalAmount == "0.0")
                        ? null
                        : () async {
                            await c.getCheckoutUrl();
                            var profile = Get.find<SettingsController>();
                            await profile.fetchingUser();
                            (profile.userModel.displayName == null)
                                ? Get.toNamed(Routes.PROFILE,
                                    arguments: [c, "cart"])
                                : (profile.userModel.addresses == null)
                                    ? Get.to(AddressForm(null, true))
                                    : Get.toNamed(Routes.CHECKOUT);
                          },
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(156, 48),
                        primary: Colors.black,
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

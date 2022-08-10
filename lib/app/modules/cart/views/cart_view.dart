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
                  title: const Text('Keranjang',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  centerTitle: false,
                  elevation: 3,
                  shadowColor: Colors.grey.withOpacity(0.3),
                  leading: IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close)),
                ),
              ),
              body: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    height: Get.height * .77,
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
                  ),
                  bottomCart(c)
                ],
              ));
        });
  }

  Container bottomCart(CartController c) {
    return Container(
      color: Colors.white,
      height: 80,
      padding: const EdgeInsets.all(16),
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
              CustomText(
                text:
                    "Rp ${(c.cart.estimatedCost!.subtotalAmount! == "0.0") ? "0" : formatter.format(double.parse(c.cart.estimatedCost!.subtotalAmount!.replaceAll(".0", "")).ceil())}",
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          ElevatedButton(
            onPressed: (c.cart.estimatedCost!.subtotalAmount == "0.0")
                ? null
                : () async {
                    await c.getCheckoutUrl();
                    var profile = Get.find<SettingsController>();
                    await profile.fetchingUser();
                    (profile.userModel.displayName == null)
                        ? Get.toNamed(Routes.PROFILE, arguments: [c, "cart"])
                        : (profile.userModel.addresses == null)
                            ? Get.to(AddressForm(null, true))
                            : Get.toNamed(Routes.CHECKOUT);
                  },
            style: ElevatedButton.styleFrom(
              // fixedSize: Size(Get.width * .4, 50),
              padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 14),
              primary: Colors.black,
            ),
            child: const CustomText(
              text: "Check Out",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

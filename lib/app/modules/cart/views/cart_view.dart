import 'package:colorbox/app/modules/cart/views/widget/item_cart_widget.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/modules/settings/views/web_view.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class CartView extends GetView<CartController> {
  var formatter = NumberFormat('###,000');
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
        init: Get.put(CartController()),
        builder: (c) {
          return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Column(
                children: [
                  SizedBox(
                    height: Get.height *
                        ((Get.arguments != "collection") ? .83 : .91),
                    child: ListView.builder(
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
      height: Get.height * .1 - 10,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text:
                "Total \n Rp. ${(c.cart.estimatedCost!.subtotalAmount! == "0.0") ? "0" : formatter.format(int.parse(c.cart.estimatedCost!.subtotalAmount!.replaceAll(".0", "")))}",
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          ElevatedButton(
            onPressed: (c.cart.estimatedCost!.subtotalAmount == "0.0")
                ? null
                : () async {
                    await c.getCheckoutUrl();
                    var profile = Get.find<SettingsController>();
                    await profile.getUser();
                    profile.userModel.displayName == null
                        ? Get.toNamed(Routes.PROFILE, arguments: [c, "cart"])
                        : Get.to(
                            WebViewPage(title: "Checkout", url: c.checkoutUrl));
                  },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(Get.width * .4, 50),
              primary: Colors.black,
            ),
            child: const CustomText(
              text: "Check Out",
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}

import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/controlV2/controllers/controlV2_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors
class ControlV2View extends GetView<ControlV2Controller> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControlV2Controller>(
        init: Get.put(ControlV2Controller()),
        builder: (context) {
          return Scaffold(
            body: controller.currentScreen,
            bottomNavigationBar: bottomNavigationBar(),
          );
        });
  }

  Widget bottomNavigationBar() => GetBuilder<ControlV2Controller>(
        init: Get.put(ControlV2Controller()),
        builder: (controller) => BottomNavigationBar(
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            bottomNavigationBarItem("assets/icon/cb.png", controller,
                menu: "home"),
            bottomNavigationBarItem("assets/icon/bx-search.svg", controller),
            bottomNavigationBarItem(
                "assets/icon/bx-shopping-bag.svg", controller,
                menu: "cart"),
            bottomNavigationBarItem("assets/icon/bx-user.svg", controller)
          ],
          currentIndex: controller.navigatorValue,
          onTap: (index) {
            controller.changeSelectedValue(index);
          },
          // elevation: 8,
          selectedItemColor: Colors.black,
          backgroundColor: Colors.white,
        ),
      );

  BottomNavigationBarItem bottomNavigationBarItem(String assets, var c,
      {String menu = "etc", double size = 25}) {
    return BottomNavigationBarItem(
      backgroundColor: Colors.white,
      activeIcon: Stack(
        children: [
          (menu == "home")
              ? Center(
                  child: Image.asset(
                    assets,
                    height: size + 5,
                    width: size + 5,
                  ),
                )
              : Center(
                  child: SvgPicture.asset(
                    assets,
                    height: size,
                    width: size,
                    color: Colors.black,
                  ),
                ),
          Get.find<CartController>().cart.lines!.isNotEmpty && menu == "cart"
              ? Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 25),
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
      label: "",
      icon: Stack(
        children: [
          (menu == "home")
              ? Center(
                  child: Image.asset(
                    assets,
                    height: size + 5,
                    width: size + 5,
                    color: const Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                )
              : Center(
                  child: SvgPicture.asset(
                    assets,
                    height: size,
                    width: size,
                    color: const Color.fromRGBO(0, 0, 0, 0.5),
                  ),
                ),
          Get.find<CartController>().cart.lines!.isNotEmpty && menu == "cart"
              ? Container(
                  alignment: Alignment.topRight,
                  padding: const EdgeInsets.only(right: 25),
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
    );
  }
}

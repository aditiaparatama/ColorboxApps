import 'package:colorbox/app/modules/controlV2/controllers/controlV2_controller.dart';
import 'package:colorbox/constance.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class ControlV2View extends GetView<ControlV2Controller> {
  GlobalKey globalKey = GlobalKey(debugLabel: 'btm_app_bar');

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControlV2Controller>(
        init: Get.put(ControlV2Controller()),
        builder: (_) {
          return Scaffold(
            body: DoubleBackToCloseApp(
                snackBar: const SnackBar(
                  content: Text('Tap back again to leave'),
                ),
                child: controller.currentScreen),
            bottomNavigationBar: bottomNavigationBar(),
          );
        });
  }

  Widget bottomNavigationBar() => GetBuilder<ControlV2Controller>(
        init: Get.put(ControlV2Controller()),
        builder: (controller) => BottomNavigationBar(
          key: globalKey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          items: [
            bottomNavigationBarItem("assets/icon/home_inactive.svg",
                menu: "Home", assetActive: "assets/icon/home_active.svg"),
            bottomNavigationBarItem("assets/icon/Icon-Search.svg",
                menu: "Kategori"),
            bottomNavigationBarItem("assets/icon/icon_line-Heart.svg",
                menu: "Wishlist",
                assetActive: "assets/icon/icon_filled-Heart.svg"),
            bottomNavigationBarItem("assets/icon/icon_line-user_1.svg",
                menu: "Akun Saya",
                assetActive: "assets/icon/icon_filled-user_1.svg")
          ],
          currentIndex: controller.navigatorValue,
          onTap: (index) {
            controller.changeSelectedValue(index, globalKey);
          },
          // elevation: 8,
          selectedItemColor: colorTextBlack,
          backgroundColor: Colors.white,
        ),
      );

  BottomNavigationBarItem bottomNavigationBarItem(String assets,
      {String menu = "etc", double size = 25, String? assetActive}) {
    return BottomNavigationBarItem(
      backgroundColor: Colors.white,
      activeIcon: Stack(
        children: [
          Column(children: [
            SvgPicture.asset(
              assetActive ?? assets,
              height: size,
              width: size,
              color: colorTextBlack,
            ),
            const SizedBox(
              height: 4,
            ),
            CustomText(
              text: menu,
              fontSize: 12,
            )
          ]),
        ],
      ),
      label: "",
      icon: Column(
        children: [
          SvgPicture.asset(
            assets,
            height: size,
            width: size,
            color: const Color(0xFF9B9B9B),
          ),
          const SizedBox(
            height: 4,
          ),
          CustomText(
            text: menu,
            fontSize: 12,
            color: const Color(0xFF9B9B9B),
          ),
        ],
      ),
    );
  }
}

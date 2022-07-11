import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/app/modules/control/views/submenu_view.dart';
import 'package:colorbox/app/modules/control/views/subsubmenu_view.dart';
import 'package:colorbox/app/modules/home/views/home_view.dart';
import 'package:colorbox/app/widgets/screens/menu_screen.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class ControlView extends GetView<ControlController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControlController>(
      builder: (controller) => Scaffold(
          body: DoubleBackToCloseApp(
        snackBar: const SnackBar(
          content: Text('Tap back again to leave'),
        ),
        child: ZoomDrawer(
          style: DrawerStyle.Style6,
          menuScreen: Builder(builder: (context) {
            return MenuScreen(
              currentItem: controller.currentItem,
              onSelectedItem: (item) {
                controller.currentItem = item;
                controller.update();
                ZoomDrawer.of(context)!.close();
              },
            );
          }),
          mainScreen: getScreen(),
          borderRadius: 24.0,
          showShadow: true,
          angle: 0,
          backgroundColor: Colors.grey[300]!,
          slideWidth: Get.width * 0.55,
          openCurve: Curves.fastOutSlowIn,
          closeCurve: Curves.bounceIn,
        ),
      )),
    );
  }

  Widget getScreen() {
    switch (controller.currentItem) {
      case 'Home':
        return HomeView();
      case 'SubSubMenu':
        return SubsubmenuView();
      default:
        return SubmenuView(
          currentItem: controller.currentItem,
        );
    }
  }
}

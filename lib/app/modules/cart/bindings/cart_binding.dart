import 'package:colorbox/app/modules/controlV2/controllers/controlV2_controller.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';

import '../controllers/cart_controller.dart';

class CartBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CartController>(
      () => CartController(),
    );
    Get.lazyPut<ControlV2Controller>(
      () => ControlV2Controller(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}

import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/app/modules/controlV2/controllers/controlV2_controller.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:get/get.dart';

class Controlv2Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControlV2Controller>(
      () => ControlV2Controller(),
    );
    Get.lazyPut<ControlController>(
      () => ControlController(),
    );
    Get.lazyPut<LocalStorageData>(
      () => LocalStorageData(),
    );
    Get.lazyPut<CartController>(
      () => CartController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}

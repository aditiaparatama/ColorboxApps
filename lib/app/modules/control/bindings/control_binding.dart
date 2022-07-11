import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:get/get.dart';

class ControlBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ControlController>(
      () => ControlController(),
    );
    Get.lazyPut<LocalStorageData>(
      () => LocalStorageData(),
    );
    Get.lazyPut<CartController>(
      () => CartController(),
    );
  }
}

import 'package:colorbox/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';
import 'package:colorbox/app/modules/controlV2/controllers/controlv2_controller.dart';

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
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}

import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/controlV2/controllers/controlV2_controller.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
    Get.lazyPut<ControlV2Controller>(
      () => ControlV2Controller(),
    );
    Get.lazyPut<LocalStorageData>(
      () => LocalStorageData(),
    );
    Get.lazyPut<CartController>(
      () => CartController(),
    );
  }
}

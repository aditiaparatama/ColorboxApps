import 'package:colorbox/app/modules/controlV2/controllers/controlV2_controller.dart';
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
  }
}

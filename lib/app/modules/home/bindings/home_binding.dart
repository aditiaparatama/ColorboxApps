import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<CollectionsController>(
      () => CollectionsController(),
    );
    Get.lazyPut<ControlController>(
      () => ControlController(),
    );
  }
}

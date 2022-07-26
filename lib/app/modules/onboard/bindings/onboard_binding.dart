import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:get/get.dart';

import '../controllers/onboard_controller.dart';

class OnBoardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnBoardController>(
      () => OnBoardController(),
    );
    Get.lazyPut<CollectionsController>(
      () => CollectionsController(),
    );
  }
}

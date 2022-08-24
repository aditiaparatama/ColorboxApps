import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';

import '../controllers/orders_controller.dart';

class OrdersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrdersController>(
      () => OrdersController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
  }
}

import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:get/get.dart';
import '../controllers/discount_controller.dart';

class DiscountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DiscountController>(
      () => DiscountController(),
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
    );
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(),
    );
  }
}

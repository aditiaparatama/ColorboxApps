import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/discount/controllers/discount_controller.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:get/get.dart';
import '../controllers/checkout_controller.dart';

class CheckoutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckoutController>(
      () => CheckoutController(),
    );
    Get.lazyPut<LocalStorageData>(
      () => LocalStorageData(),
    );
    Get.lazyPut<CartController>(
      () => CartController(),
    );
    Get.lazyPut<DiscountController>(
      () => DiscountController(),
    );
  }
}

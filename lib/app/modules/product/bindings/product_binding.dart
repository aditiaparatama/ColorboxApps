import 'package:colorbox/app/modules/controlV2/controllers/controlV2_controller.dart';
import 'package:colorbox/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:get/get.dart';

import '../controllers/product_controller.dart';

class ProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductController>(
      () => ProductController(),
    );
    Get.lazyPut<ControlV2Controller>(
      () => ControlV2Controller(),
    );
    Get.lazyPut<WishlistController>(
      () => WishlistController(),
    );
  }
}

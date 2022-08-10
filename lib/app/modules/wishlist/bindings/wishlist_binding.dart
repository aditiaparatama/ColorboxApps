import 'package:colorbox/helper/local_storage_data.dart';
import 'package:get/get.dart';
import '../controllers/wishlist_controller.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WishlistController>(
      () => WishlistController(),
    );
    Get.lazyPut<LocalStorageData>(
      () => LocalStorageData(),
    );
  }
}

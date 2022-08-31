import '../controllers/collections_controller.dart';
import 'package:get/get.dart';

class CollectionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CollectionsController>(
      () => CollectionsController(),
    );
  }
}

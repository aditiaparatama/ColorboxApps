import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/orders/controllers/orders_controller.dart';
import 'package:colorbox/app/modules/profile/providers/profile_provider.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final LocalStorageData localStorageData = Get.put(LocalStorageData());
  UserModel _userModel = UserModel.isEmpty();
  UserModel get userModel => _userModel;
  CustomerToken? _token = CustomerToken.isEmpty();
  CustomerToken? get token => _token;
  OrdersController get ordersController => Get.put(OrdersController());
  int pesananCount = 0;

  @override
  void onInit() async {
    await getUser();
    getTotalOrders();
    super.onInit();
  }

  Future<void> getUser() async {
    await localStorageData.getUser.then((value) {
      _userModel = value;
    });

    await localStorageData.getTokenUser.then((value) => _token = value);

    update();
  }

  getTotalOrders() async {
    if (_userModel.displayName != null) {
      pesananCount = await ordersController.countOrderActive();
      update();
    }
  }

  Future<void> logout() async {
    localStorageData.deleteUser();
    _userModel = UserModel.isEmpty();
    await Get.find<CartController>().reCreateCart();

    update();
  }

  Future<void> fetchingUser() async {
    _token = await localStorageData.getTokenUser;
    if (_token!.accessToken != null) {
      var result = await ProfileProvider().getUser(_token!.accessToken!);
      _userModel = UserModel.fromJson(result);
    }
    update();
  }
}

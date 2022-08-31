import 'package:colorbox/app/modules/orders/controllers/orders_controller.dart';
import 'package:colorbox/app/modules/profile/providers/profile_provider.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final LocalStorageData localStorageData = Get.find();
  UserModel _userModel = UserModel.isEmpty();
  UserModel get userModel => _userModel;
  CustomerToken? _token = CustomerToken.isEmpty();
  CustomerToken? get token => _token;
  OrdersController get ordersController => Get.put(OrdersController());

  @override
  void onInit() async {
    getUser();
    super.onInit();
  }

  Future<void> getUser() async {
    await localStorageData.getUser.then((value) {
      _userModel = value;
    });

    await localStorageData.getTokenUser.then((value) => _token = value);

    update();
  }

  void logout() {
    localStorageData.deleteUser();
    _userModel = UserModel.isEmpty();
    update();
  }

  Future<void> fetchingUser() async {
    _token = await localStorageData.getTokenUser;
    var result = await ProfileProvider().getUser(_token!.accessToken!);
    _userModel = UserModel.fromJson(result);
    update();
  }
}

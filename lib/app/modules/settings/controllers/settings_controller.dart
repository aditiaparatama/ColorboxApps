import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final LocalStorageData localStorageData = Get.find();
  UserModel _userModel = UserModel.isEmpty();
  UserModel get userModel => _userModel;
  String? _token;
  String? get token => _token;

  SettingsController() {
    getUser();
  }

  getUser() async {
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
}

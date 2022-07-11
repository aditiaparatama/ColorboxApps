import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/cart/providers/cart_provider.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/profile/providers/profile_provider.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final LocalStorageData localStorageData = Get.find();
  ValueNotifier loading = ValueNotifier(false);
  UserModel _userModel = UserModel.isEmpty();
  UserModel get userModel => _userModel;
  String? email, password, firstName, lastName, phone;

  Future<String> login() async {
    loading.value = true;
    update();
    var result = await ProfileProvider().login(email!, password!);
    if (result['customerUserErrors'].length > 0) {
      loading.value = false;
      update();
      return "Email/ Password tidak valid";
    } else {
      setToken(result["customerAccessToken"]['accessToken']);
      var user = await ProfileProvider()
          .getUser(result["customerAccessToken"]['accessToken']);
      _userModel = UserModel.fromJson(user);
      _userModel.expiresAt = result["customerAccessToken"]['expiresAt'];

      setUser(userModel);

      CartProvider().cartBuyerIdentityupdate(Get.find<CartController>().idCart,
          result["customerAccessToken"]['accessToken'], _userModel);

      loading.value = false;
      update();
    }

    return "1";
  }

  Future<String> register() async {
    loading.value = true;
    update();

    (phone!.substring(0, 1) == "0")
        ? phone = "+62${phone!.substring(1, phone!.length)}"
        : phone = "+62${phone!}";
    var result = await ProfileProvider()
        .register(email!, password!, firstName!, lastName!, phone!);
    loading.value = false;
    update();
    return result;
  }

  void setUser(UserModel userModel) async {
    await localStorageData.setUser(userModel);
  }

  void setToken(String token) async {
    await localStorageData.setTokenUser(token);
  }
}

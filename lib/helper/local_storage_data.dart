import 'dart:convert';

import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/constance.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageData extends GetxController {
  Future<String?> get getCart async {
    try {
      String? id = await _getCartData();
      if (id == null) return null;
      return id;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  _getCartData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(CACHED_CART_DATA);

    return value;
  }

  setCart(String id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString(CACHED_CART_DATA, id);
  }

  Future<void> deleteCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(CACHED_CART_DATA);
  }

  Future<UserModel> get getUser async {
    try {
      UserModel? userModel = await _getUserData();
      if (userModel == null) return UserModel.isEmpty();
      return userModel;
    } catch (e) {
      // print(e.toString());
      return UserModel.isEmpty();
    }
  }

  _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(CACHED_USER_DATA);

    return UserModel.json(jsonDecode(value!));
  }

  setUser(UserModel userModel) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString(CACHED_USER_DATA, jsonEncode(userModel.toJson()));
  }

  void deleteUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    await prefs.remove(CACHED_USER_DATA);
  }

  void deleteToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // await prefs.clear();
    await prefs.remove(CACHED_USER_TOKEN);
  }

  Future<CustomerToken?> get getTokenUser async {
    try {
      CustomerToken data = await _getTokenUser();
      return data;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  _getTokenUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getString(CACHED_USER_TOKEN);
    if (value == null) {
      return CustomerToken.isEmpty();
    }
    return CustomerToken.json(jsonDecode(value));
  }

  setTokenUser(CustomerToken data) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    await pref.setString(CACHED_USER_TOKEN, jsonEncode(data.toJson()));
  }
}

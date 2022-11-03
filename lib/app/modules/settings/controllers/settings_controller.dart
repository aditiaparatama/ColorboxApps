import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/orders/controllers/orders_controller.dart';
import 'package:colorbox/app/modules/profile/providers/profile_provider.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  final LocalStorageData localStorageData = Get.put(LocalStorageData());
  UserModel _userModel = UserModel.isEmpty();
  UserModel get userModel => _userModel;
  CustomerToken? _token = CustomerToken.isEmpty();
  CustomerToken? get token => _token;
  OrdersController get ordersController => Get.put(OrdersController());
  int pesananCount = 0;
  final ValueNotifier _loading = ValueNotifier(false);
  ValueNotifier get loading => _loading;

  @override
  void onInit() async {
    await getUser();
    super.onInit();
  }

  Future<void> getUser() async {
    // await localStorageData.getUser.then((value) {
    //   _userModel = value;
    // });

    _token = await localStorageData.getTokenUser;
    if (_token!.accessToken != null) {
      _token = _token;
      var result = await ProfileProvider().getUserFromAdmin(token!.id!);
      _userModel = UserModel.fromAdmin(result);
    }

    // await localStorageData.getTokenUser.then((value) => _token = value);
    getTotalOrders();
    update();
  }

  getTotalOrders() async {
    // await getUser();
    if (_userModel.displayName != null) {
      pesananCount = await ordersController.countOrderActive();
      update();
    }
  }

  Future<void> logout() async {
    _loading.value = true;
    update();
    FirebaseAuth.instance.signOut();
    localStorageData.deleteUser();
    localStorageData.deleteToken();
    _userModel = UserModel.isEmpty();
    await Get.find<CartController>().reCreateCart();
    _loading.value = false;
    update();
  }

  Future<void> fetchingUser({String id = "-1"}) async {
    _token = await localStorageData.getTokenUser;
    // if (id != "-1" && _token!.accessToken != null) {
    //   var result = await ProfileProvider().getUserFromAdmin(id);
    //   _userModel = UserModel.fromAdmin(result);
    // } else if (_token!.accessToken != null) {
    //   var result = await ProfileProvider().getUser(_token!.accessToken!);
    //   _userModel = UserModel.fromJson(result);
    // }
    if (_token!.accessToken != null) {
      var result = await ProfileProvider().getUserFromAdmin(token!.id!);
      _userModel = UserModel.fromAdmin(result);
    }
    update();
  }
}

import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/collections/views/collections_list.dart';
import 'package:colorbox/app/modules/home/views/home_view.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/profile/views/profile_view.dart';
import 'package:colorbox/app/modules/cart/models/cart_model.dart';
import 'package:colorbox/app/modules/settings/views/settings_view.dart';
import 'package:colorbox/app/modules/wishlist/views/wishlist_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ControlV2Controller extends GetxController {
  int _navigatorValue = 0;
  get navigatorValue => _navigatorValue;
  var formatter = DateFormat('yyyy-MM-dd hh:mm:dd');

  Widget _currentScreen = HomeView();

  UserModel _user = UserModel.isEmpty();
  UserModel get user => _user;

  get currentScreen => _currentScreen;
  Cart get cart => _cart;
  Cart _cart = Cart.empty();

  @override
  void onInit() async {
    // var connectivityResult = await (Connectivity().checkConnectivity());

    _cart = await Get.find<CartController>().getCart2();

    _user = Get.find<SettingsController>().userModel;
    if (_user.displayName != null) {
      var now = DateTime.now();
      var expired =
          DateTime.parse(Get.find<SettingsController>().token!.expiresAt!);
      if (now.isAfter(expired)) Get.find<SettingsController>().logout();
    }
    if (_user.displayName == null) {
      // Get.find<SettingsController>().logout();
    }
    update();
    super.onInit();
  }

  void changeSelectedValue(int selectedValue, globalKey) {
    _navigatorValue = selectedValue;

    switch (selectedValue) {
      case 0:
        {
          _currentScreen = HomeView();
          break;
        }
      case 1:
        {
          _currentScreen = CollectionList();
          break;
        }
      case 2:
        {
          _currentScreen =
              (Get.find<SettingsController>().userModel.displayName != null)
                  ? WishlistView()
                  : ProfileView(globalKey);
          break;
        }
      case 3:
        {
          _currentScreen = SettingsView();
          break;
        }
      case 4:
        {
          _currentScreen = ProfileView(globalKey);
          break;
        }
      default:
        {
          _currentScreen = HomeView();
          break;
        }
    }

    update();
  }
}

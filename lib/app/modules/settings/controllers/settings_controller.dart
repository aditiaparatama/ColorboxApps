import 'package:colorbox/app/data/models/location_model.dart';
import 'package:colorbox/app/modules/orders/controllers/orders_controller.dart';
import 'package:colorbox/app/modules/profile/providers/profile_provider.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/settings/providers/settings_provider.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:colorbox/utilities/extension.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

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
  List<LocationStore> _locationStore = [];
  List<LocationStore> get locationStore => _locationStore;
  List<LocationStore> _provinceStore = [];
  List<LocationStore> get provinceStore => _provinceStore;
  List<LocationStore> searchLocation = [];
  List<LocationStore> searchLocationProvince = [];
  int? indexSelectedRadio;

  LocationData? currentPosition;
  bool? serviceEnabled;
  late PermissionStatus _permissionGranted;
  Location location = Location();

  @override
  void onInit() async {
    await getUser();
    fetchingLocationStore();
    await requestPermission();

    super.onInit();
  }

  Future<void> requestPermission() async {
    serviceEnabled = await location.serviceEnabled();

    if (!serviceEnabled!) {
      serviceEnabled = await location.requestService();

      if (!serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    currentPosition = await location.getLocation();
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

  Future<UserModel> fetchUser() async {
    _token = await localStorageData.getTokenUser;
    if (_token!.accessToken != null) {
      _token = _token;
      var result = await ProfileProvider().getUserFromAdmin(token!.id!);
      _userModel = UserModel.fromAdmin(result);
    }
    getTotalOrders();

    return _userModel;
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
    if (FirebaseAuth.instance.currentUser!.isAnonymous) {
      FirebaseAuth.instance.currentUser!.delete();
    }
    FirebaseAuth.instance.signOut();
    localStorageData.deleteUser();
    localStorageData.deleteToken();
    _userModel = UserModel.isEmpty();
    // await Get.find<CartController>().reCreateCart();
    _loading.value = false;
    update();
  }

  Future<void> fetchingUser({String id = "-1"}) async {
    _token = await localStorageData.getTokenUser;
    if (_token!.accessToken != null) {
      var result = await ProfileProvider().getUserFromAdmin(token!.id!);
      _userModel = UserModel.fromAdmin(result);
    }
    update();
  }

  void fetchingLocationStore() async {
    _locationStore = [];
    _provinceStore = [];
    var result = await SettingsProvider().locationStore();
    var resultProvince = await SettingsProvider().locationStore();

    if (result != null && result != "") {
      for (final x in result) {
        _locationStore.add(LocationStore.fromJson(x));
      }
      searchLocation = _locationStore;
    }

    if (resultProvince != null && resultProvince != "") {
      for (final x in resultProvince) {
        if ((_provinceStore.indexWhere((e) =>
                e.city == StringExtention(x["city"]).toTitleCase() &&
                e.province == x["province"])) ==
            -1) {
          _provinceStore.add(LocationStore.fromProvince(x));
        }
      }
      searchLocation = _provinceStore;
    }
  }

  void deleteAccount(dynamic data) async {
    await SettingsProvider().deleteAccount(data);
  }

  searchLocationStore(String value) {
    searchLocation = _locationStore
        .where((e) =>
            e.province!.toLowerCase().contains(value.toLowerCase()) ||
            e.city!.toLowerCase().contains(value.toLowerCase()))
        .toList();

    update();
  }

  searchProvinceStore(String value) {
    searchLocationProvince = _provinceStore
        .where((e) =>
            e.province!.toLowerCase().contains(value.toLowerCase()) ||
            e.city!.toLowerCase().contains(value.toLowerCase()))
        .toList();

    update();
  }
}

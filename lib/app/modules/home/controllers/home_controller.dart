import 'package:colorbox/app/modules/home/providers/home_provider.dart';
import 'package:colorbox/app/modules/home/models/home_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<Home> _home = List<Home>.empty();
  List<Home> get home => _home;
  String currentItem = 'Home';
  int curIndex = 0;

  @override
  void onInit() async {
    if (_home.isEmpty) {
      await fetchData();
      // await getSlider();
    }
    // Get.find<CartController>().createCart();
    super.onInit();
  }

  Future<void> fetchData() async {
    var json = await HomeProvider().getSlider();
    _home = [];
    for (int i = 0; i < json.length; i++) {
      _home.add(Home.fromJson(json[i]));
    }
    update();
  }

  // Future<void> getSlider() async {
  //   for (int i = 0; i < _home.length; i++) {
  //     listTabs.add(Tab(child: Text(_home[i].title!.toUpperCase())));
  //   }
  //   update();
  // }
}

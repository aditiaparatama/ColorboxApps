import 'package:colorbox/app/modules/control/providers/menu_provider.dart';
import 'package:colorbox/app/modules/control/menu_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControlController extends GetxController {
  List<Menu> _menu = List<Menu>.empty();
  List<Menu> get menu => _menu;
  String currentItem = 'Home';
  final List<Widget> _listTabs = [];
  List<Widget> get listTabs => _listTabs;

  int curIndex = 0;

  @override
  void onInit() async {
    if (_menu.isEmpty) {
      await fetchData();
      await getMenu();
    }
    // Get.find<CartController>().createCart();
    super.onInit();
  }

  Future<void> fetchData() async {
    var json = await MenuProvider().getMenu();
    _menu = [];
    for (int i = 0; i < json.length; i++) {
      _menu.add(Menu.fromJson(json[i]));
    }
    update();
  }

  Future<void> getMenu() async {
    for (int i = 0; i < _menu.length; i++) {
      listTabs.add(Tab(child: Text(_menu[i].title!.toUpperCase())));
    }
    update();
  }
}

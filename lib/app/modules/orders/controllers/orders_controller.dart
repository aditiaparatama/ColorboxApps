import 'package:colorbox/app/modules/orders/models/order_model.dart';
import 'package:colorbox/app/modules/orders/providers/order_provider.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OrdersController extends GetxController {
  SettingsController settingController = Get.find<SettingsController>();
  List<Order> _orders = [];
  List<Order> get order => _orders;
  final ValueNotifier _loading = ValueNotifier(false);
  ValueNotifier get loading => _loading;

  @override
  void onInit() {
    fetchingDataOrders();
    super.onInit();
  }

  fetchingDataOrders() async {
    _loading.value = true;
    update();
    var result =
        await OrderProvider().getOrders(settingController.userModel.id!);
    _orders = [];
    for (final x in result['orders']['edges']) {
      _orders.add(Order.fromJson(x['node']));
    }
    _loading.value = false;
    update();
  }
}

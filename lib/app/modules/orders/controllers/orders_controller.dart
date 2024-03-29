import 'package:colorbox/app/data/models/history_model.dart';
import 'package:colorbox/app/modules/orders/models/order_model.dart';
import 'package:colorbox/app/modules/orders/providers/order_provider.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OrdersController extends GetxController {
  SettingsController settingController = Get.find<SettingsController>();
  List<Order> _orders = [];
  List<Order> get order => _orders;
  List<Order> _ordersFilter = [];
  List<Order> get ordersFilter => _ordersFilter;
  List<History> _history = [];
  List<History> get history => _history;
  final ValueNotifier _loading = ValueNotifier(true);
  ValueNotifier get loading => _loading;
  final ValueNotifier _loadingMore = ValueNotifier(false);
  ValueNotifier get loadingMore => _loadingMore;
  PageInfo _pageInfo = PageInfo.isEmpty();
  PageInfo get pageInfo => _pageInfo;
  int countPesanan = 0;

  bool show = false;

  // @override
  // void onInit() async {
  //   _history = [];
  //   super.onInit();
  // }

  filterFetchingData(String? filter) async {
    _history = [];
    _loading.value = true;
    String query = (filter == "riwayat")
        ? ", query:\"financial_status:expired OR status:cancelled\""
        : ", query:\"(NOT financial_status:expired) AND NOT status:cancelled\"";
    _ordersFilter = [];
    _orders = [];
    var result = await OrderProvider()
        .getOrders(settingController.userModel.id!, query: query);

    if (result == null) {
      while (result == null) {
        result = await Future.delayed(
            const Duration(milliseconds: 1000),
            () => OrderProvider()
                .getOrders(settingController.userModel.id!, query: query));
      }
    }
    if (result['customer'] != null &&
        result['customer']['orders']['edges'].length > 0) {
      _pageInfo = PageInfo.fromJson(result['customer']['orders']['pageInfo']);

      for (final x in result['customer']['orders']['edges']) {
        _orders.add(Order.fromJson(
            x['node'], result['customer']['orders']['pageInfo']));
      }
    }
    _ordersFilter = _orders;
    _loading.value = false;
    update();
  }

  filterDataOrders(String? filter) {
    _ordersFilter = _orders;
    if (filter == "riwayat") {
      _ordersFilter.removeWhere((e) =>
          e.status == "Menunggu Pembayaran" ||
          e.status == "Diproses" ||
          e.status == "Dikirim");
      update();
      return;
    }
    _ordersFilter
        .removeWhere((e) => e.status == "Dibatalkan" || e.status == "selesai");
    update();
  }

  loadMore(String? filter) async {
    _loadingMore.value = true;
    String query = (filter == "riwayat")
        ? ", query:\"financial_status:expired OR status:cancelled\""
        : ", query:\"(NOT financial_status:expired) AND NOT status:cancelled\"";
    update();
    var result = await OrderProvider().getOrdersNext(
        settingController.userModel.id!, pageInfo.endCursor!,
        query: query);
    _pageInfo = PageInfo.fromJson(result['orders']['pageInfo']);
    for (final x in result['orders']['edges']) {
      _orders.add(Order.fromJson(x['node'], result['orders']['pageInfo']));
    }
    _loadingMore.value = false;
    update();
  }

  Future<int> countOrderActive() async {
    var now = DateTime.now();
    var dateMin = now.add(const Duration(days: -90));
    var temp = [];
    if (settingController.userModel.id == null) {
      await settingController.fetchingUser();
    }
    var result = await OrderProvider().getActiveOrders(
        settingController.userModel.id!,
        DateFormat("yyyy-MM-dd").format(dateMin),
        null);

    if (result == null) {
      while (result == null) {
        result = await Future.delayed(
            const Duration(milliseconds: 1000),
            () => OrderProvider().getActiveOrders(
                settingController.userModel.id!,
                DateFormat("yyyy-MM-dd").format(dateMin),
                null));
      }
    }

    temp.add(result['orders']['edges'].length);
    while (result['orders']['pageInfo']['hasNextPage']) {
      result = await Future.delayed(
          const Duration(milliseconds: 1000),
          () => OrderProvider().getActiveOrders(
              settingController.userModel.id!,
              DateFormat("yyyy-MM-dd").format(dateMin),
              result['orders']['pageInfo']['endCursor']));
      temp.add(result['orders']['edges'].length);
    }

    countPesanan = temp.reduce((a, b) => a + b);
    update();
    return countPesanan;
  }

  Future<void> lacakPengiriman(String noResi) async {
    _history = [];
    var result = await OrderProvider().trackingLogistik(noResi);

    if (!result.containsKey("error")) {
      for (int i = 0; i < result["history"].length; i++) {
        _history.add(History.fromJson(result["history"][i], i));
      }

      _history.sort((a, b) => b.no!.compareTo(a.no!));
    }
    update();
  }
}

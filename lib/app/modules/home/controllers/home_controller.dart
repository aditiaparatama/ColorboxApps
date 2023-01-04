import 'package:colorbox/app/modules/home/models/announcement_model.dart';
import 'package:colorbox/app/modules/home/models/newsletter_model.dart';
import 'package:colorbox/app/modules/home/providers/home_provider.dart';
import 'package:colorbox/app/modules/home/models/home_model.dart';
import 'package:colorbox/app/modules/profile/providers/profile_provider.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  List<Sliders> _sliders = List<Sliders>.empty();
  List<Sliders> get sliders => _sliders;

  List<Category> _category = List<Category>.empty();
  List<Category> get category => _category;

  List<Collections> _collections = List<Collections>.empty();
  List<Collections> get collections => _collections;

  List<Announcement> _announcementHome = [];
  List<Announcement> get announcementHome => _announcementHome;

  List<Announcement> _announcementProduct = [];
  List<Announcement> get announcementProduct => _announcementProduct;

  Newsletter _newsletter = Newsletter.isEmpty();
  Newsletter get newsletter => _newsletter;

  bool _maintenance = false;
  bool get maintenance => _maintenance;

  List<String> _excludeVoucher = [];
  List<String> get excludeVoucher => _excludeVoucher;

  String currentItem = 'Home';
  int curIndex = 0;

  bool firstBuild = true, subscribe = false;

  @override
  void onInit() async {
    await fetchData();
    await getCategory();

    super.onInit();
  }

  Future<void> fetchData() async {
    var json = await HomeProvider().getHomeSettings();
    _sliders = [];
    _announcementHome = [];
    _announcementProduct = [];

    for (int i = 0; i < json['sliders']['items'].length; i++) {
      _sliders.add(Sliders.fromJson(json['sliders']['items'][i]));
    }

    _maintenance =
        (json.containsKey("maintenance")) ? json["maintenance"] : false;
    _excludeVoucher = [];
    for (final x in json["excludeVoucher"]) {
      _excludeVoucher.add(x);
    }
    _newsletter = Newsletter.fromJson(json["newsletter"]);
    getCollections(json['CollectionsHome']['items']);
    getAnnouncementHome(json['announcementHome']);
    getAnnouncementProduct(json['announcementProduct']);

    update();
  }

  Future<void> getCategory() async {
    var json = await HomeProvider().getCategory();
    _category = [];
    for (int i = 0; i < json.length; i++) {
      _category.add(Category.fromJson(json[i]));
    }
    update();
  }

  getCollections(json) {
    // var json = await HomeProvider().getCollections();
    _collections = [];
    for (int i = 0; i < json.length; i++) {
      _collections.add(Collections.fromJson(json[i]));
    }
    update();
  }

  getAnnouncementHome(json) async {
    _announcementHome = [];
    for (int i = 0; i < json.length; i++) {
      _announcementHome.add(Announcement.fromJson(json[i]));
    }
    update();
  }

  getAnnouncementProduct(json) async {
    _announcementProduct = [];
    for (int i = 0; i < json.length; i++) {
      _announcementProduct.add(Announcement.fromJson(json[i]));
    }
    update();
  }

  customerSubscribe(String email) async {
    var customer = await ProfileProvider().checkExistUser(email);
    while (customer == null) {
      Future.delayed(const Duration(milliseconds: 500),
          () async => customer = await ProfileProvider().checkExistUser(email));
    }
    var variables = {
      "input": {
        "customerId": customer['customers']['edges'][0]['node']['id'],
        "emailMarketingConsent": {
          "consentUpdatedAt": DateTime.now().toIso8601String(),
          "marketingOptInLevel": "CONFIRMED_OPT_IN",
          "marketingState": "SUBSCRIBED"
        }
      }
    };

    var result = await HomeProvider().customerSubscribe(variables);

    if (result['customerEmailMarketingConsentUpdate']['userErrors'].length >
        0) {
      Get.snackbar(
          "Error",
          result['customerEmailMarketingConsentUpdate']['userErrors'][0]
              ["message"],
          backgroundColor: colorTextBlack,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);

      subscribe = false;
      update();
      return;
    }

    subscribe = true;
    update();
  }
}

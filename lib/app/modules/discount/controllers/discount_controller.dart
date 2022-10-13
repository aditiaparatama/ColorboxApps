import 'package:colorbox/app/modules/discount/models/discount_model.dart';
import 'package:colorbox/app/modules/discount/providers/discount_provider.dart';
import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:colorbox/app/modules/home/models/announcement_model.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DiscountController extends GetxController {
  final HomeController homeController = Get.put(HomeController());
  final SettingsController settingsController = Get.put(SettingsController());
  ValueNotifier get loading => _loading;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  List<Discount> _discount = [];
  List<Discount> get discount => _discount;
  List<DiscountAutomatic> _discountAutomatic = [];
  List<DiscountAutomatic> get discountAutomatic => _discountAutomatic;
  UserModel _user = UserModel.isEmpty();
  var listingDiscountAutomatic = [];

  @override
  void onInit() async {
    fetchingDiscount();
    await settingsController.fetchingUser();
    _user = settingsController.userModel;
    super.onInit();
  }

  fetchingDiscount() async {
    _loading.value = true;
    update();

    var result = await DiscountProvider().getDiscount();
    _discount = [];
    if (result != null) {
      for (final x in result['discountNodes']['edges']) {
        if (x['node']['discount']['__typename'] == 'DiscountCodeBasic') {
          if (x['node']['discount']['customerSelection']['__typename'] ==
              'DiscountCustomers') {
            var check = x['node']['discount']['customerSelection']['customers']
                .where((e) => e['email'] == _user.email);

            if (check.isNotEmpty) {
              _discount.add(Discount.fromJson(x['node']['discount']));
            }
          } else {
            _discount.add(Discount.fromJson(x['node']['discount']));
          }
        }
      }
    }
    _loading.value = false;
    update();
  }

  Future<void> getDiscountAutomatic() async {
    var result = await DiscountProvider().getDiscountAutomatic();
    _discountAutomatic = [];
    if (result != null) {
      for (final x in result['automaticDiscountNodes']['edges']) {
        if (x['node']['automaticDiscount']["discountClass"] == "PRODUCT") {
          _discountAutomatic
              .add(DiscountAutomatic.fromJson(x['node']['automaticDiscount']));
        }
      }
    }
  }

  Future<void> groupingDiscountAutomatic(List<String>? idCollection) async {
    await homeController.fetchData();
    listingDiscountAutomatic = homeController.announcementProduct;

    await getDiscountAutomatic();

    int index = -1;

    for (final x in idCollection!) {
      for (final discount in _discountAutomatic) {
        index = (discount.collections!.indexWhere((e) => e.id == x));
        if (index >= 0) {
          Announcement tempData = Announcement(
              "https://widget.delamibrands.com/colorbox/mobile/icons/badge-percent.svg",
              discount.title);
          listingDiscountAutomatic.add(tempData);
        }
      }

      // index = (_discountAutomatic[0].collections!.indexWhere((e) => e.id == x));
      // if (index >= 0) break;
    }

    // if (_discountAutomatic.isNotEmpty && index >= 0) {
    //   Announcement tempData = Announcement(
    //       "https://widget.delamibrands.com/colorbox/mobile/icons/badge-percent.svg",
    //       _discountAutomatic[index].title);
    //   listingDiscountAutomatic.add(tempData);
    // }

    // if (index < 0) return null;

    // return {
    //   "idCollection": _discountAutomatic[0].collections![index].id,
    //   "titlePromo": _discountAutomatic[index].title
    // };
  }
}

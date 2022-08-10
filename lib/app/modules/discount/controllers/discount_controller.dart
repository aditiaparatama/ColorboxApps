import 'package:colorbox/app/modules/discount/models/discount_model.dart';
import 'package:colorbox/app/modules/discount/providers/discount_provider.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class DiscountController extends GetxController {
  ValueNotifier get loading => _loading;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  List<Discount> _discount = [];
  List<Discount> get discount => _discount;
  final UserModel _user = Get.find<SettingsController>().userModel;

  @override
  void onInit() {
    fetchingDiscount();
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
}

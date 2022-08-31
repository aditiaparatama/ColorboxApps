import 'package:colorbox/app/data/models/mailing_address.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/cart/models/cart_model.dart';
import 'package:colorbox/app/modules/checkout/models/checkout_model.dart';
import 'package:colorbox/app/modules/checkout/providers/checkout_provider.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/profile/providers/profile_provider.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CheckoutController extends GetxController {
  final LocalStorageData localStorageData = Get.find();
  ValueNotifier get loading => _loading;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  CustomerToken? _token = CustomerToken.isEmpty();
  String? _idCheckout;
  String? get idCheckout => _idCheckout;
  String? _etd;
  String? get etd => _etd;
  UserModel _user = UserModel.isEmpty();
  UserModel get user => _user;
  CheckoutModel _checkout = CheckoutModel.isEmpty();
  CheckoutModel get checkout => _checkout;
  dynamic _listShipping;
  dynamic get listShipping => _listShipping;

  final Cart _cart = Get.find<CartController>().cart;

  @override
  void onInit() async {
    await getAddress();
    // await createCheckout();
    _idCheckout =
        "gid://shopify/Checkout/75887dad2980edf3cd942d0eb6418bbb?key=69a8decee72afb8b9f950b7a69a12d73";
    await getCheckout();
    await getETDShipping();
    super.onInit();
  }

  Future<void> getAddress() async {
    _loading.value = true;
    update();
    _token = await localStorageData.getTokenUser;
    var result = await ProfileProvider().getUser(_token!.accessToken!);
    _user = UserModel.fromJson(result);
    _loading.value = false;
    update();
  }

  createCheckout() async {
    List<CheckoutItems>? items = await getItems();

    //buat varibles input checkout
    dynamic variable = {
      "input": {
        "allowPartialAddresses": true,
        "buyerIdentity": {"countryCode": _user.defaultAddress!.countryCodeV2},
        "email": _user.email,
        "lineItems": [
          for (final x in items) ...[
            {"quantity": x.quantity, "variantId": x.variantId}
          ]
        ],
        "shippingAddress": {
          "address1": _user.defaultAddress!.address1,
          "address2": _user.defaultAddress!.address2,
          "city": _user.defaultAddress!.city,
          "company": _user.defaultAddress!.company,
          "country": _user.defaultAddress!.country,
          "firstName": _user.defaultAddress!.firstName,
          "lastName": _user.defaultAddress!.lastName,
          "phone": _user.defaultAddress!.phone,
          "province": _user.defaultAddress!.province,
          "zip": _user.defaultAddress!.zip
        }
      },
    };

    //create checkout
    var result = await CheckoutProvider().checkoutCreate(items, variable);
    if (result != null) {
      _idCheckout = result['checkoutCreate']['checkout']['id'];

      var result2 = await CheckoutProvider()
          .checkoutGetData(result['checkoutCreate']['checkout']['id']);

      //check kalo shipping rates nya masih null akan looping
      while (result2['node']['availableShippingRates']['ready'] == false) {
        result2 = await Future.delayed(
            const Duration(milliseconds: 1000),
            () => CheckoutProvider()
                .checkoutGetData(result['checkoutCreate']['checkout']['id']));
      }

      //update shipping rates
      var resultShipping = await updateShippingRates(
          result['checkoutCreate']['checkout']['id'],
          result2['node']['availableShippingRates']['shippingRates'][0]
              ['handle']);

      if (result2 != null) {
        _checkout = CheckoutModel.fromJson(
            resultShipping['checkoutShippingLineUpdate']['checkout']);
      }

      //update voucher dicheckout kalo sudah digunakan di cart
      if (_cart.discountCodes!.isNotEmpty &&
          _cart.discountCodes![0].code != "") {
        await applyVoucher(_cart.discountCodes![0].code!, back: false);
      }
    }
    update();
  }

  Future<List<CheckoutItems>> getItems() async {
    List<CheckoutItems>? items = [];
    for (int i = 0; i < _cart.lines!.length; i++) {
      items.add(CheckoutItems.setItems(_cart.lines![i]));
    }

    return items;
  }

  Future<void> getCheckout() async {
    var result = await CheckoutProvider().checkoutGetData(_idCheckout!);
    if (result != null) {
      _checkout = CheckoutModel.fromJson(result['node']);
    }
    update();
  }

  Future<void> getETDShipping() async {
    if (_user.defaultAddress!.address1 != null) {
      var x = _checkout.toJson();
      _listShipping = await CheckoutProvider().getShippingRates(x);
      _listShipping = _listShipping.firstWhere(
          (e) => e['service_name'] == _checkout.shippingLine!.title);
      _etd = _listShipping['description'].split("(")[0];
    }
    update();
  }

  Future<dynamic> updateShippingRates(id, handle) async {
    return await CheckoutProvider().checkoutShippingLineUpdate(id, handle);
  }

  updateShipping(String handle) async {
    _loading.value = true;
    update();
    var resultShipping = await CheckoutProvider()
        .checkoutShippingLineUpdate(_idCheckout!, handle);
    if (resultShipping != null) {
      _checkout = CheckoutModel.fromJson(
          resultShipping['checkoutShippingLineUpdate']['checkout']);
    }
    _loading.value = false;
    update();
    Get.back();
    Get.snackbar("Info", "Data berhasil diubah",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.black);
  }

  updateShippingAddress(MailingAddress address) async {
    _loading.value = true;
    update();
    var result = await CheckoutProvider()
        .checkoutShippingAddressUpdateV2(_idCheckout!, address);
    if (result != null) {
      if (result['checkoutShippingAddressUpdateV2']['checkout']
              ['shippingLine'] ==
          null) {
        await reloadShippingRates(
            result['checkoutShippingAddressUpdateV2']['checkout']['id']);
      } else {
        _checkout = CheckoutModel.fromJson(
            result['checkoutShippingAddressUpdateV2']['checkout']);
      }

      _loading.value = false;
    }
    update();
  }

  Future<void> reloadShippingRates(String id) async {
    var result2 = await Future.delayed(const Duration(milliseconds: 1000),
        () => CheckoutProvider().checkoutGetData(id));

    for (int x = 0; x < 3; x++) {
      if (result2['node']['availableShippingRates']['ready'] == false ||
          result2['node']['availableShippingRates']['shippingRates'].length ==
              0) {
        result2 = await Future.delayed(const Duration(milliseconds: 1000),
            () => CheckoutProvider().checkoutGetData(id));
      }
    }

    if (result2['node']['availableShippingRates']['ready'] == false ||
        result2['node']['availableShippingRates']['shippingRates'].length ==
            0) {
      _checkout = CheckoutModel.fromJson(result2['node']);
      Get.snackbar(
        "Info",
        "Kode Pos tidak ditemukan",
        backgroundColor: Colors.black87,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      var resultShipping = await updateShippingRates(
          id,
          result2['node']['availableShippingRates']['shippingRates'][0]
              ['handle']);

      if (resultShipping != null) {
        _checkout = CheckoutModel.fromJson(
            resultShipping['checkoutShippingLineUpdate']['checkout']);
      }

      update();
    }
  }

  Future<void> applyVoucher(String discountCode, {bool back = true}) async {
    var result = await CheckoutProvider().checkoutDiscountCodeApplyV2(
        id: _idCheckout!, discountCode: discountCode);
    if (result['checkoutDiscountCodeApplyV2']['checkoutUserErrors'].length >
        0) {
      Get.snackbar(
          "Alert",
          result['checkoutDiscountCodeApplyV2']['checkoutUserErrors'][0]
              ['message'],
          backgroundColor: Colors.black,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    _checkout = CheckoutModel.fromJson(
        result['checkoutDiscountCodeApplyV2']['checkout']);
    update();
    if (back) Get.back();
    Get.snackbar("Info", "Voucher berhasil digunakan",
        backgroundColor: Colors.black,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM);
  }

  removeVoucher() async {
    _loading.value = true;
    update();
    var result =
        await CheckoutProvider().checkoutDiscountCodeRemove(id: _idCheckout!);
    _checkout = CheckoutModel.fromJson(
        result['checkoutDiscountCodeRemove']['checkout']);
    _loading.value = false;
    update();
  }
}

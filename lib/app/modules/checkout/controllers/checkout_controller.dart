import 'package:colorbox/app/data/models/mailing_address.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/cart/models/cart_model.dart';
import 'package:colorbox/app/modules/checkout/models/checkout_model.dart';
import 'package:colorbox/app/modules/checkout/providers/checkout_provider.dart';
import 'package:colorbox/app/modules/checkout/providers/draft_order_provider.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/profile/providers/profile_provider.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    await createCheckout();
    // _idCheckout =
    //     "gid://shopify/Checkout/63841f1aba2db5781bf989ad1b266aaa?key=6516de972e56a147e31f56d37b86b15a";
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
        backgroundColor: colorTextBlack);
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
        backgroundColor: colorTextBlack,
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
          backgroundColor: colorTextBlack,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    _checkout = CheckoutModel.fromJson(
        result['checkoutDiscountCodeApplyV2']['checkout']);
    update();
    if (back) Get.back();
    Get.snackbar("Info", "Voucher berhasil digunakan",
        backgroundColor: colorTextBlack,
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

  Future<String> createOrder() async {
    String draftOrderId = await createDraftOrder();
    dynamic order = await completeDraftOrder(draftOrderId);
    String urlInvoice = await paymentCheckout(order);

    updateOrderForUrlPayment(order['id'], urlInvoice);

    return urlInvoice;
  }

  Future<String> paymentCheckout(order) async {
    String createdDate = DateFormat("yyyyMMddHHmmss")
        .format(DateTime.parse(_checkout.createdAt!));
    String phone = _checkout.shippingAddress!.phone!;
    if (_checkout.shippingAddress!.phone!.substring(0, 2) == "08") {
      phone = "+62" +
          _checkout.shippingAddress!.phone!
              .substring(1, _checkout.shippingAddress!.phone!.length - 1);
    }

    var inputData = {
      "external_id":
          "shopifyInvoice-$createdDate-${order['name']}-${order['id'].replaceAll('gid://shopify/Order/', '')}",
      "amount": int.parse(_checkout.totalPriceV2!.replaceAll(".0", "")),
      "payer_email": _checkout.email,
      "description": "Invoice Customer ${_checkout.shippingAddress!.firstName}",
      "items": [
        for (final x in _checkout.lineItems!) ...[
          {
            "name": x.title,
            "quantity": x.quantity,
            "price": (x.discountAllocations!.isEmpty)
                ? x.variants!.price
                : (double.parse(x.variants!.price!.replaceAll(".00", ""))
                        .ceil() -
                    double.parse(x.discountAllocations![0].allocatedAmount!
                            .replaceAll(".0", ""))
                        .ceil())
          }
        ]
      ],
      "customer": {
        "given_names": _checkout.shippingAddress!.firstName,
        "surname": _checkout.shippingAddress!.lastName,
        "email": _checkout.email,
        "mobile_number": phone
      },
      'customer_notification_preference': {
        'invoice_created': ['whatsapp', 'email'],
        'invoice_reminder': ['whatsapp', 'email'],
        'invoice_paid': ['whatsapp', 'email']
      }
    };

    var result = await CheckoutProvider().createInvoice(inputData);

    return result["invoice_url"];
  }

  Future<String> createDraftOrder() async {
    var variableInput = {
      "input": {
        if (_checkout.discountApplications != null)
          "appliedDiscount": {
            "amount": _checkout.discountApplications!.amount,
            "description": _checkout.discountApplications!.code,
            "title": _checkout.discountApplications!.code,
            "value": (_checkout.discountApplications!.amount != null)
                ? double.parse(_checkout.discountApplications!.amount!)
                : double.parse(_checkout.discountApplications!.percentage!),
            "valueType": (_checkout.discountApplications!.amount != null)
                ? "FIXED_AMOUNT"
                : "PERCENTAGE"
          },
        "customerId": _user.id,
        "email": _user.email,
        "lineItems": [
          for (final x in _checkout.lineItems!) ...[
            {
              // if (x.discountAllocations != null &&
              //     x.discountAllocations![0].discountApplication!
              //             .allocationMethod !=
              //         "ACROSS")
              //   "appliedDiscount": {
              //     "amount": x.discountAllocations![0].allocatedAmount,
              //     "description": "",
              //     "title": x.discountAllocations![0].discountApplication,
              //     "value": 1.1,
              //     "valueType": "FIXED_AMOUNT"
              //   },
              "originalUnitPrice": x.variants!.price,
              "quantity": x.quantity,
              "requiresShipping": true,
              "sku": x.variants!.sku,
              "taxable": false,
              "title": x.title,
              "variantId": x.variants!.id,
              "weight": {
                "unit": x.variants!.weightUnit,
                "value": x.variants!.weight
              }
            },
          ]
        ],
        "note": "",
        "shippingAddress": {
          "address1": _checkout.shippingAddress!.address1,
          "address2": _checkout.shippingAddress!.address2,
          "city": _checkout.shippingAddress!.city,
          "company": _checkout.shippingAddress!.company,
          "country": _checkout.shippingAddress!.country,
          "firstName": _checkout.shippingAddress!.firstName,
          "lastName": _checkout.shippingAddress!.lastName,
          "phone": _checkout.shippingAddress!.phone,
          "province": _checkout.shippingAddress!.province,
          "zip": _checkout.shippingAddress!.zip
        },
        "shippingLine": {
          "price": _checkout.shippingLine!.amount,
          "shippingRateHandle": _checkout.shippingLine!.handle,
          "title": _checkout.shippingLine!.title
        },
        "sourceName": "mobile_apps",
        "tags": ["apps"],
        "taxExempt": false,
        "useCustomerDefaultAddress": true
      }
    };

    var result = await DraftOrderProvider().draftOrderCreate(variableInput);

    return result["draftOrderCreate"]["draftOrder"]["id"];
  }

  Future<dynamic> completeDraftOrder(String draftOrderId) async {
    var variableInput = {"id": draftOrderId};

    var result = await DraftOrderProvider().draftOrderComplete(variableInput);

    return result["draftOrderComplete"]["draftOrder"]["order"];
  }

  updateOrderForUrlPayment(String orderId, String urlInvoice) async {
    var variableInput = {
      "input": {"id": orderId, "note": urlInvoice}
    };

    await DraftOrderProvider().orderUpdateUrl(variableInput);
  }
}

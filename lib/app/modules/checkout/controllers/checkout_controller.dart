import 'dart:async';
import 'package:colorbox/app/data/models/mailing_address.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/cart/models/cart_model.dart';
import 'package:colorbox/app/modules/checkout/models/checkout_model.dart';
import 'package:colorbox/app/modules/checkout/providers/checkout_provider.dart';
import 'package:colorbox/app/modules/checkout/providers/draft_order_provider.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/profile/providers/profile_provider.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:flutter_svg/svg.dart';
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
  bool outCoverageArea = false;

  final Cart _cart = Get.find<CartController>().cart;
  double? discountAmount;
  bool checkoutTap = false;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void onInit() async {
    // initConnectivity();

    // _connectivitySubscription =
    //     _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    await getAddress();

    await createCheckout();
    Smartlook.instance.trackEvent('CheckOut');

    // _idCheckout =
    //     "gid://shopify/Checkout/00205c3b14749fcfc655535d3a9178c6?key=dea4c8ee79d214634c9bbab79e6ad0b6";
    // getCheckout();

    super.onInit();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status $e');
      return;
    }

    debugPrint(result.name);

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    _connectionStatus = result;
  }

  Future<void> getAddress() async {
    _loading.value = true;
    update();
    _token = await localStorageData.getTokenUser;
    var result = await ProfileProvider().getUserFromAdmin(_token!.id!);
    _user = UserModel.fromAdmin(result);

    _loading.value = false;
    update();
  }

  createCheckout() async {
    int looping = 0;
    while (_user.addresses!.isEmpty) {
      if (looping == 7) break;
      await getAddress();
      looping++;
    }

    List<CheckoutItems>? items = await getItems();

    //buat varibles input checkout
    dynamic variable = {
      "input": {
        // "allowPartialAddresses": true,
        // "buyerIdentity": {"countryCode": _user.defaultAddress!.countryCodeV2},
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
          "lastName": (_user.defaultAddress!.lastName != null ||
                  _user.defaultAddress!.lastName == "")
              ? _user.defaultAddress!.firstName
              : _user.defaultAddress!.lastName,
          "phone": _user.defaultAddress!.phone,
          "province": _user.defaultAddress!.province,
          "zip": _user.defaultAddress!.zip
        }
      },
    };

    //create checkout
    var result = await CheckoutProvider().checkoutCreate(items, variable);

    if (result['checkoutCreate']['checkoutUserErrors'].isNotEmpty) {
      Get.back();
      Get.showSnackbar(GetSnackBar(
        borderRadius: 4.0,
        backgroundColor: colorNeutral100.withOpacity(0.75),
        margin: const EdgeInsets.only(bottom: 104, left: 16, right: 16),
        messageText: const CustomText(
          text: "Terjadi kesalahan, mohon periksa data kembali",
          fontSize: 12,
          color: Color(0xFFF1F1F1),
        ),
        duration: const Duration(milliseconds: 1500),
      ));
      return;
    }
    if (result != null) {
      _idCheckout = result['checkoutCreate']['checkout']['id'];
      _checkout = CheckoutModel.fromJson(result['checkoutCreate']['checkout']);

      //update voucher dicheckout kalo sudah digunakan di cart
      if (_cart.discountCodes!.isNotEmpty &&
          _cart.discountCodes![0].code != "" &&
          _cart.discountCodes![0].applicable!) {
        await applyVoucher(_cart.discountCodes![0].code!, back: false);
      }
      calculateLineItem();
    }

    if (result == null) {
      Get.back();
      Get.snackbar("Peringatan", "Terjadi kesalahan server, mohon coba kembali",
          backgroundColor: colorTextBlack,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    update();
  }

  Future<List<CheckoutItems>> getItems() async {
    List<CheckoutItems>? items = [];
    for (int i = 0; i < _cart.lines!.length; i++) {
      if (_cart.lines![i].merchandise!.inventoryQuantity! > 0) {
        items.add(CheckoutItems.setItems(_cart.lines![i]));
      }
    }

    return items;
  }

  Future<void> getCheckout() async {
    loading.value = true;
    update();
    int looping = 0;
    var result = await CheckoutProvider().checkoutGetData(_idCheckout!);
    if (result != null) {
      // check kalo shipping rates nya masih null akan looping
      while (result['node']['availableShippingRates']['ready'] == false ||
          result['node']['availableShippingRates']['shippingRates'] == null) {
        result = await Future.delayed(const Duration(milliseconds: 300),
            () => CheckoutProvider().checkoutGetData(_idCheckout!));
        if (looping >= 5) {
          outCoverageArea = false;
          break;
        }
        looping += 1;
      }
      _checkout = CheckoutModel.fromJson(result['node']);
      calculateLineItem();
    }

    if (_etd == null) {
      await getETDShipping();
    }
    loading.value = false;
    update();
  }

  Future<void> getETDShipping() async {
    if (_user.defaultAddress!.address1 != null &&
        _checkout.availableShippingRates != null &&
        _checkout.availableShippingRates!.shippingRates != null) {
      var x = _checkout.toJson();
      _listShipping = await CheckoutProvider().getShippingRates(x);

      for (int i = 0;
          i < _checkout.availableShippingRates!.shippingRates!.length;
          i++) {
        int x = _listShipping.indexWhere((e) =>
            e["service_name"]
                .split("(")[0]
                .replaceAll(" ", "")
                .replaceAll("(", "") ==
            _checkout.availableShippingRates!.shippingRates![i].title!
                .split("(")[0]
                .replaceAll(" ", "")
                .replaceAll("(", ""));

        _checkout.availableShippingRates!.shippingRates![i].etd =
            _listShipping[x]['description'].split("(")[0];

        _etd = _listShipping[x]['description'].split("(")[0];
      }
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
    calculateLineItem();
    update();
    Get.back();
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
    calculateLineItem();
    update();
  }

  Future<void> reloadShippingRates(String id) async {
    var result2 = await CheckoutProvider().checkoutGetData(id);

    for (int x = 0; x < 3; x++) {
      if (result2['node']['availableShippingRates']['ready'] == false ||
          result2['node']['availableShippingRates']['shippingRates'] == null) {
        result2 = await Future.delayed(const Duration(milliseconds: 300),
            () => CheckoutProvider().checkoutGetData(id));
      }
    }

    if (result2['node']['availableShippingRates']['ready'] == false ||
        result2['node']['availableShippingRates']['shippingRates'].length ==
            0) {
      _checkout = CheckoutModel.fromJson(result2['node']);
      Get.showSnackbar(GetSnackBar(
        borderRadius: 4.0,
        backgroundColor: colorNeutral100.withOpacity(0.75),
        margin: const EdgeInsets.only(bottom: 104, left: 16, right: 16),
        messageText: const CustomText(
          text: "Kode Pos tidak ditemukan",
          fontSize: 12,
          color: Color(0xFFF1F1F1),
        ),
        duration: const Duration(milliseconds: 1000),
      ));
    } else {
      var resultShipping = await updateShippingRates(
          id,
          result2['node']['availableShippingRates']['shippingRates'][0]
              ['handle']);

      if (resultShipping != null) {
        _checkout = CheckoutModel.fromJson(
            resultShipping['checkoutShippingLineUpdate']['checkout']);
        // getCheckout();
        calculateLineItem();
      }

      update();
    }
  }

  Future<void> applyVoucher(String discountCode, {bool back = true}) async {
    var result = await CheckoutProvider().checkoutDiscountCodeApplyV2(
        id: _idCheckout!, discountCode: discountCode);
    if (result['checkoutDiscountCodeApplyV2']['checkoutUserErrors'].length >
        0) {
      String msg = result['checkoutDiscountCodeApplyV2']['checkoutUserErrors']
          [0]['message'];

      if (result['checkoutDiscountCodeApplyV2']['checkoutUserErrors'][0]
              ["code"] ==
          "HIGHER_VALUE_DISCOUNT_APPLIED") {
        msg =
            "Discount yang berjalan lebih besar nilanya dari voucher yang dipilih";
      } else if (msg == "This discount has reached its usage limit") {
        msg = "Voucher sudah pernah digunakan";
      }

      Get.snackbar("Peringatan", msg,
          backgroundColor: colorTextBlack,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    _checkout = CheckoutModel.fromJson(
        result['checkoutDiscountCodeApplyV2']['checkout']);
    calculateLineItem();
    update();
    if (back) {
      Get.back();
      Get.snackbar("Info", "Voucher berhasil digunakan",
          backgroundColor: colorTextBlack,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  removeVoucher() async {
    _loading.value = true;
    update();
    var result =
        await CheckoutProvider().checkoutDiscountCodeRemove(id: _idCheckout!);
    _checkout = CheckoutModel.fromJson(
        result['checkoutDiscountCodeRemove']['checkout']);
    calculateLineItem();
    _loading.value = false;
    update();
  }

  Future<String?> createOrder() async {
    // String draftOrderId = await createDraftOrder();
    // dynamic order = await completeDraftOrder(draftOrderId);
    // _loading.value = true;
    checkoutTap = true;
    update();

    await getCheckout();

    for (CheckoutLineItem x in _checkout.lineItems ?? []) {
      if ((x.variants!.inventoryQuantity ?? 1) <= 0) {
        checkoutTap = false;
        update();
        return "stok-habis";
      }
    }

    dynamic order = await pesan();
    if (order != null && order.containsKey("order")) {
      if (_checkout.shippingLine!.title!.contains("COD")) {
        Get.find<CartController>().reCreateCart();
        return "COD";
      }

      String? urlInvoice =
          await paymentCheckout(order["order"]['name'], order["order"]['id']);

      updateOrderForUrlPayment(
          order['order']['admin_graphql_api_id'], urlInvoice);
      Get.find<CartController>().reCreateCart();
      Get.find<CartController>().getCart2();

      return urlInvoice;
    } else if (order != null && order.containsKey("draft_order")) {
      dynamic result = await completeDraftOrder(
          "gid://shopify/DraftOrder/${order["draft_order"]["id"]}");

      if (_checkout.shippingLine!.title!.contains("COD")) {
        Get.find<CartController>().reCreateCart();
        return "COD";
      }

      String? urlInvoice = await paymentCheckout(
          result["name"], result["id"].replaceAll("gid://shopify/Order/", ""));

      updateOrderForUrlPayment(result["id"], urlInvoice);
      Get.find<CartController>().reCreateCart();

      return urlInvoice;
    }

    if (order != null &&
        order["errors"]["line_items"][0] == "Unable to reserve inventory") {
      checkoutTap = false;
      update();
      return "stok-habis";
    } else {
      Get.snackbar("", "Pesanan Gagal dibuat",
          titleText: Row(
            children: [
              SvgPicture.asset(
                "assets/icon/Exclamation-Circle.svg",
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              const CustomText(
                text: "Gagal",
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ],
          ),
          backgroundColor: colorTextBlack,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }

    checkoutTap = false;
    update();
    return "";
  }

  Future<String> paymentCheckout(orderNo, orderId) async {
    String createdDate = DateFormat("yyyyMMddHHmmss")
        .format(DateTime.parse(_checkout.createdAt!));
    String phone = _checkout.shippingAddress!.phone!;
    if (_checkout.shippingAddress!.phone!.substring(0, 2) == "08") {
      phone = "+62" +
          _checkout.shippingAddress!.phone!
              .substring(1, _checkout.shippingAddress!.phone!.length - 1);
    }

    var inputData = {
      "external_id": "shopifyInvoice-$createdDate-$orderNo-$orderId",
      "amount": double.parse(_checkout.totalPriceV2!).round(),
      "payer_email": _checkout.email,
      "description": "Invoice Customer ${_checkout.shippingAddress!.firstName}",
      "items": [
        for (final x in _checkout.lineItems!) ...[
          {
            "name": x.title,
            "quantity": x.quantity,
            "price": (x.discountAllocations!.isEmpty)
                ? x.variants!.price
                : (double.parse(x.variants!.price!).ceil() -
                    double.parse(x.discountAllocations![0].allocatedAmount!)
                        .ceil())
          }
        ]
      ],
      "customer": {
        "given_names": _checkout.shippingAddress!.firstName,
        "surname": (_checkout.shippingAddress!.lastName == null ||
                _checkout.shippingAddress!.lastName == "")
            ? _checkout.shippingAddress!.firstName
            : _checkout.shippingAddress!.lastName,
        "email": _checkout.email,
        "mobile_number": phone
      },
      'customer_notification_preference': {
        'invoice_created': ['email'],
        'invoice_reminder': ['email'],
        'invoice_paid': ['email']
      }
    };

    var result = await CheckoutProvider().createInvoice(inputData);

    return result["invoice_url"];
  }

  Future<String> createDraftOrder() async {
    var variableInput = {
      "input": {
        if (_checkout.discountApplications != null &&
            _checkout.discountApplications!.isNotEmpty)
          "appliedDiscount": {
            "amount": _checkout.discountApplications![0].amount,
            "description": _checkout.discountApplications![0].code,
            "title": _checkout.discountApplications![0].code,
            "value": (_checkout.discountApplications![0].amount != null)
                ? double.parse(_checkout.discountApplications![0].amount!)
                : double.parse(_checkout.discountApplications![0].percentage!),
            "valueType": (_checkout.discountApplications![0].amount != null)
                ? "FIXED_AMOUNT"
                : "PERCENTAGE"
          },
        "customerId": _user.id,
        "email": _user.email,
        "lineItems": [
          for (final x in _checkout.lineItems!) ...[
            {
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

  Future<dynamic> pesan() async {
    dynamic createOrder;

    if (_checkout.discountApplications != null &&
        _checkout.discountApplications!.isNotEmpty &&
        (_checkout.discountApplications![0].code != null ||
            _checkout.discountApplications![0].code != "") &&
        _checkout.discountApplications![0].typename ==
            "DiscountCodeApplication") {
      createOrder = pesananDenganDiskonCode();
      return await DraftOrderProvider().orderCreate(createOrder);
    }
    if (_checkout.discountApplications != null &&
        _checkout.discountApplications!.isNotEmpty &&
        (_checkout.discountApplications![0].code != null ||
            _checkout.discountApplications![0].code != "") &&
        _checkout.discountApplications![0].targetType == "LINE_ITEM" &&
        _checkout.discountApplications![0].targetSelection == "ENTITLED") {
      createOrder = pesananDenganDiscountLineItems();
      return await DraftOrderProvider()
          .orderCreate(createOrder, path: "draft_orders.json");
    } else {
      createOrder = pesananDenganDiskonCode();
    }
    return await DraftOrderProvider().orderCreate(createOrder);
  }

  dynamic pesananDenganDiscountLineItems() {
    var _lineItems = [];
    double totalWeight = 0;

    for (final x in _checkout.lineItems!) {
      totalWeight += x.variants!.weight ?? 0;
      if (x.discountAllocations != null &&
          x.discountAllocations!.isNotEmpty &&
          double.parse(x.discountAllocations![0].allocatedAmount!) > 0) {
        _lineItems.add({
          "variant_id":
              x.variants!.id!.replaceAll("gid://shopify/ProductVariant/", ""),
          "quantity": x.quantity,
          "grams": (x.variants!.weight! *
                  (x.variants!.weightUnit == "KILOGRAMS" ? 1000 : 1))
              .round(),
          "applied_discount": {
            "description":
                (x.discountAllocations![0].discountApplication!.typename ==
                        "AutomaticDiscountApplication")
                    ? "automatic"
                    : "discount code",
            "value_type": (x.discountAllocations![0].discountApplication!
                            .percentage ==
                        null ||
                    x.discountAllocations![0].discountApplication!.percentage ==
                        "0.0")
                ? "fixed_amount"
                : "percentage",
            "value": (x.discountAllocations![0].discountApplication!
                            .percentage ==
                        null ||
                    x.discountAllocations![0].discountApplication!.percentage ==
                        "0.0")
                ? x.discountAllocations![0].allocatedAmount
                : x.discountAllocations![0].discountApplication!.percentage,
            "title": _checkout.discountApplications![0].title ??
                _checkout.discountApplications![0].code
          }
        });
      } else {
        _lineItems.add({
          "variant_id":
              x.variants!.id!.replaceAll("gid://shopify/ProductVariant/", ""),
          "quantity": x.quantity,
          "grams": (x.variants!.weight! *
                  (x.variants!.weightUnit == "KILOGRAMS" ? 1000 : 1))
              .round()
        });
      }
    }

    String? lastName = (_checkout.shippingAddress!.lastName == "" ||
            _checkout.shippingAddress!.lastName == null)
        ? _checkout.shippingAddress!.firstName
        : _checkout.shippingAddress!.lastName;

    var createOrder = {
      "draft_order": {
        "email": _user.email,
        "tags": (_checkout.shippingLine!.title!.contains("COD"))
            ? "apps_cod"
            : "apps",
        "line_items": _lineItems,
        "total_weight": totalWeight,
        "shipping_line": {
          "title": _checkout.shippingLine!.title,
          "price": _checkout.shippingLine!.amount ?? 0,
          "source": _checkout.shippingLine!.handle,
        },
        "billing_address": {
          "first_name": _checkout.shippingAddress!.firstName,
          "address1": _checkout.shippingAddress!.address1,
          "phone": _checkout.shippingAddress!.phone,
          "city": _checkout.shippingAddress!.city,
          "zip": _checkout.shippingAddress!.zip,
          "province": _checkout.shippingAddress!.province,
          "country": _checkout.shippingAddress!.country,
          "last_name": lastName,
          "address2": _checkout.shippingAddress!.address2,
          "company": "",
          "latitude": null,
          "longitude": null,
          "name": "${_checkout.shippingAddress!.firstName} $lastName",
          "country_code": "ID",
          "province_code": _checkout.shippingAddress!.province
        },
        "shipping_address": {
          "first_name": _checkout.shippingAddress!.firstName,
          "address1": _checkout.shippingAddress!.address1,
          "phone": _checkout.shippingAddress!.phone,
          "city": _checkout.shippingAddress!.city,
          "zip": _checkout.shippingAddress!.zip,
          "province": _checkout.shippingAddress!.province,
          "country": _checkout.shippingAddress!.country,
          "last_name": _checkout.shippingAddress!.lastName,
          "address2": _checkout.shippingAddress!.address2,
          "company": "",
          "latitude": null,
          "longitude": null,
          "name": "${_checkout.shippingAddress!.firstName} $lastName",
          "country_code": "ID",
          "province_code": _checkout.shippingAddress!.province
        }
      }
    };

    return createOrder;
  }

  dynamic pesananDenganDiskonCode() {
    var _lineItems = [];

    double totalWeight = 0;

    for (final x in _checkout.lineItems!) {
      _lineItems.add({
        "variant_id":
            x.variants!.id!.replaceAll("gid://shopify/ProductVariant/", ""),
        "quantity": x.quantity,
        "grams": x.variants!.weight! *
            (x.variants!.weightUnit == "KILOGRAMS" ? 1000 : 1)
      });
      totalWeight += x.variants!.weight ?? 0;
    }

    String? lastName = (_checkout.shippingAddress!.lastName == "" ||
            _checkout.shippingAddress!.lastName == null)
        ? _checkout.shippingAddress!.firstName
        : _checkout.shippingAddress!.lastName;

    var createOrder = {
      "order": {
        "inventory_behaviour": "decrement_obeying_policy",
        "email": _user.email,
        "gateway": (_checkout.shippingLine!.title!.contains("COD"))
            ? "Cash on Delivery (COD)"
            : "Xendit Mobile",
        "send_receipt": true,
        "financial_status": "pending",
        "channel": "Mobile Apps",
        "payment_gateway_names":
            (_checkout.shippingLine!.title!.contains("COD"))
                ? ["Cash on Delivery (COD)"]
                : ["Xendit Payment Gateway (New)"],
        "tags": (_checkout.shippingLine!.title!.contains("COD"))
            ? ["apps", "apps_cod"]
            : "apps",
        "total_weight": totalWeight,
        "line_items": _lineItems,
        "shipping_lines": [
          {
            "title": _checkout.shippingLine!.title,
            "price": _checkout.shippingLine!.amount ?? 0,
            "code": "",
            "source": _checkout.shippingLine!.handle,
          }
        ],
        "billing_address": {
          "first_name": _checkout.shippingAddress!.firstName,
          "address1": _checkout.shippingAddress!.address1,
          "phone": _checkout.shippingAddress!.phone,
          "city": _checkout.shippingAddress!.city,
          "zip": _checkout.shippingAddress!.zip,
          "province": _checkout.shippingAddress!.province,
          "country": _checkout.shippingAddress!.country,
          "last_name": lastName,
          "address2": _checkout.shippingAddress!.address2,
          "company": "",
          "latitude": null,
          "longitude": null,
          "name": "${_checkout.shippingAddress!.firstName} $lastName",
          "country_code": "ID",
          "province_code": _checkout.shippingAddress!.province
        },
        "shipping_address": {
          "first_name": _checkout.shippingAddress!.firstName,
          "address1": _checkout.shippingAddress!.address1,
          "phone": _checkout.shippingAddress!.phone,
          "city": _checkout.shippingAddress!.city,
          "zip": _checkout.shippingAddress!.zip,
          "province": _checkout.shippingAddress!.province,
          "country": _checkout.shippingAddress!.country,
          "last_name": lastName,
          "address2": _checkout.shippingAddress!.address2,
          "company": "",
          "latitude": null,
          "longitude": null,
          "name": "${_checkout.shippingAddress!.firstName} $lastName",
          "country_code": "ID",
          "province_code": _checkout.shippingAddress!.province
        },
        if (_checkout.discountApplications != null &&
            _checkout.discountApplications!.isNotEmpty &&
            _checkout.discountApplications![0].code != "")
          "discount_codes": [
            for (final x in _checkout.discountApplications ?? []) ...[
              {
                "code": (x.typename == "AutomaticDiscountApplication")
                    ? x.title
                    : x.code,
                "amount": (x.amount != "0.0")
                    ? double.parse(x.amount!)
                    : double.parse(x.percentage!),
                "type": (x.amount != "0.0") ? "fixed_amount" : "percentage"
              }
            ]
          ]
      }
    };

    return createOrder;
  }

  void calculateLineItem() {
    discountAmount = null;
    for (CheckoutLineItem item in _checkout.lineItems ?? []) {
      final discountType = _checkout.discountApplications;

      double lineItemPrice =
          double.parse(item.variants!.price!.replaceAll(".00", ""));

      if (discountType != null &&
          item.discountAllocations!.isNotEmpty &&
          discountType[0].targetSelection != "ALL") {
        discountAmount = ((discountAmount == null) ? 0.0 : discountAmount!) +
            double.parse(item.discountAllocations![0].allocatedAmount!
                    .replaceAll(".0", ""))
                .round();
        lineItemPrice = lineItemPrice - discountAmount!;
      }

      if (discountType != null &&
          item.discountAllocations!.isNotEmpty &&
          discountType[0].targetSelection == "ALL") {
        discountAmount = ((discountAmount == null) ? 0.0 : discountAmount!) +
            double.parse(item.discountAllocations![0].allocatedAmount!
                    .replaceAll(".0", ""))
                .round();
      }
    }
  }
}

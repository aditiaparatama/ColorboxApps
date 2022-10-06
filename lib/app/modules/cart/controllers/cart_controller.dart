import 'package:colorbox/app/modules/cart/providers/cart_provider.dart';
import 'package:colorbox/app/modules/cart/models/cart_model.dart';
import 'package:colorbox/app/modules/discount/controllers/discount_controller.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

class CartController extends GetxController {
  final LocalStorageData localStorageData = Get.find();
  final DiscountController discountController = Get.put(DiscountController());
  ValueNotifier<bool> get loading => _loading;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  Cart _cart = Cart.empty();
  Cart get cart => _cart;
  ValueNotifier<bool> show = ValueNotifier(false);
  bool checkoutTap = false;

  String? _idCart;
  String? get idCart => _idCart;
  String? _checkoutUrl;
  String? get checkoutUrl => _checkoutUrl;
  int curIndex = 0;
  dynamic listHabis = [];
  bool appliedDiscount = false;
  List<DiscountRunning> discountRunning = [];

  @override
  void onInit() async {
    await getCart2();
    await discountController.getDiscountAutomatic();
    super.onInit();
  }

  Future<void> createCart() async {
    await getCartId();
    if (_idCart == null) {
      _idCart = await CartProvider().createCart();
      setCart(_idCart!);
      update();
    }
  }

  Future<void> reCreateCart() async {
    localStorageData.deleteCart();
    _idCart = await CartProvider().createCart();
    setCart(_idCart!);
    await getCart();
  }

  Future<void> getCart() async {
    if (_idCart != null) {
      var result = await CartProvider().getCart(_idCart!);
      _cart = Cart.fromJson(result["cart"]);
      update();
    }
  }

  Future<Cart> getCart2() async {
    appliedDiscount = false;
    await getCartId();
    if (_idCart != null) {
      var result = await CartProvider().getCart(_idCart!);
      while (result["cart"] == null) {
        await reCreateCart();
        result = await CartProvider().getCart(_idCart!);
      }
      _cart = Cart.fromJson(result["cart"]);
      update();
    } else {
      await createCart();
    }

    if (_cart.lines!.isNotEmpty) {
      listHabis = [];
      for (final x in _cart.lines ?? []) {
        if (x.merchandise!.inventoryQuantity! <= 0) {
          listHabis.add(x);
        }
      }
    }

    checkAppliedDiscount();
    update();
    return _cart;
  }

  Future<void> getCartId() async {
    await localStorageData.getCart.then((value) {
      _idCart = value;
    });
    update();
  }

  void setCart(String id) async {
    await localStorageData.setCart(id);
  }

  void addCart(String variantId, dynamic context, String ukuran) async {
    if (ukuran == '') {
      Get.snackbar(
        "Peringatan",
        "Silahkan pilih ukuran!",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: colorTextBlack,
        colorText: Colors.white,
      );
    } else {
      var result = await CartProvider().cartAdd(_idCart!, variantId);
      if (result["cartLinesAdd"]["userErrors"].length == 0) {
        showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            content: SvgPicture.asset("assets/icon/bx-addproduct.svg"),
          ),
        );
        Future.delayed(const Duration(seconds: 1), () {
          Get.back();
        });
      } else {
        Get.snackbar(
          "Peringatan",
          "Silahkan pilih warna produk!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: colorTextBlack,
          colorText: Colors.white,
        );
      }
    }

    await getCart2();
  }

  void updateCart(String variantId, String idLine, int qty) async {
    _loading.value = true;
    update();
    if (qty == 0) {
      await CartProvider().cartRemove(_idCart!, idLine);
    } else {
      await CartProvider().cartUpdate(_idCart!, variantId, idLine, qty);
    }
    _loading.value = false;
    await getCart2();
  }

  getCheckoutUrl() async {
    _checkoutUrl = await CartProvider().cartCheckout(_idCart!);
    while (_checkoutUrl == null) {
      _checkoutUrl = await CartProvider().cartCheckout(_idCart!);
    }
    update();
  }

  Future<void> updateDiscountCode(String code) async {
    _loading.value = true;
    update();
    var variables = {
      "cartId": idCart,
      "discountCodes": [code]
    };
    var result = await CartProvider().cartDiscountCodesUpdate(variables);
    if (result['cartDiscountCodesUpdate']['userErrors'].length >= 1) {
      Get.snackbar(
          "", result['cartDiscountCodesUpdate']['userErrors'][0]['message'],
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
    if (code != "" &&
        result['cartDiscountCodesUpdate']['cart']['discountCodes'][0]
                ['applicable'] ==
            false) {
      Get.snackbar("", "Kode Voucher tidak dapat digunakan",
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
    await getCart();
    _loading.value = false;
    update();
    if (code != "" &&
        result['cartDiscountCodesUpdate']['cart']['discountCodes'][0]
                ['applicable'] ==
            true) {
      Get.back();
      Get.snackbar("", "Voucher berhasil digunakan",
          titleText: Row(
            children: [
              SvgPicture.asset(
                "assets/icon/Check-Circle.svg",
                color: Colors.white,
              ),
              const SizedBox(width: 4),
              const CustomText(
                text: "Berhasil",
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
  }

  checkAppliedDiscount() {
    discountRunning = [];
    String? minQuantity, minSubtotal;
    int curQuantity = 0;
    double curSubtotal = 0;
    double totalDiscount = 0;
    bool applied = false;

    for (final x in discountController.discountAutomatic) {
      applied = false;
      curQuantity = 0;
      curSubtotal = 0;
      totalDiscount = 0;
      minQuantity = x.minimumRequirement!.greaterThanOrEqualToQuantity ?? "0";
      minSubtotal = x.minimumRequirement!.greaterThanOrEqualToSubtotal ?? "0";
      for (Line cartDiscount in _cart.lines ?? []) {
        if (x.title == cartDiscount.discountAllocations!.title &&
            cartDiscount.merchandise!.inventoryQuantity! > 0) {
          curQuantity = curQuantity + cartDiscount.quantity!;
          curSubtotal =
              curSubtotal + double.parse(cartDiscount.merchandise!.price!);
          totalDiscount = totalDiscount +
              double.parse(cartDiscount.discountAllocations!.amount!);
        }
      }

      if (x.minimumRequirement!.typename == "DiscountMinimumQuantity" &&
          (int.parse(minQuantity) <= curQuantity)) {
        applied = true;
      }

      if (x.minimumRequirement!.typename == "DiscountMinimumSubtotal" &&
          (double.parse(minSubtotal) <= curSubtotal)) {
        applied = true;
      }

      discountRunning.add(DiscountRunning(
          x.title,
          int.parse(minQuantity),
          double.parse(minSubtotal),
          applied,
          curQuantity,
          curSubtotal,
          totalDiscount));
    }
  }

  // cartUpdateIdentityCustomer(String token, UserModel user) async {
  //   var result =
  //       await CartProvider().cartBuyerIdentityupdate(_idCart!, token, user);
  // }
}

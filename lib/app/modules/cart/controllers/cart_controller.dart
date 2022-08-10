import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:colorbox/app/modules/cart/models/cart_model.dart';
import 'package:colorbox/app/modules/cart/providers/cart_provider.dart';
import 'package:colorbox/helper/local_storage_data.dart';

class CartController extends GetxController {
  final LocalStorageData localStorageData = Get.find();
  ValueNotifier<bool> get loading => _loading;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  Cart _cart = Cart.empty();
  Cart get cart => _cart;

  String? _idCart;
  String get idCart => _idCart!;
  String? _checkoutUrl;
  String? get checkoutUrl => _checkoutUrl;
  int curIndex = 0;

  @override
  void onInit() async {
    if (_cart.lines!.isEmpty) await getCart2();

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
    update();
  }

  Future<void> getCart() async {
    if (_idCart != null) {
      var result = await CartProvider().getCart(_idCart!);
      _cart = Cart.fromJson(result["cart"]);
      update();
    }
  }

  Future<Cart> getCart2() async {
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
        backgroundColor: Colors.black,
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
      } else {
        Get.snackbar(
          "Peringatan",
          "Silahkan pilih warna produk!",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          colorText: Colors.white,
        );
      }
    }

    await getCart();
  }

  void updateCart(String variantId, String idLine, int qty) async {
    _loading.value = true;
    update();
    if (qty == 0) {
      await CartProvider().cartRemove(_idCart!, idLine);
    } else {
      await CartProvider().cartUpdate(_idCart!, variantId, idLine, qty);
    }
    await getCart();
    _loading.value = false;
    update();
  }

  getCheckoutUrl() async {
    _checkoutUrl = await CartProvider().cartCheckout(_idCart!);
    while (_checkoutUrl == null) {
      _checkoutUrl = await CartProvider().cartCheckout(_idCart!);
    }
    update();
  }
}

import 'package:colorbox/app/modules/collections/models/product_model.dart';
import 'package:colorbox/app/modules/product/providers/product_providers.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/settings/controllers/settings_controller.dart';
import 'package:colorbox/app/modules/wishlist/models/wishlist_model.dart';
import 'package:colorbox/app/modules/wishlist/providers/wishlist_provider.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  final LocalStorageData localStorageData = Get.find();
  final SettingsController settingsController = Get.put(SettingsController());
  Wishlist _wishlist = Wishlist.empty();
  Wishlist get wishlist => _wishlist;
  ValueNotifier get loading => _loading;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  List<Product> _product = [];
  List<Product> _tempProduct = [];
  List<Product> get tempProduct => _tempProduct;
  List<Product> get product => _product;
  int _selected = 0;
  int get selected => _selected;
  String _tempColor = "";
  String _tempHandle = "";

  @override
  void onInit() async {
    // await fetchingData();
    await settingsController.getUser();
    super.onInit();
  }

  Future<void> fetchingData() async {
    _loading.value = true;
    update();
    UserModel? _user = settingsController.userModel;
    if (_user.id != null) {
      var result = await WhistlistProvider()
          .getAllData(_user.id!.replaceAll("gid://shopify/Customer/", ""));
      if (result != null && result.containsKey("items")) {
        _wishlist = Wishlist.fromJson(result);

        if (_wishlist.items.length > 0) {
          _product = [];
          var ids = [];
          var variantIds = [];
          for (final x in _wishlist.items) {
            ids.add('"gid://shopify/Product/${x['id']}"');
            variantIds.add(x['variant_id']);
          }
          await fetchingProduct({"ids": ids, "variantIds": variantIds});
        }
      }
    }
    _loading.value = false;
    _tempProduct = _product;
    update();
  }

  Future<void> fetchingNewData() async {
    _loading.value = true;
    update();
    UserModel? _user = settingsController.userModel;
    if (_user.id != null) {
      var result = await WhistlistProvider()
          .getAllDataNew(_user.id!.replaceAll("gid://shopify/Customer/", ""));
      if (result != null && result.containsKey("items")) {
        _wishlist = Wishlist.fromJson(result);

        if (_wishlist.items.length > 0) {
          _product = [];
          var ids = [];
          var variantIds = [];
          for (final x in _wishlist.items) {
            ids.add('"gid://shopify/Product/${x['product_id']}"');
            variantIds.add(x['variant_id']);
          }
          await fetchingProduct({"ids": ids, "variantIds": variantIds});
        }
      }
    }
    _loading.value = false;
    _tempProduct = _product;
    update();
  }

  Future<void> fetchWishlist() async {
    UserModel? _user = settingsController.userModel;
    if (_user.id != null) {
      var result = await WhistlistProvider().getAllDataNew(
          (_user.id ?? "").replaceAll("gid://shopify/Customer/", ""));

      if (result != null && result.containsKey("items")) {
        _wishlist = Wishlist.fromJson(result);
      }
    }
  }

  Future<void> fetchingProduct(dynamic params) async {
    var result = await ProductProvider().getProduct(params["ids"]);
    for (int i = 0; i < result['nodes'].length; i++) {
      _product.add(Product.fromWishlist(
          result['nodes'][i], params["variantIds"][i].toString()));
    }
    update();
  }

  changeFilter(int index) {
    _product = _tempProduct;
    _selected = index;
    if (index == 1) {
      _product = [];
      for (final x in _tempProduct) {
        if (x.totalInventory! > 0) {
          _product.add(x);
        }
      }
    }

    if (index == 2) {
      _product = [];
      for (final x in _tempProduct) {
        if (x.totalInventory! == 0) {
          _product.add(x);
        }
      }
    }
    update();
  }

  Future<void> actionWishlist(String productId, String variantId,
      {String action = "add"}) async {
    if (settingsController.userModel.displayName == null) return;
    // var variables = {
    //   "productid": productId.replaceAll("gid://shopify/Product/", ""),
    //   "variantid": variantId.replaceAll("gid://shopify/ProductVariant/", ""),
    //   "customerid": settingsController.userModel.id!
    //       .replaceAll("gid://shopify/Customer/", ""),
    //   "action": action,
    //   "apikey": apiKeyWishlist,
    //   "version": "1"
    // };

    var variables = {
      "action": action,
      "customerId": settingsController.userModel.id!
          .replaceAll("gid://shopify/Customer/", ""),
      "productId": productId.replaceAll("gid://shopify/Product/", ""),
      "variantId": variantId.replaceAll("gid://shopify/ProductVariant/", "")
    };
    await WhistlistProvider().getActionNew(variables, action);

    // if (result != null && result["type"] == "error") {
    //   alertGagal(result["message"]);
    // }
  }

  changeColorProduct(int index, String color, String curHandle) async {
    Product temp = product[index];
    String colorBefore = (_tempColor == "")
        ? temp.options[1].values[0]
        : (_tempHandle != "" &&
                _tempHandle.substring(0, 10) == curHandle.substring(0, 10))
            ? _tempColor
            : temp.options[1].values[0];

    String handle = (temp.handle!)
        .replaceAll(colorBefore.toLowerCase().replaceAll(" ", "-"), "");
    var check = handle.split("-");
    handle = (check[check.length - 1] == "")
        ? (handle + color.toLowerCase())
        : handle.replaceAll(
            "--", "-" + color.toLowerCase().replaceAll(" ", "-") + "-");

    var result = await ProductProvider().getProductByHandle(handle);
    Product _product = Product.fromJson(result["product"]);
    _tempHandle = curHandle;
    _tempColor = color;
    product[index].handle = _product.handle;
    product[index].totalInventory = _product.totalInventory;
    product[index].image[0] = _product.image[0];
    update();
  }
}

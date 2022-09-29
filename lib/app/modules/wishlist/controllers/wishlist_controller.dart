import 'package:colorbox/app/modules/collections/models/product_model.dart';
import 'package:colorbox/app/modules/product/providers/product_providers.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/wishlist/models/wishlist_model.dart';
import 'package:colorbox/app/modules/wishlist/providers/wishlist_provider.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  final LocalStorageData localStorageData = Get.find();
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

  @override
  void onInit() async {
    await fetchingData();
    super.onInit();
  }

  Future<void> fetchingData() async {
    _loading.value = true;
    update();
    UserModel? _user = await localStorageData.getUser;
    if (_user.id != null) {
      var result = await WhistlistProvider()
          .getAllData(_user.id!.replaceAll("gid://shopify/Customer/", ""));
      if (!result.contains("<!doctype html>") && result != null) {
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

  Future<void> fetchWishlist() async {
    UserModel? _user = await localStorageData.getUser;
    var result = await WhistlistProvider()
        .getAllData(_user.id!.replaceAll("gid://shopify/Customer/", ""));

    if (!result.contains("<!doctype html>") && result != null) {
      _wishlist = Wishlist.fromJson(result);
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
        if (x.variantSelected!.inventoryQuantity! > 0) {
          _product.add(x);
        }
      }
    }

    if (index == 2) {
      _product = [];
      for (final x in _tempProduct) {
        if (x.variantSelected!.inventoryQuantity! == 0) {
          _product.add(x);
        }
      }
    }
    update();
  }

  actionWishlist(String variantId, {String action = "add"}) {
    String url =
        "https://cloud.smartwishlist.webmarked.net/v6/savewishlist.php/?callback=jQuery341049474196017360716_1664350775889&product_id=7810927657208&variant_id=$variantId&wishlist_id=62250877176hd732sp6jio&customer_id=6395546108152&action=add&hostname=wood.co.id&variant=1&store_id=62250877176&_=1664350775892";
  }
}

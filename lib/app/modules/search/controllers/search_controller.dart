import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/modules/collections/models/product_model.dart';
import 'package:colorbox/app/modules/product/providers/product_providers.dart';
import 'package:colorbox/app/modules/search/providers/search_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchController extends GetxController {
  final CollectionsController collectionsController =
      Get.put(CollectionsController());
  //SET LOADING
  ValueNotifier<bool> get loading => _loading;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get nextLoad => _nextLoad;
  final ValueNotifier<bool> _nextLoad = ValueNotifier(false);

  //GET DATA PRODUCTS
  List<Product> _product = [];
  List<Product> _productTemp = [];
  List<Product> get product => _product;

  final int _limit = 10;
  bool firstView = true;
  String _tempColor = "";
  String _tempHandle = "";

  void fetchSearchProduct(String search) async {
    _loading.value = true;
    var data = await SearchProvider().postSearch(search, _limit);
    if (data == null) {
      while (data == null) {
        data = await Future.delayed(const Duration(milliseconds: 1000),
            () => SearchProvider().postSearch(search, _limit));
      }
    }
    _product = [];

    for (var i = 0; i < data['edges'].length; i++) {
      _product.add(Product.fromSearch(data, i));
    }

    _loading.value = false;
    firstView = false;
    update();
  }

  void fetchAddSearchProduct(String search) async {
    _nextLoad.value = true;
    var data = await SearchProvider()
        .postSearchNext(search, _limit, _product[_product.length - 1].cursor!);
    if (data == null && _product[0].hasNextPage!) {
      while (data == null && _product[0].hasNextPage!) {
        data = await Future.delayed(
            const Duration(milliseconds: 1000),
            () => SearchProvider().postSearchNext(
                search, _limit, _product[_product.length - 1].cursor!));
      }
    }
    _productTemp = [];
    for (var i = 0; i < data['edges'].length; i++) {
      _productTemp.add(Product.fromSearch(data, i));
    }

    _product[_product.length - 1].hasNextPage =
        _productTemp[_productTemp.length - 1].hasNextPage;
    _product[_product.length - 1].cursor =
        _productTemp[_productTemp.length - 1].cursor;
    for (var i = 0; i < _productTemp.length; i++) {
      _product.add(_productTemp[i]);
    }
    _nextLoad.value = false;
    update();
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

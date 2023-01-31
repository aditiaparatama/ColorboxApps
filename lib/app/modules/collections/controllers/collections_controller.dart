import 'package:colorbox/app/modules/collections/models/product_model.dart';
import 'package:colorbox/app/modules/collections/providers/collection_provider.dart';
import 'package:colorbox/app/modules/collections/models/collection_model.dart';
import 'package:colorbox/app/modules/product/providers/product_providers.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollectionsController extends GetxController {
  //GET DATA COllECTION
  Collection _collection = Collection.empty();
  Collection _collectionTemp = Collection.empty();
  Collection get collection => _collection;

  //SET LOADING
  ValueNotifier<bool> get loading => _loading;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get nextLoad => _nextLoad;
  final ValueNotifier<bool> _nextLoad = ValueNotifier(false);

  //SET LIST TAB COLLECTION
  final List<Widget> _listTabs = [];
  List<Widget> get listTabs => _listTabs;
  // ignore: prefer_typing_uninitialized_variables
  var menu;
  bool? _parentList;
  int pageIndex = 0;

  final int _limit = 10;
  int selectedIndex = 0;
  int subjectID = 0;
  int orderBy = 2;
  int _idCollection = 0;
  String _filtersDefault = "";
  String filterColor = "";
  String filterSize = "";
  String filterPrice = "";
  String _tempColor = "", _firstColor = "";
  String _tempHandle = "";
  List<dynamic> filterList = [
    {"available": true}
  ];

  Future<void> fetchCollectionProduct(int id, int sortBy,
      {bool similiar = false}) async {
    _idCollection = id;
    orderBy = sortBy;
    // ignore: unused_local_variable
    String? sortKey, reverse;
    if (sortBy == 1) {
      sortKey = "BEST_SELLING";
      reverse = "false";
    } else if (sortBy == 2) {
      sortKey = "CREATED";
      reverse = "true";
    } else if (sortBy == 3) {
      sortKey = "PRICE";
      reverse = "true";
    } else if (sortBy == 4) {
      sortKey = "PRICE";
      reverse = "false";
    }

    _filtersDefault = ', filters:$filterList';

    if (!similiar) {
      _loading.value = true;
    }
    // update();
    var data = await CollectionProvider().collectionWithFilter(
        id, _limit, sortKey!, reverse!, _filtersDefault, "");
    if (data == null) {
      while (data == null) {
        data = await Future.delayed(
            const Duration(milliseconds: 1200),
            () => CollectionProvider().collectionWithFilter(
                id, _limit, sortKey!, reverse!, _filtersDefault, ""));
      }
    }
    _collection = Collection.empty();
    _collection = Collection.fromJson(data);
    _loading.value = false;
    update();
  }

  void fetchAddCollectionProduct(int id) async {
    // ignore: unused_local_variable
    String? sortKey, reverse;
    if (orderBy == 1) {
      sortKey = "BEST_SELLING";
      reverse = "false";
    } else if (orderBy == 2) {
      sortKey = "CREATED";
      reverse = "true";
    } else if (orderBy == 3) {
      sortKey = "PRICE";
      reverse = "true";
    } else if (orderBy == 4) {
      sortKey = "PRICE";
      reverse = "false";
    }

    _nextLoad.value = true;
    var data = await CollectionProvider().collectionWithFilter(
        id,
        _limit,
        sortKey!,
        reverse!,
        _filtersDefault,
        ',after: "${_collection.cursor!}"');
    if (data == null && _collection.hasNextPage!) {
      while (data == null && _collection.hasNextPage!) {
        data = await Future.delayed(
            const Duration(milliseconds: 1200),
            () => CollectionProvider().collectionWithFilter(
                id,
                _limit,
                sortKey!,
                reverse!,
                _filtersDefault,
                ',after: "${_collection.cursor!}"'));
      }
    }
    _collectionTemp = Collection.empty();
    _collectionTemp = Collection.fromJson(data);

    _collection.hasNextPage = _collectionTemp.hasNextPage;
    _collection.cursor = _collectionTemp.cursor;
    for (var i = 0; i < _collectionTemp.products.length; i++) {
      _collection.products.add(_collectionTemp.products[i]);
    }
    _nextLoad.value = false;
    update();
  }

  Future<void> setTabBar(var argMenu,
      {bool parent = false, int index = 0}) async {
    menu = argMenu;
    _parentList = parent;
    listTabs.clear();
    if (parent) {
      listTabs.add(Tab(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: colorTextBlack,
            child: Text(
              menu.title ?? "",
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            )),
      ));
    } else {
      for (int i = 0; i < argMenu.length; i++) {
        listTabs.add(Tab(
            child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: (index == i) ? colorTextBlack : null,
              border: Border.all(
                  color:
                      (index == i) ? colorTextBlack : const Color(0xFFE5E8EB))),
          child: Text(
            argMenu[i]
                .title!
                .replaceAll("- NEW ARRIVAL", "")
                .replaceAll("WOMEN - ", "")
                .replaceAll("MEN - ", ""),
            style: TextStyle(
              color: (index == i) ? Colors.white : const Color(0xFF9B9B9B),
            ),
          ),
        )));
      }
    }
    // update();
  }

  Future<void> onChangeList(int index) async {
    resetFilter(page: false);
    selectedIndex = index;
    _collection = Collection.empty();
    update();
    if (_parentList!) {
      subjectID = menu.subjectID!;
      await fetchCollectionProduct(menu.subjectID!, defaultSortBy);
    } else {
      subjectID = menu[index].subjectID!;
      await fetchCollectionProduct(menu[index].subjectID!, defaultSortBy);
    }
    update();
  }

  void resetFilter({bool page = false}) {
    filterColor = "";
    filterSize = "";
    filterPrice = "";
    _filtersDefault = "";
    if (page) {
      filterChange("", "");
    } else {
      update();
    }
  }

  void filterChange(String label, String value) async {
    filterList = [
      {"available": true}
    ];
    _filtersDefault = "";
    if (label.toLowerCase() == "color") {
      filterColor = value;
    }
    if (label.toLowerCase() == "size") {
      filterSize = value;
    }
    if (label.toLowerCase() == "harga" || label.toLowerCase() == "price") {
      filterPrice = value;
    }

    if (filterColor != "") {
      filterList.add(
          '{variantOption: { name: "color", value: "${filterColor.toUpperCase()}" }}');
    }
    if (filterSize != "") {
      filterList.add(
          '{variantOption: { name: "size", value: "${filterSize.toUpperCase()}" }}');
    }

    if (filterPrice != "") {
      var parseValue =
          filterPrice.replaceAll("Rp ", "").replaceAll(".", "").split("-");
      filterList.add(
          '{ price: { min: ${(parseValue[0] == "0 ") ? "10" : parseValue[0]}, max: ${parseValue[1]} }}');
    }

    // if (filterColor != "" || filterSize != "" || filterPrice != "") {
    _filtersDefault = ', filters:$filterList';
    // }
    String? sortKey, reverse;
    if (orderBy == 1) {
      sortKey = "BEST_SELLING";
      reverse = "false";
    } else if (orderBy == 2) {
      sortKey = "CREATED";
      reverse = "true";
    } else if (orderBy == 3) {
      sortKey = "PRICE";
      reverse = "true";
    } else if (orderBy == 4) {
      sortKey = "PRICE";
      reverse = "false";
    }

    _loading.value = true;
    update();
    var data = await CollectionProvider().collectionWithFilter(
        _idCollection, _limit, sortKey!, reverse!, _filtersDefault, "");
    if (data == null) {
      while (data == null) {
        data = await Future.delayed(
            const Duration(milliseconds: 1200),
            () => CollectionProvider().collectionWithFilter(_idCollection,
                _limit, sortKey!, reverse!, _filtersDefault, ""));
      }
    }
    _collection = Collection.empty();
    _collection = Collection.fromJson(data);
    _loading.value = false;
    update();
  }

  changeColorProduct(int index, String color, String curHandle) async {
    Product temp = _collection.products[index];
    String colorBefore = (_tempColor == "")
        ? temp.options[1].values[0]
        : (_tempHandle != "" &&
                _tempHandle.substring(0, 10) == curHandle.substring(0, 10))
            ? _tempColor
            : temp.options[1].values[0];

    //update handle
    String handle = "";
    if (_tempHandle != "" &&
        _tempHandle.substring(0, 10) == curHandle.substring(0, 10) &&
        _firstColor != temp.options[1].values[0]) {
      handle = _tempHandle
          .replaceAll(
              temp.options[1].values[0].toLowerCase().replaceAll(" ", "-"), "")
          .replaceAll(colorBefore.toLowerCase().replaceAll(" ", "-"), "");
    } else {
      handle = (temp.handle!)
          .replaceAll(colorBefore.toLowerCase().replaceAll(" ", "-"), "");
    }

    var check = handle.split("-");
    handle = (check[check.length - 1] == "")
        ? (handle + color.toLowerCase())
        : handle.replaceAll(
            "--", "-" + color.toLowerCase().replaceAll(" ", "-") + "-");

    var result = await ProductProvider().getProductByHandle(handle);
    Product _product = Product.fromJson(result["product"]);
    _tempHandle = _product.handle!;
    _tempColor = color;
    _firstColor = temp.options[1].values[0];
    _collection.products[index].handle = _product.handle;
    _collection.products[index].totalInventory = _product.totalInventory;
    _collection.products[index].image[0] = _product.image[0];
    update();
  }
}

import 'package:colorbox/app/modules/collections/models/product_model.dart';
import 'package:colorbox/app/modules/collections/providers/collection_provider.dart';
import 'package:colorbox/app/modules/home/models/homecollection_model.dart';
import 'package:colorbox/app/modules/product/providers/product_providers.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeCollectionsController extends GetxController {
  //GET DATA COllECTION
  Collection _collection = Collection("", "", 0, [], false, "");
  Collection _collectionTemp = Collection("", "", 0, [], false, "");
  Collection get collection => _collection;

  //GET DATA COllECTION2
  Collection2 _collection2 = Collection2("", "", 0, [], false, "");
  Collection2 get collection2 => _collection2;

  //GET DATA COllECTION3
  Collection3 _collection3 = Collection3("", "", 0, [], false, "");
  Collection3 get collection3 => _collection3;

  //GET DATA COllECTION4
  Collection4 _collection4 = Collection4("", "", 0, [], false, "");
  Collection4 get collection4 => _collection4;

  //SET LOADING
  ValueNotifier<bool> get loading => _loading;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get nextLoad => _nextLoad;
  final ValueNotifier<bool> _nextLoad = ValueNotifier(false);

  //SET LIST TAB COLLECTION
  final List<Widget> _listTabs = [];
  List<Widget> get listTabs => _listTabs;
  int tabIndex = 0;
  // ignore: prefer_typing_uninitialized_variables
  var menu;
  bool? _parentList;
  int pageIndex = 0;

  final int _limit = 10;
  int selectedIndex = 0;
  int subjectID = 0;
  int orderBy = 2;
  String _tempColor = "";
  String _tempHandle = "";
  String _filtersDefault = "";
  List<dynamic> filterList = [
    {"available": true}
  ];

  void fetchCollectionProduct(int id, int sortBy) async {
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

    _loading.value = true;
    var data = await CollectionProvider()
        .collectionWithFilter(id, 5, sortKey!, reverse!, _filtersDefault, "");

    if (data == null) {
      while (data == null) {
        data = await Future.delayed(
            const Duration(milliseconds: 1000),
            () =>
                CollectionProvider().postCollection(id, 5, sortKey!, reverse!));
      }
    }
    _collection = Collection("", "", 0, [], false, "");
    _collection = Collection.fromJson(data);
    _loading.value = false;
    update();
  }

  void fetchCollectionProduct2(int id, int sortBy) async {
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

    _loading.value = true;
    var data = await CollectionProvider().collectionWithFilter(
        id, _limit, sortKey!, reverse!, _filtersDefault, "");

    if (data == null) {
      while (data == null) {
        data = await Future.delayed(
            const Duration(milliseconds: 1000),
            () => CollectionProvider()
                .postCollection(id, _limit, sortKey!, reverse!));
      }
    }
    _collection2 = Collection2("", "", 0, [], false, "");
    _collection2 = Collection2.fromJson(data);
    _loading.value = false;
    update();
  }

  Future<void> fetchCollectionProduct3(int id, int sortBy) async {
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

    _loading.value = true;
    var data = await CollectionProvider()
        .collectionWithFilter(id, 5, sortKey!, reverse!, _filtersDefault, "");

    if (data == null) {
      while (data == null) {
        data = await Future.delayed(
            const Duration(milliseconds: 1000),
            () =>
                CollectionProvider().postCollection(id, 5, sortKey!, reverse!));
      }
    }
    _collection3 = Collection3("", "", 0, [], false, "");
    _collection3 = Collection3.fromJson(data);
    _loading.value = false;
    update();
  }

  void fetchCollectionProduct4(int id, int sortBy) async {
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

    _loading.value = true;
    var data = await CollectionProvider().collectionWithFilter(
        id, _limit, sortKey!, reverse!, _filtersDefault, "");

    if (data == null) {
      while (data == null) {
        data = await Future.delayed(
            const Duration(milliseconds: 1000),
            () => CollectionProvider()
                .postCollection(id, _limit, sortKey!, reverse!));
      }
    }
    _collection4 = Collection4("", "", 0, [], false, "");
    _collection4 = Collection4.fromJson(data);
    _loading.value = false;
    update();
  }

  void fetchAddCollectionProduct(int id) async {
    _nextLoad.value = true;
    var data = await CollectionProvider()
        .postCollectionNext(id, _limit, _collection.cursor!);
    if (data == null && _collection.hasNextPage!) {
      while (data == null && _collection.hasNextPage!) {
        data = await Future.delayed(
            const Duration(milliseconds: 1000),
            () => CollectionProvider()
                .postCollectionNext(id, _limit, _collection.cursor!));
      }
    }
    _collectionTemp = Collection("", "", 0, [], false, "");
    _collectionTemp = Collection.fromJson(data);

    _collection.hasNextPage = _collectionTemp.hasNextPage;
    _collection.cursor = _collectionTemp.cursor;
    for (var i = 0; i < _collectionTemp.products.length; i++) {
      _collection.products.add(_collectionTemp.products[i]);
    }
    _nextLoad.value = false;
    update();
  }

  Future<void> setTabBar(var argMenu, {bool parent = false}) async {
    menu = argMenu;
    _parentList = parent;
    listTabs.clear();
    if (parent) {
      listTabs.add(Tab(
        child: Text(menu.title),
      ));
    } else {
      for (int i = 0; i < argMenu.length; i++) {
        listTabs.add(Tab(
            child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: (tabIndex == i) ? colorTextBlack : Colors.transparent,
              border: Border.all(color: Colors.grey)),
          child: Text(
              argMenu[i]
                  .title!
                  .replaceAll("- NEW ARRIVAL", "")
                  .replaceAll("WOMEN - ", "")
                  .replaceAll("MEN - ", ""),
              style: TextStyle(
                  color: (tabIndex == i) ? Colors.white : Colors.grey)),
        )));
      }
    }
    update();
  }

  void onChangeList(int index) {
    selectedIndex = index;
    if (_parentList!) {
      subjectID = menu.subjectID!;
      fetchCollectionProduct(menu.subjectID!, defaultSortBy);
    } else {
      subjectID = menu[index].subjectID!;
      fetchCollectionProduct(menu[index].subjectID!, defaultSortBy);
    }
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
    _collection.products[index].handle = _product.handle;
    _collection.products[index].totalInventory = _product.totalInventory;
    _collection.products[index].image[0] = _product.image[0];
    update();
  }
}

import 'package:colorbox/app/modules/collections/providers/collection_provider.dart';
import 'package:colorbox/app/modules/collections/models/collection_model.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CollectionsController extends GetxController {
  //GET DATA COllECTION
  Collection _collection = Collection("", "", 0, [], false, "");
  Collection _collectionTemp = Collection("", "", 0, [], false, "");
  Collection get collection => _collection;

  //SET LOADING
  ValueNotifier<bool> get loading => _loading;
  final ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get nextLoad => _nextLoad;
  final ValueNotifier<bool> _nextLoad = ValueNotifier(false);

  //SET LIST TAB COLLECTION
  final List<Widget> _listTabs = [];
  List<Widget> get listTabs => _listTabs;
  var menu;
  bool? _parentList;
  int pageIndex = 0;

  final int _limit = 10;
  int selectedIndex = 0;
  int subjectID = 0;

  void fetchCollectionProduct(int id, int sortBy) async {
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

    _loading.value = true;
    var data = await CollectionProvider()
        .postCollection(id, _limit, sortKey!, reverse!);
    if (data == null) {
      while (data == null) {
        data = await Future.delayed(
            const Duration(milliseconds: 1000),
            () => CollectionProvider()
                .postCollection(id, _limit, sortKey!, reverse!));
      }
    }
    _collection = Collection("", "", 0, [], false, "");
    _collection = Collection.fromJson(data);
    _loading.value = false;
    update();
  }

  // void fetchCollectionProduct2(int id, int sortBy) async {
  //   // ignore: unused_local_variable
  //   String? sortKey, reverse;
  //   if (sortBy == 1) {
  //     sortKey = "BEST_SELLING";
  //     reverse = "false";
  //   } else if (sortBy == 2) {
  //     sortKey = "CREATED";
  //     reverse = "true";
  //   } else if (sortBy == 3) {
  //     sortKey = "PRICE";
  //     reverse = "true";
  //   } else if (sortBy == 4) {
  //     sortKey = "PRICE";
  //     reverse = "false";
  //   }

  //   _loading.value = true;
  //   var data = await CollectionProvider()
  //       .postCollection(id, _limit, sortKey!, reverse!);
  //   if (data == null) {
  //     while (data == null) {
  //       data = await Future.delayed(
  //           const Duration(milliseconds: 1000),
  //           () => CollectionProvider()
  //               .postCollection(id, _limit, sortKey!, reverse!));
  //     }
  //   }
  //   _collection = Collection("", "", 0, [], false, "");
  //   _collection = Collection.fromJson(data);
  //   _loading.value = false;
  //   update();
  // }

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
            child: Text(argMenu[i]
                .title!
                .replaceAll("- NEW ARRIVAL", "")
                .replaceAll("WOMEN - ", "")
                .replaceAll("MEN - ", ""))));
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
}

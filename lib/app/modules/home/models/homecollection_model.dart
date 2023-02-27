import 'package:colorbox/app/modules/collections/models/product_model.dart';

class Collection {
  String? id;
  String? handle;
  int? productsCount;
  List<Product> products = List<Product>.empty();
  bool? hasNextPage;
  String? cursor;

  Collection(this.id, this.handle, this.productsCount, this.products,
      this.hasNextPage, this.cursor);

  Collection.fromJson(var json) {
    id = json['id'];
    handle = json['handle'];
    productsCount = json['productsCount'];
    products = [];
    for (int i = 0; i < json['products']['edges'].length; i++) {
      if (json['products']['edges'][i]['node']['totalInventory'] > 0) {
        products.add(Product.fromJson(json['products']['edges'][i]['node']));
      }
    }
    hasNextPage = json['products']['pageInfo']['hasNextPage'];
    var index = json['products']['edges'].length - 1;
    if (hasNextPage!) cursor = json['products']['edges'][index]['cursor'];
  }
}

class Collection2 {
  String? id;
  String? handle;
  int? productsCount;
  List<Product> products = List<Product>.empty();
  bool? hasNextPage;
  String? cursor;

  Collection2(this.id, this.handle, this.productsCount, this.products,
      this.hasNextPage, this.cursor);

  Collection2.fromJson(var json) {
    id = json['id'];
    handle = json['handle'];
    productsCount = json['productsCount'];
    products = [];
    for (int i = 0; i < json['products']['edges'].length; i++) {
      products.add(Product.fromJson(json['products']['edges'][i]['node']));
    }
    hasNextPage = json['products']['pageInfo']['hasNextPage'];
    var index = json['products']['edges'].length - 1;
    if (hasNextPage!) cursor = json['products']['edges'][index]['cursor'];
  }
}

class Collection3 {
  String? id;
  String? handle;
  int? productsCount;
  List<Product> products = List<Product>.empty();
  bool? hasNextPage;
  String? cursor;

  Collection3(this.id, this.handle, this.productsCount, this.products,
      this.hasNextPage, this.cursor);

  Collection3.fromJson(var json) {
    id = json['id'];
    handle = json['handle'];
    productsCount = json['productsCount'];
    products = [];
    for (int i = 0; i < json['products']['edges'].length; i++) {
      products.add(Product.fromJson(json['products']['edges'][i]['node']));
    }
    hasNextPage = json['products']['pageInfo']['hasNextPage'];
    var index = json['products']['edges'].length - 1;
    if (hasNextPage!) cursor = json['products']['edges'][index]['cursor'];
  }
}

class Collection4 {
  String? id;
  String? handle;
  int? productsCount;
  List<Product> products = List<Product>.empty();
  bool? hasNextPage;
  String? cursor;

  Collection4(this.id, this.handle, this.productsCount, this.products,
      this.hasNextPage, this.cursor);

  Collection4.fromJson(var json) {
    id = json['id'];
    handle = json['handle'];
    productsCount = json['productsCount'];
    products = [];
    for (int i = 0; i < json['products']['edges'].length; i++) {
      products.add(Product.fromJson(json['products']['edges'][i]['node']));
    }
    hasNextPage = json['products']['pageInfo']['hasNextPage'];
    var index = json['products']['edges'].length - 1;
    if (hasNextPage!) cursor = json['products']['edges'][index]['cursor'];
  }
}

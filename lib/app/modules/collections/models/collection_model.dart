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
      products.add(Product.fromJson(json['products']['edges'][i]['node']));
    }
    hasNextPage = json['products']['pageInfo']['hasNextPage'];
    var index = json['products']['edges'].length - 1;
    if (hasNextPage!) cursor = json['products']['edges'][index]['cursor'];
  }
}

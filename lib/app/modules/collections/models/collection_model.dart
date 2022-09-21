import 'package:colorbox/app/modules/collections/models/product_model.dart';

class Collection {
  String? id;
  String? handle;
  int? productsCount;
  List<Filter>? filters;
  List<Product> products = List<Product>.empty();
  bool? hasNextPage;
  String? cursor;

  Collection(this.id, this.handle, this.productsCount, this.filters,
      this.products, this.hasNextPage, this.cursor);

  Collection.fromJson(var json) {
    id = json['id'];
    handle = json['handle'];
    productsCount =
        (json.containsKey("productsCount")) ? json['productsCount'] : null;
    products = [];
    for (int i = 0; i < json['products']['edges'].length; i++) {
      products.add(Product.fromJson(json['products']['edges'][i]['node']));
    }
    hasNextPage = json['products']['pageInfo']['hasNextPage'];
    var index = json['products']['edges'].length - 1;
    if (hasNextPage!) cursor = json['products']['edges'][index]['cursor'];

    filters = [];
    for (final x in json['products']['filters']) {
      filters!.add(Filter.fromJson(x));
    }
  }

  Collection.empty();
}

class Filter {
  String? label;
  List<String>? values;

  Filter.fromJson(var json) {
    label = json['label'];
    values = [];
    for (final x in json['values']) {
      values!.add(x['label']);
    }
    // values!.sort((a, b) => a.compareTo(b));
  }
}

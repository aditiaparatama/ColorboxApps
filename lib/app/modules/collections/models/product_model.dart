class Product {
  String? id;
  String? title;
  String? description;
  List<String> image = List<String>.empty();
  List<Options> options = List<Options>.empty();
  List<Variants> variants = List<Variants>.empty();
  bool? hasNextPage;
  String? cursor;

  Product(this.id, this.title, this.description, this.image, this.options,
      this.variants, this.hasNextPage, this.cursor);

  Product.fromJson(var json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = [];
    for (var i = 0; i < json['images']['edges'].length; i++) {
      image.add(json['images']['edges'][i]['node']['src']);
    }
    options = [];
    for (var i = 0; i < json['options'].length; i++) {
      options.add(Options.fromJson(json['options'][i]));
    }
    variants = [];
    for (var i = 0; i < json['variants']['edges'].length; i++) {
      variants.add(Variants.fromJson(json['variants']['edges'][i]['node']));
    }

    if (json.containsKey('pageInfo')) {
      hasNextPage = json['pageInfo']['hasNextPage'];
      var index = json['edges'].length - 1;
      if (hasNextPage!) cursor = json['edges'][index]['cursor'];
    }
  }

  Product.fromSearch(var json, int index) {
    id = json['edges'][index]['node']['id'];
    title = json['edges'][index]['node']['title'];
    description = json['edges'][index]['node']['description'];
    image = [];
    for (var i = 0;
        i < json['edges'][index]['node']['images']['edges'].length;
        i++) {
      image.add(
          json['edges'][index]['node']['images']['edges'][i]['node']['src']);
    }
    options = [];
    for (var i = 0; i < json['edges'][index]['node']['options'].length; i++) {
      options.add(Options.fromJson(json['edges'][index]['node']['options'][i]));
    }
    variants = [];
    for (var i = 0;
        i < json['edges'][index]['node']['variants']['edges'].length;
        i++) {
      variants.add(Variants.fromJson(
          json['edges'][index]['node']['variants']['edges'][i]['node']));
    }

    if (json.containsKey('pageInfo')) {
      hasNextPage = json['pageInfo']['hasNextPage'];
      var index = json['edges'].length - 1;
      if (hasNextPage!) cursor = json['edges'][index]['cursor'];
    }
  }

  Product.isEmpty();
}

class Options {
  String? name;
  String? value;
  List<String> values = [];
  Options(this.name, this.values, this.value);

  Options.fromJson(var json) {
    name = json['name'];
    values = [];
    for (var i = 0; i < json['values'].length; i++) {
      values.add(json['values'][i]);
    }
  }

  Options.fromVariant(var json) {
    name = json['name'];
    value = json['value'];
  }
}

class Variants {
  String? id;
  String? title;
  String? sku;
  int? grams;
  String? price;
  String? compareAtPrice;
  int? inventoryQuantity;
  List<Options> options = [];
  double? weight;
  String? weightUnit;
  String? titleProduct;
  String? image;

  Variants(
      this.id,
      this.title,
      this.sku,
      this.grams,
      this.price,
      this.compareAtPrice,
      this.inventoryQuantity,
      this.options,
      this.weight,
      this.weightUnit,
      this.titleProduct,
      this.image);

  Variants.fromJson(var json) {
    id = json["id"];
    price = json['price'];
    compareAtPrice = json['compareAtPrice'];
    compareAtPrice ??= "0";
    inventoryQuantity = json['inventoryQuantity'];
    sku = json['sku'];
    options = [];
    for (int i = 0; i < json['selectedOptions'].length; i++) {
      options.add(Options.fromVariant(json['selectedOptions'][i]));
    }
  }

  Variants.fromCart(var json) {
    id = json["id"];
    title = json["title"];
    titleProduct = json["product"]["title"];
    price = json["price"];
    compareAtPrice = json["compareAtPrice"] ??= "0";
    weight = json["weight"];
    weightUnit = json["weightUnit"];
    options = [];
    for (int i = 0; i < json['selectedOptions'].length; i++) {
      options.add(Options.fromVariant(json['selectedOptions'][i]));
    }
    image = json["image"]["src"];
  }
}

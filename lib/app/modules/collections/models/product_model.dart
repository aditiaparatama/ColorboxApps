class Product {
  String? id;
  String? idCollection;
  String? title;
  int? totalInventory;
  String? type;
  List<String>? tags;
  String? description;
  String? handle;
  List<Options> options = List<Options>.empty();
  List<String> image = List<String>.empty();
  List<Variants> variants = List<Variants>.empty();
  Variants? variantSelected;
  bool? hasNextPage;
  String? cursor;

  Product(
      this.id,
      this.idCollection,
      this.title,
      this.totalInventory,
      this.type,
      this.description,
      this.handle,
      this.image,
      this.options,
      this.variants,
      this.hasNextPage,
      this.cursor);

  Product.fromJson(var json) {
    id = json['id'];
    title = json['title'];
    totalInventory = json['totalInventory'];
    type = json['productType'];
    description = json['descriptionHtml'];
    handle = json['handle'];

    tags = [];
    for (final x in json["tags"]) {
      tags!.add(x);
    }

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
    totalInventory = json['edges'][index]['node']['totalInventory'];
    description = json['edges'][index]['node']['descriptionHtml'];
    handle = json['edges'][index]['node']['handle'];
    tags = [];
    for (final x in json['edges'][index]['node']["tags"]) {
      tags!.add(x);
    }
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

    if (json['edges'][index]['node']['collections']['edges'].isNotEmpty) {
      idCollection =
          json['edges'][index]['node']['collections']['edges'][0]['node']['id'];
    }
  }

  Product.fromWishlist(var json, String variantId) {
    id = json['id'];
    if (json['collections']['edges'].length > 0) {
      idCollection = json['collections']['edges'][0]['node']['id'];
    }
    title = json['title'];
    description = json['description'];
    handle = json['handle'];
    totalInventory = json["totalInventory"];
    tags = [];
    for (final x in json["tags"]) {
      tags!.add(x);
    }

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
      if (json['variants']['edges'][i]['node']['id']
              .replaceAll("gid://shopify/ProductVariant/", "") ==
          variantId) {
        variantSelected =
            Variants.fromWishlist(json['variants']['edges'][i]['node']);
      }
      variants.add(Variants.fromWishlist(json['variants']['edges'][i]['node']));
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
  String? idProduct;
  List<String>? idCollection;
  String? title;
  String? sku;
  String? barcode;
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
      this.idProduct,
      this.idCollection,
      this.title,
      this.sku,
      this.barcode,
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
    title = json["title"];
    price = (json['price'] is String)
        ? json['price']
        : json['price']["amount"].replaceAll(".0", "");

    compareAtPrice = (json['compareAtPrice'] == null)
        ? "0"
        : (json['compareAtPrice'] is String)
            ? json['compareAtPrice']
            : (json['compareAtPrice']["amount"] ?? "0").replaceAll(".0", "");
    inventoryQuantity = (json.containsKey("inventoryQuantity"))
        ? json['inventoryQuantity']
        : json['quantityAvailable'];
    sku = json['sku'];
    barcode = json['barcode'];
    options = [];
    for (int i = 0; i < json['selectedOptions'].length; i++) {
      options.add(Options.fromVariant(json['selectedOptions'][i]));
    }
  }

  Variants.fromCart(var json) {
    id = json["id"];
    idProduct =
        (json["product"].containsKey("id")) ? json["product"]["id"] : null;
    title = json["title"];
    titleProduct = json["product"]["title"];
    price = json["price"]["amount"].replaceAll(".0", "");
    compareAtPrice = (json['compareAtPrice'] == null)
        ? "0"
        : (json['compareAtPrice'] is String)
            ? json['compareAtPrice']
            : (json['compareAtPrice']["amount"] ?? "0").replaceAll(".0", "");
    weight = json["weight"];
    weightUnit = json["weightUnit"];
    inventoryQuantity = (json.containsKey("inventoryQuantity"))
        ? json['inventoryQuantity']
        : json['quantityAvailable'];
    options = [];
    for (int i = 0; i < json['selectedOptions'].length; i++) {
      options.add(Options.fromVariant(json['selectedOptions'][i]));
    }
    image = json["image"]["src"];

    idCollection = [];
    if (json['product'].containsKey("collections")) {
      for (final x in json['product']['collections']['edges']) {
        idCollection!.add(x['node']['id']);
      }
    }
  }

  Variants.fromWishlist(var json) {
    id = json["id"].replaceAll("gid://shopify/ProductVariant/", "");
    price = (json['price'] is String)
        ? json['price']
        : json['price']["amount"].replaceAll(".0", "");

    compareAtPrice = (json['compareAtPrice'] == null)
        ? "0"
        : (json['compareAtPrice'] is String)
            ? json['compareAtPrice']
            : (json['compareAtPrice']["amount"] ?? "0").replaceAll(".0", "");
    compareAtPrice ??= "0.00";
    inventoryQuantity = json['quantityAvailable'];
    sku = json['sku'];
    barcode = json['barcode'];
    options = [];
    for (int i = 0; i < json['selectedOptions'].length; i++) {
      options.add(Options.fromVariant(json['selectedOptions'][i]));
    }
  }
}

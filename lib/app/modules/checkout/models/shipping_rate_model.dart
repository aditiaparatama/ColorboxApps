class Rate {
  Origin? origin;
  String? currency = "IDR";
  String? locale = "en";
}

class Origin {
  String? country = "ID";
  // ignore: non_constant_identifier_names
  String? post_code;
  String? city;
  String? name;
}

class Destination {
  String? country = "ID";
  // ignore: non_constant_identifier_names
  String? postal_code;
  String? city;
  String? name;
}

class Items {
  String? name;
  String? sku;
  int? grams;
  int? price;
  bool? require = true;
  // ignore: non_constant_identifier_names
  String? product_id;
  // ignore: non_constant_identifier_names
  String? variant_id;
}

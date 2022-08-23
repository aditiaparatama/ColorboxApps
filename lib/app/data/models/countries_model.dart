class Countries {
  int? id;
  String? name;
  String? taxName;
  double? tax;
  List<Province>? provinces;

  Countries(this.id, this.name, this.taxName, this.provinces);

  Countries.fromJson(var json) {
    id = json['id'];
    name = json['name'];
    taxName = json['tax_name'];
    tax = json['tax'];
    provinces = [];

    for (int i = 0; i < json['provinces'].length; i++) {
      provinces!.add(Province.fromJson(json['provinces'][i]));
    }
  }
}

class Province {
  int? id;
  int? countryId;
  String? name;
  String? code;
  String? taxName;
  String? taxType;
  String? shippingZoneId;
  double? tax;
  double? taxPercentage;

  Province(this.id, this.countryId, this.name, this.code, this.taxName,
      this.taxType, this.shippingZoneId, this.tax, this.taxPercentage);

  Province.fromJson(var json) {
    id = json['id'];
    countryId = json['country_id'];
    name = json['name'];
    code = json['code'];
    taxName = json['tax_name'];
    taxType = json['tax_type'];
    shippingZoneId = json['shipping_zone_id'].toString();
    tax = json['tax'];
    taxPercentage = json['tax_percentage'];
  }
}

// class Wilayah {
//   List<dynamic>? city;

//   Wilayah(this.city);

//   Wilayah.fromJson(var json) {
//     city = [];
//     for (final x in json) {
//       city!.add(City.fromJson(json));
//     }
//   }
// }

// class City {
//   String? city;
//   List<Zip>? zip;

//   City(this.city, this.zip);

//   City.fromJson(var json) {
//     zip = [];
//   }
// }

// class Zip {
//   String? zip;
//   Zip(this.zip);
// }

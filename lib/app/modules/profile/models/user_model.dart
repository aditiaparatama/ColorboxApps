import 'package:colorbox/app/data/models/mailing_address.dart';

class UserModel {
  String? id;
  String? displayName;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  Address? defaultAddress;
  List<MailingAddress>? addresses;
  String? expiresAt;

  UserModel(
      this.id,
      this.displayName,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.defaultAddress,
      this.addresses,
      this.expiresAt);

  UserModel.fromJson(var json) {
    id = json['id'].replaceAll("gid://shopify/Customer/", "");
    displayName = json['displayName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    defaultAddress = Address.fromJson(json['defaultAddress']);
    addresses = [];

    for (int i = 0; i < json['addresses']['edges'].length; i++) {
      addresses!
          .add(MailingAddress.fromJson(json['addresses']['edges'][i]['node']));
    }
  }

  UserModel.isEmpty();

  UserModel.json(var json) {
    id = json['id'];
    displayName = json['displayName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    expiresAt = json['expiresAt'];
  }

  toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'expiresAt': expiresAt,
      // 'defaultAddress': defaultAddress,
      // 'addresses': addresses,
    };
  }
}

class Address {
  String? id;
  String? firstName;
  String? lastName;
  String? address1;
  String? address2;
  String? company;
  String? city;
  String? country;
  String? countryCodeV2;
  String? phone;
  String? province;
  String? provinceCode;
  String? zip;

  Address(
      this.id,
      this.firstName,
      this.lastName,
      this.address1,
      this.address2,
      this.company,
      this.city,
      this.country,
      this.countryCodeV2,
      this.phone,
      this.province,
      this.provinceCode,
      this.zip);

  Address.fromJson(var json) {
    if (json == null) return;
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    address1 = json['address1'];
    address2 = json['address2'];
    company = json['company'];
    city = json['city'];
    country = json['country'];
    countryCodeV2 = json['countryCodeV2'];
    phone = json['phone'];
    province = json['province'];
    provinceCode = json['provinceCode'];
    zip = json['zip'];
  }
}

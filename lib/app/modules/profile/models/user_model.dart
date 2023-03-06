import 'package:colorbox/app/data/models/mailing_address.dart';

class UserModel {
  String? id;
  String? displayName;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? note;
  EmailMarketingaconsent? emailMarketing;
  Address? defaultAddress;
  List<MailingAddress>? addresses;
  String? expiresAt;
  String? tokenDevice;

  UserModel(
      this.id,
      this.displayName,
      this.firstName,
      this.lastName,
      this.email,
      this.phone,
      this.note,
      this.emailMarketing,
      this.defaultAddress,
      this.addresses,
      this.expiresAt,
      this.tokenDevice);

  UserModel.fromJson(var json) {
    id = json['id']; //.replaceAll("gid://shopify/Customer/", "");
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

  UserModel.fromAdmin(var json) {
    id = json['id']; //.replaceAll("gid://shopify/Customer/", "");
    displayName = json['displayName'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    note = json['note'] ?? "";
    emailMarketing = json.containsKey("emailMarketingConsent")
        ? EmailMarketingaconsent.fromJson(json["emailMarketingConsent"])
        : null;
    if (json['defaultAddress']['firstName'] == null ||
        json['defaultAddress']['address1'] == null) {
      for (int i = 0; i < json['addresses'].length; i++) {
        if (json['addresses'][i]['firstName'] != null &&
            json['addresses'][i]['address1'] != null) {
          defaultAddress = Address.fromJson(json['addresses'][i]);
          break;
        }
      }
    } else {
      defaultAddress = Address.fromJson(json['defaultAddress']);
    }
    addresses = [];
    for (int i = 0; i < json['addresses'].length; i++) {
      addresses!.add(MailingAddress.fromJson(json['addresses'][i]));
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
    note = json['note'];
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
      'note': note,
      'expiresAt': expiresAt,
      // 'defaultAddress': defaultAddress,
      // 'addresses': addresses,
    };
  }

  toFireStore() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "tokenDevice": tokenDevice
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

class CustomerToken {
  String? id;
  String? accessToken;
  String? expiresAt;

  CustomerToken(this.id, this.accessToken, this.expiresAt);

  CustomerToken.json(var json) {
    id = json['id'];
    accessToken = json['accessToken'];
    expiresAt = json['expiresAt'];
  }

  CustomerToken.isEmpty();

  toJson() {
    return {
      'id': id,
      'accessToken': accessToken,
      'expiresAt': expiresAt,
    };
  }
}

class EmailMarketingaconsent {
  String? marketingState;

  EmailMarketingaconsent(this.marketingState);

  EmailMarketingaconsent.fromJson(var json) {
    marketingState = json["marketingState"];
  }
}

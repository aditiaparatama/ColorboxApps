class MailingAddress {
  String? address1;
  String? address2;
  String? city;
  String? company;
  String? country;
  String? countryCodeV2;
  String? firstName;
  String? formatted;
  String? formattedArea;
  String? id;
  String? lastName;
  double? latitude;
  double? longitude;
  String? name;
  String? phone;
  String? province;
  String? provinceCode;
  String? zip;

  MailingAddress(
      this.address1,
      this.address2,
      this.city,
      this.company,
      this.country,
      this.countryCodeV2,
      this.firstName,
      this.formatted,
      this.formattedArea,
      this.id,
      this.lastName,
      this.latitude,
      this.longitude,
      this.name,
      this.phone,
      this.province,
      this.provinceCode,
      this.zip);

  MailingAddress.fromJson(var json) {
    if (json == null) return;
    address1 = json['address1'];
    address2 = json['address2'];
    city = json['city'];
    company = json['company'];
    country = json['country'];
    countryCodeV2 = json['countryCodeV2'];
    firstName = json['firstName'];
    formatted = json['formatted'];
    formattedArea = json['formatted'];
    id = json['id'];
    lastName = json['lastName'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    name = json['name'];
    phone = json['phone'];
    province = json['province'];
    provinceCode = json['provinceCode'];
    zip = json['zip'];
  }

  MailingAddress.isEmpty() {
    country = "Indonesia";
  }
}

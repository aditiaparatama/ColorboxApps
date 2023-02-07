import 'package:colorbox/utilities/extension.dart';
import 'package:intl/intl.dart';

class LocationStore {
  String? address2;
  String? address3;
  String? address4;
  String? province;
  String? city;
  String? zipcode;
  String? phone;
  String? latLong;
  String? opening;
  String? close;
  String? namaMallCegid;
  String? namaMallGoogle;
  bool? flgOpen;
  String? alamatLengkap;

  LocationStore(
      this.address2,
      this.address3,
      this.address4,
      this.province,
      this.city,
      this.zipcode,
      this.phone,
      this.latLong,
      this.opening,
      this.close,
      this.namaMallCegid,
      this.namaMallGoogle,
      this.flgOpen,
      this.alamatLengkap);

  LocationStore.fromJson(var json) {
    address2 = json["address2"];
    address3 = json["address3"];
    address4 = json["address4"];
    province = json["province"];
    city = StringExtention(json["city"]).toTitleCase();
    zipcode = json["zipcode"];
    phone = json["phone"];
    latLong = json["lat_long"];
    opening = json["opening"].replaceAll(".", ":");
    close = json["close"].replaceAll(".", ":");
    namaMallCegid = json["nama_mall_cegid"];
    namaMallGoogle = json["nama_mall_google"];
    alamatLengkap = (address2 ?? "") +
        (address3 ?? "") +
        " " +
        (address4 ?? "") +
        ", " +
        city! +
        ", " +
        province! +
        " " +
        zipcode!;

    DateTime now = DateTime.now();
    var formatter = DateFormat('HH:mm');
    var timeNow = formatter.parse(formatter.format(now));

    if (timeNow.isAfter(formatter.parse(opening!)) &&
        timeNow.isBefore(formatter.parse(close!))) {
      flgOpen = true;
    } else {
      flgOpen = false;
    }
  }

  LocationStore.fromProvince(var json) {
    province = json["province"];
    city = StringExtention(json["city"]).toTitleCase();
  }
}

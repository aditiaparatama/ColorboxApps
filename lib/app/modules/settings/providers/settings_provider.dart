import 'package:colorbox/globalvar.dart';
import 'package:get/get.dart';

class SettingsProvider extends GetConnect {
  Future<dynamic> deleteAccount(dynamic body) async {
    var response = await post("$urlColorboxApi/shipping/api/hapus_akun", body,
        headers: {"Content-Type": "application/json"});
    int count = 0;
    while (!response.isOk) {
      response = await post("$urlColorboxApi/shipping/api/hapus_akun", body,
          headers: {"Content-Type": "application/json"});

      count += 1;
      if (count >= 3) break;
    }

    var data = response.body;

    return data;
  }

  Future<dynamic> locationStore() async {
    var response = await get("$urlColorboxApi/report/front/location_store");
    int count = 0;
    while (!response.isOk) {
      response = await get("$urlColorboxApi/report/front/location_store");

      count += 1;
      if (count >= 3) break;
    }

    var data = response.body;

    return data;
  }

  Future<dynamic> listProvinceStore() async {
    var response =
        await get("$urlColorboxApi/report/front/list_location_store");
    int count = 0;
    while (!response.isOk) {
      response = await get("$urlColorboxApi/report/front/list_location_store");

      count += 1;
      if (count >= 3) break;
    }

    var data = response.body;

    return data;
  }
}

import 'package:colorbox/globalvar.dart';
import 'package:get/get.dart';

class SettingsProvider extends GetConnect {
  Future<dynamic> deleteAccount(dynamic body) async {
    var response = await post("$urlColorboxApi/hapus_akun", body,
        headers: {"Content-Type": "application/json"});
    int count = 0;
    while (!response.isOk) {
      response = await post("$urlColorboxApi/hapus_akun", body,
          headers: {"Content-Type": "application/json"});

      count += 1;
      if (count >= 3) break;
    }

    var data = response.body;

    return data;
  }
}

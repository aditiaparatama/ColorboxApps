import 'package:colorbox/globalvar.dart';
import 'package:get/get.dart';

class HomeProvider extends GetConnect {
  Future<List<dynamic>> getSlider() async {
    var response = await get(json_home);
    while (!response.isOk) {
      response = await get(json_home);
    }

    var data = response.body['sliders']['items'];

    return data;
  }
}

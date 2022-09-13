import 'package:colorbox/globalvar.dart';
import 'package:get/get.dart';

class HomeProvider extends GetConnect {
  Future<dynamic> getHomeSettings() async {
    var response = await get(json_home);
    while (!response.isOk) {
      response = await get(json_home);
    }

    var data = response.body;
    return data;
  }

  Future<List<dynamic>> getSlider() async {
    var response = await get(json_home);
    while (!response.isOk) {
      response = await get(json_home);
    }

    var data = response.body['sliders']['items'];
    return data;
  }

  Future<List<dynamic>> getCategory() async {
    var response = await get(json_category_home);
    while (!response.isOk) {
      response = await get(json_category_home);
    }

    var data = response.body['Category']['items'];
    return data;
  }

  Future<List<dynamic>> getCollections() async {
    var response = await get(json_home);
    while (!response.isOk) {
      response = await get(json_home);
    }

    var data = response.body['CollectionsHome']['items'];
    return data;
  }
}

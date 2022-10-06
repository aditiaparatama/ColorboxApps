import 'package:colorbox/globalvar.dart';
import 'package:get/get.dart';

class WhistlistProvider extends GetConnect {
  Future<dynamic> getAllData(String customerId) async {
    try {
      var response = await get(urlWishlist + pathWishlist + customerId);
      for (int i = 0; i < 4; i++) {
        if (response.isOk) break;
        response = await Future.delayed(const Duration(milliseconds: 1000),
            () => get(urlWishlist + pathWishlist + customerId));
      }

      return response.body;
    } catch (e) {
      return {"message": e.toString()};
    }
  }

  Future<dynamic> getAction(dynamic variables) async {
    try {
      FormData data = FormData(variables);
      var response = await post(urlWishlist, data);

      return response.body;
    } catch (e) {
      return {"message": e.toString()};
    }
  }
}

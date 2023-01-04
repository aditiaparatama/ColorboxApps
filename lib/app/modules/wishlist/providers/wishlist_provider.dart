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

  Future<dynamic> getAllDataNew(String customerId) async {
    try {
      var response = await get("$urlWishlistNew/$customerId",
          headers: {"Authorization": apiKeyWishlist});
      for (int i = 0; i < 4; i++) {
        if (response.isOk) break;
        response = await get("$urlWishlistNew/$customerId",
            headers: {"Authorization": apiKeyWishlist});
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

  Future<dynamic> getActionNew(dynamic variables, String action) async {
    try {
      dynamic response;
      if (action == "add") {
        response = await post(urlWishlistNew, variables, headers: {
          "Authorization": apiKeyWishlist,
          "Content-Type": "application/json"
        });
      } else if (action == "remove") {
        String productId = variables["productId"];
        response = await delete("$urlWishlistNew/$productId", headers: {
          "Authorization": apiKeyWishlist,
          "Content-Type": "application/json"
        });
      }

      return response.body;
    } catch (e) {
      return {"message": e.toString()};
    }
  }
}

import 'package:colorbox/globalvar.dart';
import 'package:get/get.dart';

class MenuProvider extends GetConnect {
  Future<List<dynamic>> getMenu() async {
    var response = await get(url_widget);
    while (!response.isOk) {
      response = await get(url_widget);
    }

    var data = response.body['menu']['items'];

    return data;
  }

  Future<dynamic> getTotalProduct(int id) async {
    String body = """query {
      collections(first: 1, query: "id:$id") {
        edges {
          node {
            id
            handle
            productsCount
          }
        }
      }
    }""";

    try {
      var response = await post(url_shopify + "graphql.json", body,
          contentType: "application/graphql",
          headers: {"X-Shopify-Access-Token": token, 'Retry-After': '5.0'});
      return await response.body['data']['collections']['edges'][0]['node']
          ['productsCount'];
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }
}

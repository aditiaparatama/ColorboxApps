import 'package:colorbox/globalvar.dart';
import 'package:get/get.dart';

class SearchProvider extends GetConnect {
  @override
  void onInit() {
    //Autenticator will be called 3 times if HttpStatus is
    //HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }

  Future<dynamic> postSearch(String value, int limit) async {
    String body = """query {
      products(first: $limit, query: "(title:$value) OR (sku:$value) OR (article:$value)") {
        pageInfo {
          hasNextPage
          hasPreviousPage
        }
        edges {
          cursor
          node {
            id
            title
            description
            options {
                name
                values
            }
            images(first: 5){
                edges {
                    node {
                        src
                    }
                }
            }
            variants(first: 10){
                edges {
                    node {
                        id
                        price
                        compareAtPrice
                        inventoryQuantity
                        sku
                        selectedOptions{
                            name
                            value
                        }
                    }
                }
            }
          }
        }
      }
    }""";

    try {
      var response = await post(url_shopify + "graphql.json", body,
          contentType: "application/graphql",
          headers: {"X-Shopify-Access-Token": token, 'Retry-After': '5.0'});
      return await response.body['data']['products'];
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<dynamic> postSearchNext(String value, int limit, String cursor) async {
    String body = """query {
      products(first: $limit, query: "(title:$value) OR (sku:$value) OR (article:$value)", after: "$cursor") {
        pageInfo {
          hasNextPage
          hasPreviousPage
        }
        edges {
          cursor
          node {
            id
            title
            description
            options {
                name
                values
            }
            images(first: 5){
                edges {
                    node {
                        src
                    }
                }
            }
            variants(first: 10){
                edges {
                    node {
                        id
                        price
                        compareAtPrice
                        inventoryQuantity
                        sku
                        selectedOptions{
                            name
                            value
                        }
                    }
                }
            }
          }
        }
      }
    }""";

    try {
      var response = await post(url_shopify + "graphql.json", body,
          contentType: "application/graphql",
          headers: {"X-Shopify-Access-Token": token, 'Retry-After': '5.0'});
      return await response.body['data']['products'];
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}

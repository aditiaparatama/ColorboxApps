import 'package:colorbox/globalvar.dart';
import 'package:get/get.dart';

class CollectionProvider extends GetConnect {
  @override
  void onInit() {
    //Autenticator will be called 3 times if HttpStatus is
    //HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }

  Future<dynamic> postCollection(int id, int limit) async {
    String body = """query {
      collections(first: 1, query: "id:$id") {
        edges {
          node {
            id
            handle
            productsCount
            products(first: $limit) {
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
          }
        }
      }
    }""";

    try {
      var response = await post(url_shopify + "graphql.json", body,
          contentType: "application/graphql",
          headers: {"X-Shopify-Access-Token": token, 'Retry-After': '5.0'});
      return await response.body['data']['collections']['edges'][0]['node'];
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<dynamic> postCollectionNext(int id, int limit, String cursor) async {
    String body = """query {
      collections(first: 1, query: "id:$id") {
        edges {
          node {
            id
            handle
            productsCount
            products(first: $limit, after: "$cursor") {
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
          }
        }
      }
    }""";

    try {
      var response = await post(url_shopify + "graphql.json", body,
          contentType: "application/graphql",
          headers: {"X-Shopify-Access-Token": token, 'Retry-After': '5.0'});
      return await response.body['data']['collections']['edges'][0]['node'];
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}

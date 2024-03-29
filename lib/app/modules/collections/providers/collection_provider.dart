import 'package:colorbox/app/services/shopify_graphql.dart';
import 'package:colorbox/globalvar.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class CollectionProvider extends GetConnect {
  @override
  void onInit() {
    //Autenticator will be called 3 times if HttpStatus is
    //HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }

  Future<dynamic> postCollection(
      int id, int limit, String sortKey, String reverse) async {
    String body = """query {
      collections(first: 1, query: "id:$id") {
        edges {
          node {
            id
            title
            handle
            productsCount
            products(first: $limit, sortKey: $sortKey, reverse: $reverse) {
              pageInfo {
                  hasNextPage
                  hasPreviousPage
              }
              edges {
                cursor
                node {
                  id
                  title
                  handle
                  description
                  descriptionHtml
                  tags
                  productType
                  totalInventory
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
                              price {
                                  amount
                              }
                              compareAtPrice{
                                  amount
                              }
                              barcode
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
            title
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
                  handle
                  description
                  descriptionHtml
                  productType
                  totalInventory
                  tags
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
                  collections(first: 5){
                      edges {
                          node {
                              id
                          }
                      }
                  }
                  variants(first: 10){
                      edges {
                          node {
                              id
                              price {
                                  amount
                              }
                              compareAtPrice{
                                  amount
                              }
                              barcode
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

  Future<dynamic> collectionWithFilter(int id, int limit, String sortKey,
      String reverse, dynamic filters, dynamic cursor) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        """query MultipleVariantOptionsWithInStock {
      collections(first: 1, query: "id:$id") {
        edges {
          node {
            id
            title
            handle
            products(first: $limit, sortKey: $sortKey, reverse: $reverse $filters $cursor) {
              pageInfo {
                  hasNextPage
                  hasPreviousPage
              }
              filters{
                label
                values{
                    label
                }
            }
              edges {
                cursor
                node {
                  id
                  title
                  handle
                  description
                  descriptionHtml
                  tags
                  totalInventory
                  productType
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
                              price {
                                  amount
                              }
                              compareAtPrice{
                                  amount
                              }
                              barcode
                              quantityAvailable
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
    }""",
      ),
    );

    final QueryResult result = await _client.query(options);

    if (result.data == null ||
        result.data!['collections']['edges'].length == 0) {
      return null;
    }

    return result.data!['collections']['edges'][0]['node'];
  }
}

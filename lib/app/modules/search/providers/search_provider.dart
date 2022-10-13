import 'package:colorbox/app/services/shopify_graphql.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class SearchProvider extends GetConnect {
  @override
  void onInit() {
    //Autenticator will be called 3 times if HttpStatus is
    //HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
  }

  Future<dynamic> postSearch(String value, int limit) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
        document: gql(
          """query {
      products(first: $limit, sortKey: CREATED_AT, reverse: true, query: "(title:$value*) OR (sku:$value) OR (article:$value) OR (barcode:$value)") {
        pageInfo {
          hasNextPage
          hasPreviousPage
        }
        edges {
          cursor
          node {
            id
            collections(first:5){
              edges{
                node{
                  id
                }
              }
            }
            totalInventory
            title
            description
            descriptionHtml
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
                        barcode
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
    }""",
        ),
        variables: {});

    try {
      final QueryResult result = await _client.query(options);
      return await result.data!['products'];
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }

  Future<dynamic> postSearchNext(String value, int limit, String cursor) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(document: gql("""query {
      products(first: $limit, sortKey: CREATED_AT, reverse: true, query: "(title:$value*) OR (sku:$value) OR (article:$value) OR (barcode:$value)", after: "$cursor") {
        pageInfo {
          hasNextPage
          hasPreviousPage
        }
        edges {
          cursor
          node {
            id
            collections(first:5){
              edges{
                node{
                  id
                }
              }
            }
            totalInventory
            title
            description
            descriptionHtml
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
                        barcode
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
    }"""), variables: {});

    try {
      final QueryResult result = await _client.query(options);
      return await result.data!['products'];
    } catch (e) {
      // ignore: avoid_print
      print(e.toString());
    }
  }
}

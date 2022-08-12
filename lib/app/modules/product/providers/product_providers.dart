import 'package:colorbox/app/services/shopify_graphql.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class ProductProvider extends GetConnect {
  Future<dynamic> getProduct(String id) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        '''
        {
          product(id:"gid://shopify/Product/$id") {
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

      ''',
      ),
    );

    final QueryResult result = await _client.query(options);

    return result.data;
  }
}
import 'package:colorbox/app/services/shopify_graphql.dart';
import 'package:colorbox/globalvar.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class HomeProvider extends GetConnect {
  Future<dynamic> getHomeSettings() async {
    var response = await get(jsonHome);
    while (!response.isOk) {
      response = await get(jsonHome);
    }

    var data = response.body;
    return data;
  }

  Future<List<dynamic>> getSlider() async {
    var response = await get(jsonHome);
    while (!response.isOk) {
      response = await get(jsonHome);
    }

    var data = response.body['sliders']['items'];
    return data;
  }

  Future<List<dynamic>> getCategory() async {
    var response = await get(jsonCategoryHome);
    while (!response.isOk) {
      response = await get(jsonCategoryHome);
    }

    var data = response.body['Category']['items'];
    return data;
  }

  Future<List<dynamic>> getCollections() async {
    var response = await get(jsonHome);
    while (!response.isOk) {
      response = await get(jsonHome);
    }

    var data = response.body['CollectionsHome']['items'];
    return data;
  }

  Future<dynamic> customerSubscribe(variables) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation customerEmailMarketingConsentUpdate($input: CustomerEmailMarketingConsentUpdateInput!) {
          customerEmailMarketingConsentUpdate(input: $input) {
            customer {
              # Customer fields
              id
              displayName
            }
            userErrors {
              field
              message
            }
          }
        }
      ''',
      ),
      variables: variables,
    );

    final QueryResult result = await _client.query(options);

    return result.data;
  }
}

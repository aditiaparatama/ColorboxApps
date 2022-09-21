import 'package:colorbox/app/services/shopify_graphql.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class DraftOrderProvider extends GetConnect {
  Future<dynamic> draftOrderCreate(dynamic variableInput) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation draftOrderCreate($input: DraftOrderInput!) {
          draftOrderCreate(input: $input) {
            draftOrder {
              # DraftOrder fields
              id
              name
            }
            userErrors {
              field
              message
            }
          }
        }
      ''',
      ),
      variables: variableInput,
    );

    final QueryResult result = await _client.query(options);

    return result.data;
  }

  Future<dynamic> draftOrderComplete(dynamic variableInput) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation draftOrderComplete($id: ID!) {
          draftOrderComplete(id: $id, paymentPending: true) {
            draftOrder {
              # DraftOrder fields
              order{
                  id
                  name
              }
            }
            userErrors {
              field
              message
            }
          }
        }
      ''',
      ),
      variables: variableInput,
    );

    final QueryResult result = await _client.query(options);

    return result.data;
  }

  Future<dynamic> orderUpdateUrl(dynamic variableInput) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation orderUpdate($input: OrderInput!) {
          orderUpdate(input: $input) {
            order {
              # Order fields
              id
              name
            }
            userErrors {
              field
              message
            }
          }
        }
      ''',
      ),
      variables: variableInput,
    );

    final QueryResult result = await _client.query(options);

    return result.data;
  }
}

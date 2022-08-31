import 'package:get/get.dart';
import 'package:graphql/client.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/services/shopify_graphql.dart';

class CartProvider extends GetConnect {
  Future<String> createCart() async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation cartCreate {
          cartCreate {
            cart {
              id
            }
            userErrors {
              field
              message
            }
          }
        }
      ''',
      ),
      variables: {},
    );

    final QueryResult result = await _client.query(options);

    return result.data!['cartCreate']['cart']['id'];
  }

  Future<dynamic> getCart(String id) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        '''
        {
          cart(id:"$id") {
            id
            attributes{
                key
                value
            }
            discountCodes{
                applicable
                code
            }
            discountAllocations{
                discountedAmount{
                    amount
                }
            }
            estimatedCost{
                subtotalAmount {
                    amount
                    currencyCode
                }
                totalAmount {
                    amount
                    currencyCode
                }
                totalDutyAmount {
                    amount
                    currencyCode
                }
                totalTaxAmount {
                    amount
                    currencyCode
                }
            }
            checkoutUrl
            lines(first: 20) {
                edges {
                node {
                    id
                    quantity
                    discountAllocations {
                    __typename
                    ... on CartAutomaticDiscountAllocation {
                        discountedAmount {
                            amount
                            currencyCode
                        }
                        title
                    }
                    ... on CartDiscountAllocation {
                        discountedAmount {
                            amount
                            currencyCode
                        }
                    }
                    }
                    merchandise {
                    ... on ProductVariant {
                        id
                        product {
                            id
                            title
                        }
                        title
                        price
                        compareAtPrice
                        weight
                        weightUnit
                        selectedOptions {
                            name
                            value
                        }
                        image {
                            src
                        }
                    }
                    }
                }
              }
            }
          }
        }
      ''',
      ),
      variables: {},
    );

    final QueryResult result = await _client.query(options);

    return result.data!;
  }

  Future<dynamic> cartAdd(String id, String variantId) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation cartLinesAdd($cartId: ID!, $lines: [CartLineInput!]!) {
          cartLinesAdd(cartId: $cartId, lines: $lines) {
            cart {
              # Cart fields
              id
            }
            userErrors {
              field
              message
            }
          }
        }
      ''',
      ),
      variables: {
        "cartId": id,
        "lines": {
          "merchandiseId": variantId,
          "quantity": 1,
        }
      },
    );

    var result = await _client.query(options);
    return result.data;
  }

  Future<void> cartUpdate(
      String id, String variantId, String idLine, int qty) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation cartLinesUpdate($cartId: ID!, $lines: [CartLineUpdateInput!]!) {
          cartLinesUpdate(cartId: $cartId, lines: $lines) {
            cart {
              # Cart fields
              id
            }
            userErrors {
              field
              message
            }
          }
        }
      ''',
      ),
      variables: {
        "cartId": id,
        "lines": {
          "id": idLine,
          "merchandiseId": variantId,
          "quantity": qty,
        }
      },
    );

    await _client.query(options);
  }

  Future<void> cartRemove(String id, String idLine) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation cartLinesRemove($cartId: ID!, $lineIds: [ID!]!) {
          cartLinesRemove(cartId: $cartId, lineIds: $lineIds) {
            cart {
              # Cart fields
            }
            userErrors {
              field
              message
            }
          }
        }
      ''',
      ),
      variables: {"cartId": id, "lineIds": idLine},
    );

    await _client.query(options);
  }

  Future<void> cartBuyerIdentityupdate(
      String id, String customerToken, UserModel user) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation cartBuyerIdentityUpdate($buyerIdentity: CartBuyerIdentityInput!, $cartId: ID!) {
          cartBuyerIdentityUpdate(buyerIdentity: $buyerIdentity, cartId: $cartId) {
            cart {
              # Cart fields
              id
            }
            userErrors {
              field
              message
            }
          }
        }
      ''',
      ),
      variables: {
        "buyerIdentity": {
          "countryCode": user.defaultAddress!.countryCodeV2,
          "customerAccessToken": customerToken,
          "email": user.email,
          "phone": user.phone
        },
        "cartId": id
      },
    );

    await _client.query(options);
  }

  Future<String> cartCheckout(String id) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        '''
        query checkoutURL {
          cart(id: "$id") {
            checkoutUrl
          }
        }
      ''',
      ),
      variables: {},
    );

    var result = await _client.query(options);
    return result.data!["cart"]["checkoutUrl"];
  }

  Future<dynamic> cartDiscountCodesUpdate(dynamic variables) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
          mutation cartDiscountCodesUpdate($cartId: ID!, $discountCodes: [String!]) {
            cartDiscountCodesUpdate(cartId: $cartId, discountCodes: $discountCodes) {
              cart {
                # Cart fields
                id
                discountCodes{
                applicable
                code
                }
                discountAllocations{
                    discountedAmount{
                        amount
                    }
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
      variables: variables,
    );

    var result = await _client.query(options);
    return result.data;
  }
}

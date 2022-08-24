import 'package:colorbox/app/services/shopify_graphql.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class OrderProvider extends GetConnect {
  Future<dynamic> getOrders(String id) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        '''
        {
          customer(id:"$id") {
            id
            orders(first:10){
              edges{
                node {
                  id
                  createdAt
                  name
                  fulfillments{
                      status
                  }
                  lineItems(first: 10){
                      pageInfo{
                          hasNextPage
                          endCursor
                      }
                      edges{
                          node{
                              title
                              variantTitle
                              quantity
                              originalUnitPriceSet{
                                  presentmentMoney{amount}
                                  shopMoney{amount}
                              }
                              originalTotalSet{
                                  presentmentMoney{amount}
                                  shopMoney{amount}
                              }
                              image{
                                  url
                              }
                          }
                      }
                  }
                  shippingAddress{
                      id
                      firstName
                      lastName
                      address1
                      address2
                      city
                      company
                      country
                      countryCodeV2
                      phone
                      province
                      provinceCode
                      zip
                  }
                  shippingLine{
                      code
                      title
                      shippingRateHandle
                      originalPriceSet{
                          presentmentMoney{
                              amount
                          }
                          shopMoney{
                              amount
                          }
                      }
                  }
                  events(first:10){
                    edges{
                      node{
                        message
                        createdAt
                      }
                    }
                  }
                  tags
                  cancelReason
                  displayFinancialStatus
                  totalPriceSet {
                    presentmentMoney {
                        amount
                    }
                    shopMoney {
                        amount
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

    return result.data!['customer'];
  }
}

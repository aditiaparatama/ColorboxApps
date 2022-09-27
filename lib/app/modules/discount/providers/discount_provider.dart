import 'package:colorbox/app/services/shopify_graphql.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class DiscountProvider extends GetConnect {
  Future<dynamic> getDiscount() async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        {
          discountNodes(first: 10, query: "status:active") {
            # DiscountNodeConnection fields
            edges{
                node{
                    discount {
                        __typename
                        ...on DiscountCodeBasic{
                            appliesOncePerCustomer
                            asyncUsageCount
                            combinesWith{
                                orderDiscounts
                                productDiscounts
                                shippingDiscounts
                            }
                            customerGets{
                                appliesOnOneTimePurchase
                                appliesOnSubscription
                            }
                            customerSelection{
                                __typename
                                ...on DiscountCustomerAll {
                                    allCustomers
                                }
                                __typename
                                ...on DiscountCustomerSegments  {
                                    segments{
                                        id
                                        name
                                        query
                                    }
                                }
                                __typename
                                ...on DiscountCustomers {
                                    customers{
                                        email
                                    }
                                }
                            }
                            createdAt
                            endsAt
                            minimumRequirement{
                                __typename
                                ...on DiscountMinimumQuantity{
                                    greaterThanOrEqualToQuantity
                                }
                                __typename
                                ...on DiscountMinimumSubtotal{
                                    greaterThanOrEqualToSubtotal{
                                        amount
                                    }
                                }
                            }
                            recurringCycleLimit
                            shortSummary
                            startsAt
                            status
                            summary
                            title
                            totalSales{
                                amount
                            }
                            usageLimit
                        }
                    }
                    id
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

  Future<dynamic> getDiscountAutomatic() async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        {
          automaticDiscountNodes(first:2, query:"status:active"){
              edges{
                  node{
                      automaticDiscount{
                          __typename
                          ...on DiscountAutomaticBasic{
                              title
                              customerGets{
                                  appliesOnOneTimePurchase
                                  appliesOnSubscription
                                  items{
                                      __typename
                                      ...on DiscountCollections{
                                          collections(first:1){
                                              edges{
                                                  node{
                                                      id
                                                      handle
                                                  }
                                              }
                                          }
                                      }
                                  }
                              }
                          }
                          ...on DiscountAutomaticBxgy{
                              title
                              customerGets{
                                  appliesOnOneTimePurchase
                                  appliesOnSubscription
                                  items{
                                      __typename
                                      ...on DiscountCollections{
                                          collections(first:15){
                                              edges{
                                                  node{
                                                      id
                                                      handle
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
          }
      }
      ''',
      ),
    );

    final QueryResult result = await _client.query(options);

    return result.data;
  }
}

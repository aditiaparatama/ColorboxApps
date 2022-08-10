import 'package:colorbox/globalvar.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class DiscountProvider extends GetConnect {
  Future<dynamic> getDiscount() async {
    final GraphQLClient _client = GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(
        url_shopify + 'graphql.json',
        defaultHeaders: {'X-Shopify-Access-Token': token},
      ),
    );

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
}

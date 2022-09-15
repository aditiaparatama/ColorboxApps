import 'package:colorbox/app/services/shopify_graphql.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class OrderProvider extends GetConnect {
  Future<dynamic> getOrders(String id, {String query = ""}) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        '''
        {
          customer(id:"$id") {
            id
            orders(first:5, reverse: true $query){
                pageInfo{
                    hasNextPage
                    endCursor
                }
                edges{
                    node {
                        id
                        createdAt
                        name
                        fulfillments{
                            status
                        }
                        discountApplications(first: 2){
                            edges{
                                node{
                                    __typename 
                                        ... on DiscountCodeApplication{
                                            code
                                            value{
                                                __typename 
                                                ... on MoneyV2{
                                                    amount
                                                }
                                                __typename
                                                ... on PricingPercentageValue{
                                                    percentage
                                                }
                                            }
                                        }
                                        __typename 
                                        ... on AutomaticDiscountApplication{
                                            title
                                            value{
                                                __typename 
                                                ... on MoneyV2{
                                                    amount
                                                }
                                                __typename
                                                ... on PricingPercentageValue{
                                                    percentage
                                                }
                                            }
                                        }
                                }
                            }
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
                                    discountAllocations{
                                        discountApplication{
                                            __typename 
                                                ... on DiscountCodeApplication{
                                                    code
                                                    value{
                                                        __typename 
                                                        ... on MoneyV2{
                                                            amount
                                                        }
                                                        __typename
                                                        ... on PricingPercentageValue{
                                                            percentage
                                                        }
                                                    }
                                                }
                                                __typename 
                                                ... on AutomaticDiscountApplication{
                                                    title
                                                    value{
                                                        __typename 
                                                        ... on MoneyV2{
                                                            amount
                                                        }
                                                        __typename
                                                        ... on PricingPercentageValue{
                                                            percentage
                                                        }
                                                    }
                                                }
                                        }
                                        allocatedAmountSet{
                                            presentmentMoney{amount}
                                            shopMoney{amount}
                                        }
                                    }
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
                        subtotalLineItemsQuantity
                        subtotalPriceSet{
                            presentmentMoney {
                                amount
                            }
                            shopMoney {
                                amount
                            }
                        }
                        totalPriceSet {
                            presentmentMoney {
                                amount
                            }
                            shopMoney {
                                amount
                            }
                        }
                        totalDiscountsSet{
                            presentmentMoney{
                                amount
                            }
                            shopMoney{
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

    return result.data;
  }

  Future<dynamic> getOrdersNext(String id, String cursor,
      {String query = ""}) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        '''
        {
          customer(id:"$id") {
            id
            orders(first:5, reverse: true, after: "$cursor" $query){
                pageInfo{
                    hasNextPage
                    endCursor
                }
                edges{
                    node {
                        id
                        createdAt
                        name
                        fulfillments{
                            status
                        }
                        discountApplications(first: 2){
                            edges{
                                node{
                                    __typename 
                                        ... on DiscountCodeApplication{
                                            code
                                            value{
                                                __typename 
                                                ... on MoneyV2{
                                                    amount
                                                }
                                                __typename
                                                ... on PricingPercentageValue{
                                                    percentage
                                                }
                                            }
                                        }
                                        __typename 
                                        ... on AutomaticDiscountApplication{
                                            title
                                            value{
                                                __typename 
                                                ... on MoneyV2{
                                                    amount
                                                }
                                                __typename
                                                ... on PricingPercentageValue{
                                                    percentage
                                                }
                                            }
                                        }
                                        ... on ManualDiscountApplication{
                                            title
                                            value{
                                                __typename 
                                                ... on MoneyV2{
                                                    amount
                                                }
                                                __typename
                                                ... on PricingPercentageValue{
                                                    percentage
                                                }
                                            }
                                        }
                                }
                            }
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
                                    discountAllocations{
                                        discountApplication{
                                            __typename 
                                                ... on DiscountCodeApplication{
                                                    code
                                                    value{
                                                        __typename 
                                                        ... on MoneyV2{
                                                            amount
                                                        }
                                                        __typename
                                                        ... on PricingPercentageValue{
                                                            percentage
                                                        }
                                                    }
                                                }
                                                __typename 
                                                ... on AutomaticDiscountApplication{
                                                    title
                                                    value{
                                                        __typename 
                                                        ... on MoneyV2{
                                                            amount
                                                        }
                                                        __typename
                                                        ... on PricingPercentageValue{
                                                            percentage
                                                        }
                                                    }
                                                }
                                                __typename 
                                                ... on ManualDiscountApplication{
                                                    title
                                                    value{
                                                        __typename 
                                                        ... on MoneyV2{
                                                            amount
                                                        }
                                                        __typename
                                                        ... on PricingPercentageValue{
                                                            percentage
                                                        }
                                                    }
                                                }
                                        }
                                        allocatedAmountSet{
                                            presentmentMoney{amount}
                                            shopMoney{amount}
                                        }
                                    }
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
                        subtotalLineItemsQuantity
                        subtotalPriceSet{
                            presentmentMoney {
                                amount
                            }
                            shopMoney {
                                amount
                            }
                        }
                        totalPriceSet {
                            presentmentMoney {
                                amount
                            }
                            shopMoney {
                                amount
                            }
                        }
                        totalDiscountsSet{
                            presentmentMoney{
                                amount
                            }
                            shopMoney{
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

  Future<dynamic> getActiveOrders(String id, String tgl, String? cursor) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    String query = (cursor == null)
        ? '''
        {
          customer(id:"$id") {
            id
            orders(first:20, query:"(NOT financial_status:expired) AND NOT status:cancelled"){
                pageInfo{
                    hasNextPage
                    endCursor
                }
                edges{
                    node {
                        id
                    }
                }
            }
          }
        }
      '''
        : '''
        {
          customer(id:"$id") {
            id
            orders(first:20, query:"NOT financial_status:expired", after: "$cursor"){
                pageInfo{
                    hasNextPage
                    endCursor
                }
                edges{
                    node {
                        id
                    }
                }
            }
          }
        }
      ''';

    final QueryOptions options = QueryOptions(
      document: gql(
        query,
      ),
      variables: {},
    );

    final QueryResult result = await _client.query(options);

    return result.data!['customer'];
  }
}

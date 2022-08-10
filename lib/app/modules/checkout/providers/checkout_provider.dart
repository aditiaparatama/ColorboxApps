import 'package:colorbox/app/data/models/mailing_address.dart';
import 'package:colorbox/app/modules/checkout/models/checkout_model.dart';
import 'package:colorbox/app/services/shopify_graphql.dart';
import 'package:colorbox/globalvar.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class CheckoutProvider extends GetConnect {
  Future<dynamic> checkoutCreate(
      List<CheckoutItems> items, dynamic variable) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation checkoutCreate($input: CheckoutCreateInput!) {
          checkoutCreate(input: $input) {
            checkout {
              # Checkout fields
              id
              availableShippingRates {
                ready
                shippingRates {
                  handle
                  priceV2 {
                    amount
                  }
                  title
                }
              }
              buyerIdentity{
                  countryCode
              }
              discountApplications(first: 5){
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
              discountApplications(first: 5){
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
                    }
                }
            }
              email
              lineItemsSubtotalPrice{
                  amount
              }
              lineItems(first:10){
                  edges{
                      node{
                          id
                          title
                          quantity
                          unitPrice{
                              amount
                          }
                          variant{
                              id
                              product {
                                title
                              }
                              title
                              sku
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
                          discountAllocations{
                              allocatedAmount{
                                  amount
                              }
                              discountApplication{
                                  allocationMethod
                                  targetSelection
                                  targetType
                                  value {
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
              }
              note
              orderStatusUrl
              paymentDueV2{
                  amount
              }
              ready
              requiresShipping
              shippingAddress{
                  address1
                  address2
                  city
                  company
                  country
                  firstName
                  lastName
                  phone
                  province
                  zip
              }
              shippingDiscountAllocations{
                  allocatedAmount{
                      amount
                  }
                  discountApplication{
                    allocationMethod
                    targetSelection
                    targetType
                    value {
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
              shippingLine{
                  handle
                  priceV2{
                      amount
                  }
                  title
              }
              subtotalPriceV2{
                  amount
              }
              taxExempt
              taxesIncluded
              totalDuties{
                  amount
              }
              totalPriceV2{
                  amount
              }
              webUrl
            }
            checkoutUserErrors {
              # CheckoutUserError fields
              code
              message
            }
            queueToken
          }
        }
      ''',
      ),
      variables: variable,
    );

    final QueryResult result = await _client.query(options);

    return result.data;
  }

  Future<dynamic> checkoutGetData(String id) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        '''
        {
          node(id: "$id") 
          {
            ... on Checkout {
              # Checkout fields
              id
              availableShippingRates {
                ready
                shippingRates {
                  handle
                  priceV2 {
                    amount
                  }
                  title
                }
              }
              buyerIdentity{
                  countryCode
              }
              discountApplications(first: 5){
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
                    }
                }
            }
              email
              lineItemsSubtotalPrice{
                  amount
              }
              lineItems(first:10){
                  edges{
                      node{
                          id
                          title
                          quantity
                          unitPrice{
                              amount
                          }
                          variant{
                              id
                              product {
                                title
                              }
                              title
                              sku
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
                          discountAllocations{
                              allocatedAmount{
                                  amount
                              }
                              discountApplication{
                                  allocationMethod
                                  targetSelection
                                  targetType
                                  value {
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
              }
              note
              orderStatusUrl
              paymentDueV2{
                  amount
              }
              ready
              requiresShipping
              shippingAddress{
                  address1
                  address2
                  city
                  company
                  country
                  firstName
                  lastName
                  phone
                  province
                  zip
              }
              shippingDiscountAllocations{
                  allocatedAmount{
                      amount
                  }
                  discountApplication{
                    allocationMethod
                    targetSelection
                    targetType
                    value {
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
              shippingLine{
                  handle
                  priceV2{
                      amount
                  }
                  title
              }
              subtotalPriceV2{
                  amount
              }
              taxExempt
              taxesIncluded
              totalDuties{
                  amount
              }
              totalPriceV2{
                  amount
              }
              webUrl
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

  Future<dynamic> checkoutShippingLineUpdate(
      String id, String shippingRateHandle) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation checkoutShippingLineUpdate($checkoutId: ID!, $shippingRateHandle: String!) {
          checkoutShippingLineUpdate(checkoutId: $checkoutId, shippingRateHandle: $shippingRateHandle) {
            checkout {
              # Checkout fields
              id
              availableShippingRates {
                ready
                shippingRates {
                  handle
                  priceV2 {
                    amount
                  }
                  title
                }
              }
              buyerIdentity{
                  countryCode
              }
              discountApplications(first: 5){
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
                    }
                }
            }
              email
              lineItemsSubtotalPrice{
                  amount
              }
              lineItems(first:10){
                  edges{
                      node{
                          id
                          title
                          quantity
                          unitPrice{
                              amount
                          }
                          variant{
                              id
                              product {
                                title
                              }
                              title
                              sku
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
                          discountAllocations{
                              allocatedAmount{
                                  amount
                              }
                              discountApplication{
                                  allocationMethod
                                  targetSelection
                                  targetType
                                  value {
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
              }
              note
              orderStatusUrl
              paymentDueV2{
                  amount
              }
              ready
              requiresShipping
              shippingAddress{
                  address1
                  address2
                  city
                  company
                  country
                  firstName
                  lastName
                  phone
                  province
                  zip
              }
              shippingDiscountAllocations{
                  allocatedAmount{
                      amount
                  }
                  discountApplication{
                    allocationMethod
                    targetSelection
                    targetType
                    value {
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
              shippingLine{
                  handle
                  priceV2{
                      amount
                  }
                  title
              }
              subtotalPriceV2{
                  amount
              }
              taxExempt
              taxesIncluded
              totalDuties{
                  amount
              }
              totalPriceV2{
                  amount
              }
              webUrl
            }
            checkoutUserErrors {
              # CheckoutUserError fields
              code
              message
            }
          }
        }
      ''',
      ),
      variables: {"checkoutId": id, "shippingRateHandle": shippingRateHandle},
    );

    final QueryResult result = await _client.query(options);

    return result.data;
  }

  Future<dynamic> checkoutShippingAddressUpdateV2(
      String id, MailingAddress address) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation checkoutShippingAddressUpdateV2($checkoutId: ID!, $shippingAddress: MailingAddressInput!) {
          checkoutShippingAddressUpdateV2(checkoutId: $checkoutId, shippingAddress: $shippingAddress) {
            checkout {
              # Checkout fields
              id
              availableShippingRates {
                ready
                shippingRates {
                  handle
                  priceV2 {
                    amount
                  }
                  title
                }
              }
              buyerIdentity{
                  countryCode
              }
              discountApplications(first: 5){
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
                    }
                }
            }
              email
              lineItemsSubtotalPrice{
                  amount
              }
              lineItems(first:10){
                  edges{
                      node{
                          id
                          title
                          quantity
                          unitPrice{
                              amount
                          }
                          variant{
                              id
                              product {
                                title
                              }
                              title
                              sku
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
                          discountAllocations{
                              allocatedAmount{
                                  amount
                              }
                              discountApplication{
                                  allocationMethod
                                  targetSelection
                                  targetType
                                  value {
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
              }
              note
              orderStatusUrl
              paymentDueV2{
                  amount
              }
              ready
              requiresShipping
              shippingAddress{
                  address1
                  address2
                  city
                  company
                  country
                  firstName
                  lastName
                  phone
                  province
                  zip
              }
              shippingDiscountAllocations{
                  allocatedAmount{
                      amount
                  }
                  discountApplication{
                    allocationMethod
                    targetSelection
                    targetType
                    value {
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
              shippingLine{
                  handle
                  priceV2{
                      amount
                  }
                  title
              }
              subtotalPriceV2{
                  amount
              }
              taxExempt
              taxesIncluded
              totalDuties{
                  amount
              }
              totalPriceV2{
                  amount
              }
              webUrl
            }
            checkoutUserErrors {
              # CheckoutUserError fields
              code
              message
            }
          }
        }
      ''',
      ),
      variables: {
        "checkoutId": id,
        "shippingAddress": {
          "address1": address.address1,
          "address2": address.address2,
          "city": address.city,
          "company": address.company,
          "country": address.country,
          "firstName": address.firstName,
          "lastName": address.lastName,
          "phone": address.phone,
          "province": address.province,
          "zip": address.zip
        }
      },
    );

    final QueryResult result = await _client.query(options);

    return result.data;
  }

  Future<dynamic> checkoutDiscountCodeApplyV2(
      {String id = "", String discountCode = ""}) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation checkoutDiscountCodeApplyV2($checkoutId: ID!, $discountCode: String!) {
          checkoutDiscountCodeApplyV2(checkoutId: $checkoutId, discountCode: $discountCode) {
            checkout {
              # Checkout fields
              id
              availableShippingRates {
                ready
                shippingRates {
                  handle
                  priceV2 {
                    amount
                  }
                  title
                }
              }
              buyerIdentity{
                  countryCode
              }
              discountApplications(first: 5){
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
                    }
                }
              }
              email
              lineItemsSubtotalPrice{
                  amount
              }
              lineItems(first:10){
                  edges{
                      node{
                          id
                          title
                          quantity
                          unitPrice{
                              amount
                          }
                          variant{
                              id
                              product {
                                title
                              }
                              title
                              sku
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
                          discountAllocations{
                              allocatedAmount{
                                  amount
                              }
                              discountApplication{
                                  allocationMethod
                                  targetSelection
                                  targetType
                                  value {
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
              }
              note
              orderStatusUrl
              paymentDueV2{
                  amount
              }
              ready
              requiresShipping
              shippingAddress{
                  address1
                  address2
                  city
                  company
                  country
                  firstName
                  lastName
                  phone
                  province
                  zip
              }
              shippingDiscountAllocations{
                  allocatedAmount{
                      amount
                  }
                  discountApplication{
                    allocationMethod
                    targetSelection
                    targetType
                    value {
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
              shippingLine{
                  handle
                  priceV2{
                      amount
                  }
                  title
              }
              subtotalPriceV2{
                  amount
              }
              taxExempt
              taxesIncluded
              totalDuties{
                  amount
              }
              totalPriceV2{
                  amount
              }
              webUrl
            }
            checkoutUserErrors {
              # CheckoutUserError fields
              code
              message
            }
          }
        }
      ''',
      ),
      variables: {"checkoutId": id, "discountCode": discountCode},
    );

    final QueryResult result = await _client.query(options);

    return result.data;
  }

  Future<dynamic> checkoutDiscountCodeRemove({String id = ""}) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation checkoutDiscountCodeRemove($checkoutId: ID!) {
          checkoutDiscountCodeRemove(checkoutId: $checkoutId) {
            checkout {
              # Checkout fields
              id
              availableShippingRates {
                ready
                shippingRates {
                  handle
                  priceV2 {
                    amount
                  }
                  title
                }
              }
              buyerIdentity{
                  countryCode
              }
              discountApplications(first: 5){
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
                    }
                }
              }
              email
              lineItemsSubtotalPrice{
                  amount
              }
              lineItems(first:10){
                  edges{
                      node{
                          id
                          title
                          quantity
                          unitPrice{
                              amount
                          }
                          variant{
                              id
                              product {
                                title
                              }
                              title
                              sku
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
                          discountAllocations{
                              allocatedAmount{
                                  amount
                              }
                              discountApplication{
                                  allocationMethod
                                  targetSelection
                                  targetType
                                  value {
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
              }
              note
              orderStatusUrl
              paymentDueV2{
                  amount
              }
              ready
              requiresShipping
              shippingAddress{
                  address1
                  address2
                  city
                  company
                  country
                  firstName
                  lastName
                  phone
                  province
                  zip
              }
              shippingDiscountAllocations{
                  allocatedAmount{
                      amount
                  }
                  discountApplication{
                    allocationMethod
                    targetSelection
                    targetType
                    value {
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
              shippingLine{
                  handle
                  priceV2{
                      amount
                  }
                  title
              }
              subtotalPriceV2{
                  amount
              }
              taxExempt
              taxesIncluded
              totalDuties{
                  amount
              }
              totalPriceV2{
                  amount
              }
              webUrl
            }
            checkoutUserErrors {
              # CheckoutUserError fields
              code
              message
            }
          }
        }
      ''',
      ),
      variables: {"checkoutId": id},
    );

    final QueryResult result = await _client.query(options);

    return result.data;
  }

  Future<dynamic> getShippingRates(body) async {
    try {
      var response = await post(urlShipping, body);
      // while (!response.isOk) {
      //   response = await post(url_shipping, body);
      // }

      var data = response.body['rates'];

      return data;
    } catch (e) {
      return {"message": e.toString()};
    }
  }
}

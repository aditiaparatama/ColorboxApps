import 'package:colorbox/app/data/models/mailing_address.dart';
import 'package:colorbox/app/services/shopify_graphql.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class ProfileProvider extends GetConnect {
  Future<dynamic> login(String email, String password) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation customerAccessTokenCreate($input: CustomerAccessTokenCreateInput!) {
          customerAccessTokenCreate(input: $input) {
            customerAccessToken {
              # CustomerAccessToken fields
                accessToken
                expiresAt
            }
            customerUserErrors {
              # CustomerUserError fields
              message
            }
          }
        }
      ''',
      ),
      variables: {
        "input": {"email": email.toLowerCase(), "password": password}
      },
    );

    final QueryResult result = await _client.query(options);

    return result.data!['customerAccessTokenCreate'];
  }

  Future<dynamic> register(
      String email, String password, String firstN, String lastN) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation customerCreate($input: CustomerCreateInput!) {
          customerCreate(input: $input) {
            customer {
              # Customer fields
              id
            }
            customerUserErrors {
              # CustomerUserError fields
              message
            }
          }
        }
      ''',
      ),
      variables: {
        "input": {
          "acceptsMarketing": false,
          "email": email.toLowerCase(),
          "firstName": firstN,
          "lastName": lastN,
          "password": password
        }
      },
    );

    final QueryResult result = await _client.query(options);

    if (result.data == null) return {"id": "", "msg": ""};

    if (result.data!['customerCreate']['customerUserErrors'].length > 0) {
      if (result.data!['customerCreate']['customerUserErrors'][0]["message"] !=
              "Email sudah diambil" &&
          result.data!['customerCreate']['customerUserErrors'][0]["message"] !=
              "Email has already been taken") {
        Get.snackbar("Warning",
            result.data!['customerCreate']['customerUserErrors'][0]["message"]);
      }
      return {
        "id": "",
        "msg": result.data!['customerCreate']['customerUserErrors'][0]
            ["message"]
      };
    }

    return {
      "id": result.data!['customerCreate']['customer']['id'],
      "msg": "success"
    };
  }

  Future<String> forgotpassword(String email) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation customerRecover($email: String!) {
          customerRecover(email: $email) {
            customerUserErrors {
              # CustomerUserError fields
            }
          }
        }
      ''',
      ),
      variables: {"email": email.toLowerCase()},
    );

    final QueryResult result = await _client.query(options);

    if (result.data!['customerRecover']['customerUserErrors'].length > 0) {
      Get.snackbar("Warning",
          result.data!['customerRecover']['customerUserErrors'][0]["message"]);
      return "1";
    } else {
      return "success";
    }
  }

  Future<dynamic> getUser(String token) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        '''
        {
          customer(customerAccessToken:"$token") {
            id
            displayName
            firstName
            lastName
            email
            phone
            addresses(first:10){
                edges{
                    node {
                        id
                        firstName
                        lastName
                        address1
                        address2
                        company
                        city
                        country
                        countryCodeV2
                        phone
                        province
                        provinceCode
                        zip
                    }
                }
            }
            defaultAddress{
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
          }
        }
      ''',
      ),
      variables: {},
    );

    final QueryResult result = await _client.query(options);

    return result.data!['customer'];
  }

  Future<dynamic> getUserFromAdmin(String id) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        '''
        {
          customer(id:"$id") {
            id
            displayName
            firstName
            lastName
            email
            phone
            note
            addresses(first:10){
                id
                firstName
                lastName
                address1
                address2
                company
                city
                country
                countryCodeV2
                phone
                province
                provinceCode
                zip
            }
            defaultAddress{
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
            orders(first:10){
                edges{
                    node {
                        id
                        name
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

  Future<dynamic> checkExistUser(String email) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        '''
        {
          customers(first: 1, query: "email:$email") {
            # CustomerConnection fields
            edges{
                node{
                    id
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

  Future<dynamic> customerUpdate(dynamic variables) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
          mutation customerUpdate($input: CustomerInput!) {
            customerUpdate(input: $input) {
              customer {
                # Customer fields
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
      variables: variables,
    );

    final QueryResult result = await _client.query(options);

    return result.data!;
  }

  Future<dynamic> customerDefaultAddressUpdate(String token, String id) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation customerDefaultAddressUpdate($addressId: ID!, $customerAccessToken: String!) {
          customerDefaultAddressUpdate(addressId: $addressId, customerAccessToken: $customerAccessToken) {
            customer {
              # Customer fields
              id
              displayName
              firstName
              lastName
              email
              phone
              addresses(first:10){
                  edges{
                      node {
                          id
                          firstName
                          lastName
                          address1
                          address2
                          company
                          city
                          country
                          countryCodeV2
                          phone
                          province
                          provinceCode
                          zip
                      }
                  }
              }
              defaultAddress{
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
            }
            customerUserErrors {
              # CustomerUserError fields
              code
              message
            }
          }
        }
      ''',
      ),
      variables: {"addressId": id, "customerAccessToken": token},
    );

    final QueryResult result = await _client.query(options);

    return result.data!;
  }

  Future<dynamic> customerAddressDelete(String token, String id) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation customerAddressDelete($customerAccessToken: String!, $id: ID!) {
          customerAddressDelete(customerAccessToken: $customerAccessToken, id: $id) {
            customerUserErrors {
              # CustomerUserError fields
                code
                message
              }
              deletedCustomerAddressId
            }
          }
      ''',
      ),
      variables: {"customerAccessToken": token, "id": id},
    );

    final QueryResult result = await _client.query(options);

    return result.data!;
  }

  Future<dynamic> customerAddressCreate(
      String token, MailingAddress address) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation customerAddressCreate($address: MailingAddressInput!, $customerAccessToken: String!) {
          customerAddressCreate(address: $address, customerAccessToken: $customerAccessToken) {
            customerAddress {
              # MailingAddress fields
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
            customerUserErrors {
              # CustomerUserError fields
              code
              message
            }
          }
        }
      ''',
      ),
      variables: {
        "address": {
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
        },
        "customerAccessToken": token
      },
    );

    final QueryResult result = await _client.query(options);

    return result.data!['customerAddressCreate'];
  }

  Future<dynamic> customerAddressUpdate(
      String token, MailingAddress address, String id) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation customerAddressUpdate($address: MailingAddressInput!, $customerAccessToken: String!, $id: ID!) {
          customerAddressUpdate(address: $address, customerAccessToken: $customerAccessToken, id: $id) {
            customerAddress {
              # MailingAddress fields
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
            customerUserErrors {
              # CustomerUserError fields
              code
              message
            }
          }
        }
      ''',
      ),
      variables: {
        "address": {
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
        },
        "customerAccessToken": token,
        "id": id
      },
    );

    final QueryResult result = await _client.query(options);

    return result.data!['customerAddressUpdate'];
  }

  Future<dynamic> customerAddressUpdateByAdmin(dynamic variables) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation customerUpdate($input: CustomerInput!) {
          customerUpdate(input: $input) {
            customer {
              # Customer fields
              id
              displayName
              firstName
              lastName
              email
              phone
              note
              addresses(first:10){
                  id
                  firstName
                  lastName
                  address1
                  address2
                  company
                  city
                  country
                  countryCodeV2
                  phone
                  province
                  provinceCode
                  zip
              }
              defaultAddress{
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
              orders(first:10){
                  edges{
                      node {
                          id
                          name
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

    return result.data!['customerUpdate'];
  }

  Future<dynamic> addAddressByAdmin(String id, dynamic variables) async {
    var response = await post(
        url_shopify + "customers/$id/addresses.json", variables,
        headers: {"X-Shopify-Access-Token": token});

    var data = response.body;

    return data;
  }

  Future<bool> deleteAddressByAdmin(String id, String addressId) async {
    var response = await delete(
        url_shopify + "customers/$id/addresses/$addressId.json",
        headers: {"X-Shopify-Access-Token": token});
    if (response.body.contains("errors") &&
        response.body["errors"]["base"][0] ==
            "Cannot delete the customer’s default address") {
      Get.snackbar("Error", "Alamat utama tidak dapat dihapus",
          backgroundColor: colorTextBlack,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM);
    }
    return response.isOk;
  }

  Future<dynamic> customerUpdateDefaultAddressByAdmin(dynamic variables) async {
    final GraphQLClient _client = getShopifyGraphQLClient(admin: true);

    final QueryOptions options = QueryOptions(
      document: gql(
        r'''
        mutation customerUpdateDefaultAddress($addressId: ID!, $customerId: ID!) {
          customerUpdateDefaultAddress(addressId: $addressId, customerId: $customerId) {
            customer {
              # Customer fields
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
      variables: variables,
    );

    final QueryResult result = await _client.query(options);

    return result.data;
  }

  Future<List<dynamic>> getProvince() async {
    var response = await get(url_shopify + "countries.json");
    while (!response.isOk) {
      response = await get(url_shopify + "countries.json",
          headers: {"X-Shopify-Access-Token": token});
    }

    var data = response.body['countries'];

    return data;
  }

  Future<dynamic> getCity(String province) async {
    var response = await get(urlCity + province);

    var data = response.body;

    return data;
  }
}

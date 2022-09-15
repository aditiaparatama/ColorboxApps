import 'package:colorbox/app/data/models/mailing_address.dart';
import 'package:colorbox/app/services/shopify_graphql.dart';
import 'package:colorbox/globalvar.dart';
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
          "Email sudah diambil") {
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

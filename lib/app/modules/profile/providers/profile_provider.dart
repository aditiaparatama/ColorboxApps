import 'package:colorbox/app/services/shopify_graphql.dart';
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

  Future<String> register(String email, String password, String firstName,
      String lastName, String phone) async {
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
          "firstName": firstName,
          "lastName": lastName,
          "password": password,
          "phone": phone
        }
      },
    );

    final QueryResult result = await _client.query(options);

    if (result.data!['customerCreate']['customerUserErrors'].length > 0) {
      Get.snackbar("Warning",
          result.data!['customerCreate']['customerUserErrors'][0]["message"]);
      return "";
    }

    return "success";
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
            orders(first:5){
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
}

import 'package:colorbox/app/services/shopify_graphql.dart';
import 'package:get/get.dart';
import 'package:graphql/client.dart';

class ProductProvider extends GetConnect {
  Future<dynamic> getProduct(dynamic ids) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        '''
        {
          nodes(ids: $ids) {
            ...on Product {
                      id
                      title
                      description
                      handle
                      tags
                      productType
                      totalInventory
                      options {
                      name
                      values
                      }
                      images(first: 5){
                      edges {
                          node {
                              src
                          }
                      }
                      }
                      collections(first:1){
                          edges{
                              node{
                                  id
                              }
                          }
                      }
                      variants(first: 10){
                      edges {
                          node {
                              id
                              price
                              barcode
                              compareAtPrice
                              quantityAvailable
                              sku
                              selectedOptions{
                                  name
                                  value
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

  Future<dynamic> getProductByHandle(dynamic handle) async {
    final GraphQLClient _client = getShopifyGraphQLClient();

    final QueryOptions options = QueryOptions(
      document: gql(
        '''
        {
          product(handle:"$handle") {
              id
                  title
                  handle
                  description
                  descriptionHtml
                  tags
                  productType
                  totalInventory
                  options {
                      name
                      values
                  }
                  images(first: 5){
                      edges {
                          node {
                              src
                          }
                      }
                  }
                  variants(first: 10){
                      edges {
                          node {
                              id
                              price
                              barcode
                              compareAtPrice
                              quantityAvailable
                              sku
                              selectedOptions{
                                  name
                                  value
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

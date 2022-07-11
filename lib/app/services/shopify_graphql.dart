import 'package:colorbox/globalvar.dart';
import 'package:graphql/client.dart';

GraphQLClient getShopifyGraphQLClient({bool admin = false}) {
  var headers = admin
      ? {'X-Shopify-Access-Token': token}
      : {'X-Shopify-Storefront-Access-Token': tokenFront};
  final Link _link = HttpLink(
    admin ? url_shopify : urlStoreFront + 'graphql.json',
    defaultHeaders: headers,
  );

  return GraphQLClient(
    cache: GraphQLCache(),
    link: _link,
  );
}

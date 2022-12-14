import 'package:colorbox/app/modules/collections/models/product_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

AnalyticsEventItem itemCreator(Product product) {
  return AnalyticsEventItem(
    itemCategory: product.idCollection,
    itemId: product.id,
    itemName: product.title,
    itemVariant: product.variants[0].title,
    price: double.parse(product.variants[0].price!),
    currency: 'IDR',
    quantity: 1,
  );
}

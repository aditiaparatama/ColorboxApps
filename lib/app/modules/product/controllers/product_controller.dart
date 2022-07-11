import 'package:colorbox/app/modules/collections/models/product_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  Product product = Product.isEmpty();

  Variants? variant;
  String textCart = "Add Cart";

  void getSelectedValue(String size, String color) {
    for (int i = 0; i < product.variants.length; i++) {
      if (product.variants[i].options.length > 1) {
        if (product.variants[i].options[0].value == size &&
            product.variants[i].options[1].value == color) {
          variant = product.variants[i];
          break;
        }
      } else {
        if (product.variants[i].options[0].value == size) {
          variant = product.variants[i];
          break;
        }
      }
    }
    update();
  }

  int getStock(String size, String color) {
    int stock = 0;
    for (int i = 0; i < product.variants.length; i++) {
      if (product.variants[i].options.length > 1) {
        if (product.variants[i].options[0].value == size &&
            product.variants[i].options[1].value == color) {
          stock = product.variants[i].inventoryQuantity!;
          break;
        }
      } else {
        if (product.variants[i].options[0].value == size) {
          stock = product.variants[i].inventoryQuantity!;
          break;
        }
      }
    }
    return stock;
  }
}

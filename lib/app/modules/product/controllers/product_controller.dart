import 'package:colorbox/app/modules/collections/models/product_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  Product product = Product.isEmpty();

  Variants? variant;
  String ukuran = "";
  String desk = "";
  String textCart = "Add Cart";

  void getSelectedValue(String size, String color) {
    for (int i = 0; i < product.variants.length; i++) {
      if (product.variants[i].options.length > 1) {
        if (product.variants[i].options[0].value == size &&
            product.variants[i].options[1].value == color) {
          if (product.variants[i].options[0].value == 'XS') {
            ukuran = "Extra Small";
          } else if (product.variants[i].options[0].value == 'S') {
            ukuran = "Small";
            break;
          } else if (product.variants[i].options[0].value == 'M') {
            ukuran = "Medium";
            break;
          } else if (product.variants[i].options[0].value == 'L') {
            ukuran = "Large";
            break;
          } else if (product.variants[i].options[0].value == 'XL') {
            ukuran = "Extra Large";
            break;
          } else if (product.variants[i].options[0].value == 'XXL') {
            ukuran = "Double Extra Large";
            break;
          } else {
            ukuran = product.variants[i].options[0].value!;
            break;
          }

          // variant = product.variants[i];
          // break;
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

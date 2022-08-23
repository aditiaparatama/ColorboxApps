import 'package:colorbox/app/modules/collections/models/product_model.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final LocalStorageData localStorageData = Get.find();
  Product product = Product.isEmpty();
  UserModel _userModel = UserModel.isEmpty();
  UserModel get userModel => _userModel;
  CustomerToken? _token = CustomerToken.isEmpty();
  CustomerToken? get token => _token;

  Variants? variant;
  String ukuran = "";
  String textCart = "Add Cart";

  void getSelectedValue(String size, String color) {
    for (int i = 0; i < product.variants.length; i++) {
      if (product.variants[i].options.length > 1) {
        if (product.variants[i].options[0].value == size &&
            product.variants[i].options[1].value == color) {
          if (product.variants[i].options[0].value == 'XS') {
            ukuran = "Extra Small";
            variant = product.variants[i];
            break;
          } else if (product.variants[i].options[0].value == 'S') {
            ukuran = "Small";
            variant = product.variants[i];
            break;
          } else if (product.variants[i].options[0].value == 'M') {
            ukuran = "Medium";
            variant = product.variants[i];
            break;
          } else if (product.variants[i].options[0].value == 'L') {
            ukuran = "Large";
            variant = product.variants[i];
            break;
          } else if (product.variants[i].options[0].value == 'XL') {
            ukuran = "Extra Large";
            variant = product.variants[i];
            break;
          } else if (product.variants[i].options[0].value == 'XXL') {
            ukuran = "Double Extra Large";
            variant = product.variants[i];
            break;
          } else {
            ukuran = product.variants[i].options[0].value!;
            variant = product.variants[i];
            break;
          }
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

  ProductController() {
    getUser();
  }

  getUser() async {
    await localStorageData.getUser.then((value) {
      _userModel = value;
    });

    await localStorageData.getTokenUser.then((value) => _token = value);
    update();
  }

  customUkuran(String ukuran) {
    switch (ukuran.toLowerCase()) {
      case "dresses":
        return 'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/1._Mini_dress.jpg?v=1654594064';
      case "jacket":
        return 'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/1._BASIC_JACKET.jpg?v=1654594269';
      case "pants":
        return 'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/1._cullotes.jpg?v=1654594354';
      case "blouse & shirts":
        return 'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/1._REGULAR_LONG_SLEEVE_SHIRT.jpg?v=1654594524';
      case "shorts":
        return 'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/short_pants.jpg?v=1654594706';
      case "skirts":
        return 'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/1._Mini_skirt.jpg?v=1654594776';
      case "sweatshirt & hoodies":
        return 'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/1._BASIC_SWEATSHIRT.jpg?v=1654594857';
      case "t-shirts":
        return 'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/1._Regular_tshirt.jpg?v=1654594920';
      default:
        return 'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/2._Regular_tshirt-long_sleeves.jpg?v=1654594921';
    }
  }
}

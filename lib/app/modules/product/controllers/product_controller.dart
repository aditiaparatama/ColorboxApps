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
}

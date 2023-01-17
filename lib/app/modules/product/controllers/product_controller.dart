import 'package:colorbox/app/modules/collections/models/product_model.dart';
import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:colorbox/app/modules/product/providers/product_providers.dart';
import 'package:colorbox/app/modules/profile/models/user_model.dart';
import 'package:colorbox/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:colorbox/helper/local_storage_data.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final LocalStorageData localStorageData = Get.find();
  final HomeController homeController = Get.put(HomeController());
  final WishlistController wishlistController = Get.put(WishlistController());
  Product _product = Product.isEmpty();
  Product get product => _product;
  UserModel _userModel = UserModel.isEmpty();
  UserModel get userModel => _userModel;
  CustomerToken? _token = CustomerToken.isEmpty();
  CustomerToken? get token => _token;

  Variants? variant;
  String ukuran = "", warna = "";
  String textCart = "Add Cart";
  String? sizeTemp;
  int existWishlist = -1;
  bool wishlistAdded = false;

  @override
  void onInit() async {
    getUser();
    super.onInit();
  }

  void getSelectedValue(String size, String color,
      {bool fromColor = false}) async {
    if (fromColor && _product.options[1].values.length > 1) {
      String handle = product.handle!
          .replaceAll(warna.toLowerCase().replaceAll(" ", "-"), "");
      var check = handle.split("-");
      handle = (check[check.length - 1] == "")
          ? (handle + color.toLowerCase())
          : handle.replaceAll(
              "--", "-" + color.toLowerCase().replaceAll(" ", "-") + "-");

      await getProductByHandle(handle);
    }
    warna = color;
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
    if (fromColor) ukuran = '';
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

  getUser() async {
    await localStorageData.getUser.then((value) {
      _userModel = value;
    });

    await localStorageData.getTokenUser.then((value) => _token = value);
    update();
  }

  Future<void> getProductByHandle(String handle) async {
    ukuran = '';
    var result = await ProductProvider().getProductByHandle(handle);
    _product = Product.fromJson(result["product"]);
    variant = _product.variants[0];
    warna = _product.options[1].values[0];
    update();
  }
}

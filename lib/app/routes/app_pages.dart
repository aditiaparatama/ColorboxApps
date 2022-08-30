import 'package:get/get.dart';

import '../modules/Control/bindings/control_binding.dart';
import '../modules/Control/views/control_view.dart';
import '../modules/cart/bindings/cart_binding.dart';
import '../modules/cart/views/cart_view.dart';
import '../modules/checkout/bindings/checkout_binding.dart';
import '../modules/checkout/views/checkout_view.dart';
import '../modules/collections/bindings/collections_binding.dart';
import '../modules/collections/views/collections_main_view.dart';
import '../modules/controlv2/bindings/controlv2_binding.dart';
import '../modules/controlv2/views/controlv2_view.dart';
import '../modules/discount/bindings/discount_binding.dart';
import '../modules/discount/views/discount_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/onboard/bindings/onboard_binding.dart';
import '../modules/onboard/views/onboard_view.dart';
import '../modules/orders/bindings/orders_binding.dart';
import '../modules/orders/views/orders_view.dart';
import '../modules/product/bindings/product_binding.dart';
import '../modules/product/views/product_view2.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/changepassword_view.dart';
import '../modules/profile/views/forgotpassword_view.dart';
import '../modules/profile/views/messageforgotpassword_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/register_view.dart';
import '../modules/search/bindings/search_binding.dart';
import '../modules/search/views/search_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/wishlist/bindings/wishlist_binding.dart';
import '../modules/wishlist/views/wishlist_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  // ignore: constant_identifier_names
  static const INITIAL = Routes.ONBOARD;

  static final routes = [
    GetPage(
      name: _Paths.ONBOARD,
      page: () => OnBoardView(),
      binding: OnBoardBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CONTROL,
      page: () => ControlView(),
      binding: ControlBinding(),
    ),
    GetPage(
      name: _Paths.COLLECTIONS,
      page: () => CollectionsMainView(),
      binding: CollectionsBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT,
      page: () => ProductView2(),
      binding: ProductBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.CONTROLV2,
      page: () => ControlV2View(),
      binding: Controlv2Binding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(null),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => RegisterView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.FORGOTPASSWORD,
      page: () => ForgotPasswordView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHANGEPASSWORD,
      page: () => ChangePasswordView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.MESSAGEFORGOTPASSWORD,
      page: () => MessageForgotPasswordView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.SEARCH,
      page: () => SearchView(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: _Paths.DISCOUNT,
      page: () => DiscountView(),
      binding: DiscountBinding(),
    ),
    GetPage(
      name: _Paths.WISHLIST,
      page: () => const WishlistView(),
      binding: WishlistBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS,
      page: () => OrdersView(),
      binding: OrdersBinding(),
    ),
  ];
}

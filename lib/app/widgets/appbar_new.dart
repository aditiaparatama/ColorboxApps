import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AppBarNew extends StatelessWidget {
  final String title;
  const AppBarNew({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomText(
        text: title,
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: colorNeutral100,
      ),
      centerTitle: false,
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.3),
      leadingWidth: (title == "KATEGORI") ? null : 36,
      leading: (title == "KATEGORI")
          ? null
          : IconButton(
              padding: const EdgeInsets.all(16),
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back)),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: InkWell(
              splashColor: Colors.transparent,
              onTap: () => Get.toNamed(Routes.SEARCH),
              child: SvgPicture.asset(
                "assets/icon/search-new.svg",
              )),
        ),
        bagWidget(),
      ],
    );
  }

  Widget bagWidget() {
    return GetBuilder<CartController>(
        init: Get.put(CartController()),
        builder: (cartController) {
          return Center(
            child: InkWell(
              onTap: () => Get.toNamed(Routes.CART),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                    ),
                    child: SvgPicture.asset(
                      "assets/icon/shopping-bag.svg",
                    ),
                  ),
                  cartController.cart.lines!.isNotEmpty
                      ? Positioned(
                          top: 0,
                          right: 10,
                          child: Container(
                            width: 15,
                            height: 15,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.red),
                            child: CustomText(
                              text:
                                  cartController.cart.totalQuantity.toString(),
                              fontSize: 10,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const SizedBox()
                ],
              ),
            ),
          );
        });
  }
}

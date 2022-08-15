import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AppBarCustom extends StatelessWidget {
  final String? text;
  const AppBarCustom({
    Key? key,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: CustomText(
        text: text!,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
      centerTitle: false,
      elevation: 3,
      shadowColor: Colors.grey.withOpacity(0.3),
      actions: [
        Center(
          child: InkWell(
            onTap: () => Get.toNamed(Routes.CART),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                  ),
                  child: SvgPicture.asset(
                    "assets/icon/Handbag.svg",
                  ),
                ),
                Get.find<CartController>().cart.lines!.isNotEmpty
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
                            text: Get.find<CartController>()
                                .cart
                                .lines!
                                .length
                                .toString(),
                            fontSize: 10,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const SizedBox()
              ],
            ),
          ),
        ),
      ],
    );
  }
}

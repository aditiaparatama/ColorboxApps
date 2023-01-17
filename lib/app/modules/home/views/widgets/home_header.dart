import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeSearch extends StatelessWidget {
  const HomeSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 36,
            width: MediaQuery.of(context).size.width - 70,
            child: TextFormField(
              readOnly: true,
              onTap: () => Get.toNamed(Routes.SEARCH),
              cursorColor: colorTextBlack,
              decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(6.0),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 0.0,
                  ),
                ),
                contentPadding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
                disabledBorder: InputBorder.none,
                labelStyle:
                    const TextStyle(fontSize: 12, color: Color(0xFF9B9B9B)),
                hintText: "Cari produk disini",
                hintStyle:
                    const TextStyle(fontSize: 12, color: Color(0xFF9B9B9B)),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                suffixIcon: GestureDetector(
                  onTap: () => Get.toNamed(Routes.SEARCH),
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: SvgPicture.asset("assets/icon/bx-search1.svg",
                        color: const Color(0xFF9B9B9B)),
                  ),
                ),
              ),
            ),
          ),
          GetBuilder<CartController>(
              init: Get.put(CartController()),
              builder: (cartController) {
                return SizedBox(
                  height: 36,
                  width: 30,
                  child: InkWell(
                    onTap: () =>
                        Get.toNamed(Routes.CART, arguments: "collection"),
                    child: Stack(
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 16.0,
                            child: SvgPicture.asset(
                                "assets/icon/shopping-bag.svg"),
                          ),
                        ),
                        cartController.cart.lines!.isNotEmpty &&
                                cartController.cart.totalQuantity != 0
                            ? Container(
                                alignment: Alignment.centerRight,
                                padding:
                                    const EdgeInsets.only(left: 15, bottom: 5),
                                child: Container(
                                  width: 15,
                                  height: 15,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.red),
                                  child: CustomText(
                                    text: cartController.cart.totalQuantity
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
                );
              }),
        ],
      ),
    );
  }
}

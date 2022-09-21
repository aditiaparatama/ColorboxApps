import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchCollection extends StatelessWidget {
  const SearchCollection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 36,
          width: MediaQuery.of(context).size.width - 138,
          child: TextFormField(
            onTap: () => Get.toNamed(Routes.SEARCH),
            cursorColor: const Color.fromRGBO(155, 155, 155, 1),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(250, 250, 250, 1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  width: 1.0,
                ),
              ),
              contentPadding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
              disabledBorder: InputBorder.none,
              labelStyle: const TextStyle(
                  fontSize: 12, color: Color.fromARGB(155, 155, 155, 1)),
              hintText: "Cari produk disini",
              filled: true,
              // fillColor: const Color.fromRGBO(250, 250, 250, 1),
              fillColor: Colors.amber,
              suffixIcon: Padding(
                padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                child: GestureDetector(
                  onTap: () => Get.toNamed(Routes.SEARCH),
                  child: SvgPicture.asset("assets/icon/bx-search1.svg"),
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
                width: 50,
                child: InkWell(
                  onTap: () =>
                      Get.toNamed(Routes.CART, arguments: "collection"),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 0),
                        child: Center(
                          child: CircleAvatar(
                            radius: 16.0,
                            child:
                                SvgPicture.asset("assets/icon/bx-handbag.svg"),
                          ),
                        ),
                      ),
                      cartController.cart.lines!.isNotEmpty
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
    );
  }
}

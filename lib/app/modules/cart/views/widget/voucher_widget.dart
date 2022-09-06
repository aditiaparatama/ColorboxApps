import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/discount/views/discount_cart_view.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class VoucherWidget extends GetView<CartController> {
  const VoucherWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(CartController()),
        builder: (c) {
          return Stack(
            children: [
              SizedBox(
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () => Get.to(DiscountCartView()),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        width: Get.width,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: (controller.cart.lines!.isEmpty)
                                  ? Colors.black
                                  : const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: (controller.cart.discountCodes!.isEmpty ||
                                controller.cart.discountCodes![0].code == "" ||
                                controller.cart.discountCodes![0].applicable ==
                                    false)
                            ? pilihVoucher()
                            : voucher(),
                      ),
                    ),
                  ],
                ),
              ),
              (controller.loading.value) ? loadingCircular() : const SizedBox(),
            ],
          );
        });
  }

  Row voucher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset("assets/icon/badge-percent.svg"),
            const SizedBox(width: 16),
            CustomText(
              text: controller.cart.discountCodes![0].code,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        InkWell(
          onTap: () async => await controller.updateDiscountCode(""),
          child: const SizedBox(
            height: 18,
            width: 18,
            child: CircleAvatar(
              backgroundColor: Colors.black,
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row pilihVoucher() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgPicture.asset("assets/icon/badge-percent.svg"),
            const SizedBox(
              width: 16,
            ),
            const CustomText(
              text: "Pilih Voucher",
              fontSize: 14,
            ),
          ],
        ),
        const Icon(
          Icons.arrow_forward_ios,
          size: 16,
        ),
      ],
    );
  }
}

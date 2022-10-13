import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class VoucherWidget extends GetView<CheckoutController> {
  const VoucherWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(CheckoutController()),
        builder: (c) {
          return Container(
            color: Colors.white,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomText(
                  text: "Voucher",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => Get.toNamed(Routes.DISCOUNT),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    width: Get.width,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color:
                              (controller.checkout.discountApplications == null)
                                  ? colorTextBlack
                                  : const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: (controller.checkout.discountApplications != null &&
                            controller.checkout.discountApplications![0]
                                    .typename !=
                                "AutomaticDiscountApplication")
                        ? voucher()
                        : pilihVoucher(),
                  ),
                ),
              ],
            ),
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
              text: controller.checkout.discountApplications![0].code,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ],
        ),
        InkWell(
          onTap: () => controller.removeVoucher(),
          child: const SizedBox(
            height: 18,
            width: 18,
            child: CircleAvatar(
              backgroundColor: colorTextBlack,
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

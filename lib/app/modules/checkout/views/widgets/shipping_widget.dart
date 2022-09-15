import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/app/modules/checkout/views/shipping_view.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ShippingWidget extends GetView<CheckoutController> {
  const ShippingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(CheckoutController()),
        builder: (c) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () async {
                  if (controller.checkout.availableShippingRates!.ready ==
                      false) {
                    await controller.getCheckout();
                  }
                  await controller.getETDShipping();
                  Get.to(const ShippingView());
                },
                child: (controller.checkout.shippingLine == null)
                    ? pilihPengiriman()
                    : pengiriman(),
              ),
            ],
          );
        });
  }

  Container pilihPengiriman() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(color: colorTextBlack),
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: Row(
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/icon/shipping-fast.svg"),
              const SizedBox(
                width: 16,
              ),
              const CustomText(
                text: "Pilih Metode Pengiriman",
                fontSize: 12,
              ),
            ],
          ),
          const Icon(Icons.arrow_back_ios),
        ],
      ),
    );
  }

  Widget pengiriman() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE5E8EB)),
          borderRadius: const BorderRadius.all(Radius.circular(6))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/icon/shipping-fast.svg"),
              const SizedBox(
                width: 16,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text:
                        controller.checkout.shippingLine!.title!.split("(")[0],
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  CustomText(
                    text: controller.etd ?? "",
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              CustomText(
                text: controller.checkout.shippingLine!.amount ?? "FREE",
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                width: defaultPadding,
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

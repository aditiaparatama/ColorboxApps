import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/app/modules/profile/views/address/address_view.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddressWidget extends GetView<CheckoutController> {
  const AddressWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: Get.put(CheckoutController()),
        builder: (c) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFFE5E8EB)),
                borderRadius: const BorderRadius.all(Radius.circular(6))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(
                        text: "Alamat Pengiriman",
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      InkWell(
                        onTap: () => Get.to(const AddressView()),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(12)),
                              border:
                                  Border.all(color: const Color(0xFF115AC8))),
                          child: const CustomText(
                            text: "Ubah Alamat",
                            color: Color(0xFF115AC8),
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ),
                  alignment: Alignment.centerRight,
                ),
                const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text:
                          "${controller.checkout.shippingAddress!.firstName} ${controller.checkout.shippingAddress!.lastName} | ${controller.checkout.shippingAddress!.phone}",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                    const SizedBox(height: 2),
                    SizedBox(
                      width: 296,
                      child: CustomText(
                        text: controller.checkout.shippingAddress!.address1,
                        fontSize: 12,
                        textOverflow: TextOverflow.fade,
                        lineHeight: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    CustomText(
                      text:
                          "${controller.checkout.shippingAddress!.address2}, ${controller.checkout.shippingAddress!.city}",
                      fontSize: 12,
                    ),
                    const SizedBox(height: 2),
                    CustomText(
                      text:
                          "${controller.checkout.shippingAddress!.province} ${controller.checkout.shippingAddress!.zip}",
                      fontSize: 12,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}

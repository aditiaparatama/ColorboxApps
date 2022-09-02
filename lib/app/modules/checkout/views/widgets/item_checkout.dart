import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:colorbox/app/widgets/custom_text.dart';

class ItemCheckoutWidget extends StatelessWidget {
  const ItemCheckoutWidget(
      {Key? key,
      required this.formatter,
      required this.controller,
      required this.index})
      : super(key: key);

  final NumberFormat formatter;
  final CheckoutController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    final options =
        controller.checkout.lineItems![index].variants!.title!.split("/");
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E8EB)),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: controller.checkout.lineItems![index].variants!.image!,
            height: 65,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: Get.width * .65,
                child: CustomText(
                  text: controller
                      .checkout.lineItems![index].variants!.titleProduct!,
                  fontSize: 12,
                  textOverflow: TextOverflow.clip,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                        text: "Warna : ",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF777777),
                        ),
                        children: [
                          TextSpan(
                              text: options[1],
                              style: const TextStyle(
                                  color: Color(0xFF777777),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600))
                        ]),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Ukuran : ",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF777777),
                        ),
                        children: [
                          TextSpan(
                              text: options[0],
                              style: const TextStyle(
                                  color: Color(0xFF777777),
                                  fontWeight: FontWeight.w600))
                        ]),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              CustomText(
                text:
                    "Rp ${formatter.format(int.parse(controller.checkout.lineItems![index].variants!.price!.replaceAll(".00", "")))}",
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

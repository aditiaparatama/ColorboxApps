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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedNetworkImage(
          imageUrl: controller.checkout.lineItems![index].variants!.image!,
          height: 100,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Column(
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
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        children: [
                          TextSpan(
                              text: options[1],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ]),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  RichText(
                    text: TextSpan(
                        text: "Ukuran : ",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                        children: [
                          TextSpan(
                              text: options[0],
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600))
                        ]),
                  ),
                ],
              ),
              const SizedBox(height: defaultPadding),
              controller.checkout.lineItems![index].discountAllocations!.isEmpty
                  ? CustomText(
                      text:
                          "Rp ${formatter.format(int.parse(controller.checkout.lineItems![index].variants!.price!.replaceAll(".00", "")))}",
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    )
                  : Row(
                      children: [
                        CustomText(
                          text:
                              "Rp ${formatter.format(int.parse(controller.checkout.lineItems![index].variants!.price!.replaceAll(".00", "")))}",
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey[500],
                          fontSize: 10,
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: const BoxDecoration(
                              color: Color(0xFFBB0915),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(2))),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.discount_outlined,
                                size: 12,
                                color: Colors.white,
                              ),
                              CustomText(
                                text: (controller.checkout.discountApplications!
                                            .percentage ==
                                        null)
                                    ? " -Rp ${formatter.format(double.parse(controller.checkout.lineItems![index].discountAllocations![0].allocatedAmount!).ceil())}"
                                    : "${controller.checkout.lineItems![index].discountAllocations![0].discountApplication!.percentage}%",
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
              const SizedBox(
                height: 4,
              ),
              controller.checkout.lineItems![index].discountAllocations!.isEmpty
                  ? const SizedBox()
                  : CustomText(
                      text:
                          "Rp ${formatter.format(int.parse(controller.checkout.lineItems![index].variants!.price!.replaceAll(".00", "")) - double.parse(controller.checkout.lineItems![index].discountAllocations![0].allocatedAmount!).ceil())}",
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
            ],
          ),
        ),
      ],
    );
  }
}

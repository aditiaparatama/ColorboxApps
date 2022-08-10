import 'package:colorbox/app/modules/checkout/controllers/checkout_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListAddress extends StatelessWidget {
  const ListAddress({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final CheckoutController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(defaultPadding),
        height: Get.height * .8,
        color: primaryColor,
        child: SingleChildScrollView(
          child: SizedBox(
            height: Get.height * .85,
            child: Column(
              children: [
                for (final address in controller.user.addresses!) ...[
                  Card(
                    child: SizedBox(
                      width: Get.width,
                      child: Row(
                        children: [
                          Container(
                              width: defaultPadding / 2,
                              height: defaultPadding * 5,
                              decoration: const BoxDecoration(
                                color: Colors.black87,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5)),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(defaultPadding),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  text:
                                      '${address.firstName} ${address.lastName} (${address.phone ?? ""})',
                                ),
                                CustomText(
                                  text: address.address1,
                                ),
                                CustomText(
                                  text: address.address2,
                                ),
                                CustomText(
                                  text:
                                      '${address.city}, ${address.province}, ${address.zip}',
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ]
              ],
            ),
          ),
        ));
  }
}

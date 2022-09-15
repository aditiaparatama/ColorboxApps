import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';

class ItemCartWidget extends StatelessWidget {
  const ItemCartWidget(
      {Key? key,
      required this.formatter,
      required this.controller,
      required this.index})
      : super(key: key);

  final NumberFormat formatter;
  final CartController controller;
  final int index;

  @override
  Widget build(BuildContext context) {
    final options =
        controller.cart.lines![index].merchandise!.title!.split("/");
    return Container(
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              CachedNetworkImage(
                imageUrl: controller.cart.lines![index].merchandise!.image!,
                height: 130,
                fit: BoxFit.fill,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: CustomText(
                        text: controller
                            .cart.lines![index].merchandise!.titleProduct!,
                        fontSize: 12,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    //options
                    Row(
                      children: [
                        RichText(
                          text: TextSpan(
                              text: "Warna : ",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                              children: [
                                TextSpan(
                                    text: options[1],
                                    style: const TextStyle(
                                        color: colorTextBlack,
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        RichText(
                          text: TextSpan(
                              text: "Ukuran : ",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                              children: [
                                TextSpan(
                                    text: options[0],
                                    style: const TextStyle(
                                        color: colorTextBlack,
                                        fontWeight: FontWeight.bold))
                              ]),
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding),
                    //promo
                    controller.cart.lines![index].discountAllocations!.title ==
                            null
                        ? CustomText(
                            text:
                                "Rp ${formatter.format(int.parse(controller.cart.lines![index].merchandise!.price!.replaceAll(".00", "")))}",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          )
                        : Row(
                            children: [
                              CustomText(
                                text:
                                    "Rp ${formatter.format(int.parse(controller.cart.lines![index].merchandise!.price!.replaceAll(".00", "")))}",
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey[500],
                                fontSize: 10,
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              CustomText(
                                text:
                                    "Rp ${formatter.format(double.parse(controller.cart.lines![index].merchandise!.price!.replaceAll(".00", "")).ceil() - double.parse(controller.cart.lines![index].discountAllocations!.amount!).ceil())}",
                                fontSize: 14,
                              ),
                            ],
                          ),
                    controller.cart.lines![index].discountAllocations!.title ==
                            null
                        ? const SizedBox()
                        : Row(
                            children: [
                              Icon(
                                Icons.discount_outlined,
                                size: 12,
                                color: Colors.red[800],
                              ),
                              CustomText(
                                text:
                                    " ${controller.cart.lines![index].discountAllocations!.title}",
                                color: Colors.red[800],
                              ),
                            ],
                          ),
                    controller.cart.lines![index].discountAllocations!.title ==
                            null
                        ? const SizedBox()
                        : CustomText(
                            text:
                                "Rp ${formatter.format(double.parse(controller.cart.lines![index].discountAllocations!.amount!).ceil())}",
                            color: Colors.red[800],
                          ),
                    //control qty
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              controller.curIndex = index;
                              controller.updateCart(
                                  controller
                                      .cart.lines![index].merchandise!.id!,
                                  controller.cart.lines![index].id!,
                                  controller.cart.lines![index].quantity! - 1);
                            },
                            child: Container(
                                height: 26,
                                width: 32,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        left: BorderSide(color: Colors.grey),
                                        top: BorderSide(color: Colors.grey),
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: const Center(
                                  child: CustomText(
                                    text: "-",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ),
                          Container(
                            height: 26,
                            width: 50,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)),
                            child: Center(
                              child: CustomText(
                                text: controller.cart.lines![index].quantity!
                                    .toString(),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              controller.curIndex = index;
                              controller.updateCart(
                                  controller
                                      .cart.lines![index].merchandise!.id!,
                                  controller.cart.lines![index].id!,
                                  controller.cart.lines![index].quantity! + 1);
                            },
                            child: Container(
                                height: 26,
                                width: 32,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        right: BorderSide(color: Colors.grey),
                                        top: BorderSide(color: Colors.grey),
                                        bottom:
                                            BorderSide(color: Colors.grey))),
                                child: const Center(
                                  child: CustomText(
                                    text: "+",
                                    fontSize: 20,
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          (controller.loading.value && index == controller.curIndex)
              ? Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.only(top: 35),
                  child: const CircularProgressIndicator(
                    color: colorTextBlack,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}

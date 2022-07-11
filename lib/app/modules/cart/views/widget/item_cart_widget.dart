import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Stack(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(
                  imageUrl: controller.cart.lines![index].merchandise!.image!,
                  height: 120,
                  fit: BoxFit.fill,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: Get.width * .65,
                        child: CustomText(
                          text: controller
                              .cart.lines![index].merchandise!.titleProduct!
                              .toUpperCase(),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          textOverflow: TextOverflow.clip,
                        ),
                      ),
                      CustomText(
                        text: controller.cart.lines![index].merchandise!.title!,
                      ),
                      const SizedBox(height: 5),
                      controller.cart.lines![index].discountAllocations!
                                  .title ==
                              null
                          ? CustomText(
                              text:
                                  "Rp. ${formatter.format(int.parse(controller.cart.lines![index].merchandise!.price!.replaceAll(".00", "")))}",
                            )
                          : Row(
                              children: [
                                CustomText(
                                  text:
                                      "Rp. ${formatter.format(int.parse(controller.cart.lines![index].merchandise!.price!.replaceAll(".00", "")))}",
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey[500],
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                CustomText(
                                  text:
                                      "Rp. ${formatter.format(int.parse(controller.cart.lines![index].merchandise!.price!.replaceAll(".00", "")) - double.parse(controller.cart.lines![index].discountAllocations!.amount!).round())}",
                                ),
                              ],
                            ),
                      controller.cart.lines![index].discountAllocations!
                                  .title ==
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
                      controller.cart.lines![index].discountAllocations!
                                  .title ==
                              null
                          ? const SizedBox()
                          : CustomText(
                              text:
                                  "Rp. ${formatter.format(double.parse(controller.cart.lines![index].discountAllocations!.amount!).round())}",
                              color: Colors.red[800],
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: IconButton(
                                onPressed: () {
                                  controller.curIndex = index;
                                  controller.updateCart(
                                      controller
                                          .cart.lines![index].merchandise!.id!,
                                      controller.cart.lines![index].id!,
                                      controller.cart.lines![index].quantity! -
                                          1);
                                },
                                icon: const Icon(Icons.minimize)),
                          ),
                          CustomText(
                            text: controller.cart.lines![index].quantity!
                                .toString(),
                            fontSize: 18,
                          ),
                          IconButton(
                              onPressed: () {
                                controller.curIndex = index;
                                controller.updateCart(
                                    controller
                                        .cart.lines![index].merchandise!.id!,
                                    controller.cart.lines![index].id!,
                                    controller.cart.lines![index].quantity! +
                                        1);
                              },
                              icon: const Icon(
                                Icons.add,
                              )),
                        ],
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
                      color: Colors.black,
                    ),
                  )
                : const SizedBox()
          ],
        ),
      ),
    );
  }
}

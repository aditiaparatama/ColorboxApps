import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/cart/models/cart_model.dart';
import 'package:colorbox/app/modules/control/menu_model.dart';
import 'package:colorbox/app/modules/discount/models/discount_model.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';

class ItemCartWidget extends StatelessWidget {
  const ItemCartWidget(
      {Key? key,
      required this.formatter,
      required this.controller,
      this.collectionPromo,
      required this.index})
      : super(key: key);

  final NumberFormat formatter;
  final CartController controller;
  final int index;
  final Menu? collectionPromo;

  @override
  Widget build(BuildContext context) {
    final _cart = controller.cart.lines![index];
    final options = _cart.merchandise!.title!.split("/");
    int indexPromo = -1;
    int indexCollectionPromo = -1;
    DiscountRunning discountRunning = DiscountRunning.isEmpty();
    if (_cart.discountAllocations != null &&
        controller.discountRunning.isNotEmpty) {
      indexPromo = controller.discountRunning
          .indexWhere((e) => e.title == _cart.discountAllocations!.title);

      if (indexPromo >= 0) {
        discountRunning = controller.discountRunning[indexPromo];
      }
    }
    for (DiscountAutomatic discount
        in controller.discountController.discountAutomatic) {
      for (final x in discount.collections ?? []) {
        indexCollectionPromo =
            _cart.merchandise!.idCollection!.indexWhere((e) => e == x.id);
        if (indexCollectionPromo >= 0) {
          break;
        }
      }
      if (indexCollectionPromo >= 0) {
        break;
      }
    }
    Widget widgetDiscount() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (double.parse(_cart.merchandise!.price!.replaceAll(".00", ""))
                      .ceil() -
                  double.parse(_cart.discountAllocations!.amount!).ceil() !=
              0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                  color: colorBoxInfo,
                  borderRadius: BorderRadius.all(Radius.circular(2))),
              child: Row(
                children: [
                  const Icon(
                    Icons.discount_outlined,
                    size: 12,
                    color: colorTextBlack,
                  ),
                  CustomText(
                    text: " ${_cart.discountAllocations!.title} [",
                    color: colorTextBlack,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text:
                        "-Rp ${formatter.format(double.parse(_cart.discountAllocations!.amount!).round())}]",
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  )
                ],
              ),
            ),
          const SizedBox(height: 4),
          (double.parse(_cart.merchandise!.price!.replaceAll(".00", ""))
                          .ceil() -
                      double.parse(_cart.discountAllocations!.amount!).ceil() ==
                  0)
              ? const CustomText(
                  text: "FREE",
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )
              : Row(
                  children: [
                    CustomText(
                      text:
                          "Rp ${formatter.format(int.parse(_cart.merchandise!.price!.replaceAll(".00", "")))}",
                      decoration: TextDecoration.lineThrough,
                      color: colorTextGrey,
                      fontSize: 10,
                    ),
                    const SizedBox(width: 4),
                    CustomText(
                      text:
                          "Rp ${formatter.format(double.parse(_cart.merchandise!.price!.replaceAll(".00", "")).round() - (double.parse(_cart.discountAllocations!.amount!) / _cart.quantity!).round())}",
                      fontSize: 14,
                      color: colorSaleRed,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      color: (_cart.merchandise!.inventoryQuantity! <= 0)
          ? colorTextBlack.withOpacity(0.05)
          : Colors.transparent,
      child: Stack(
        children: [
          Column(
            children: [
              if (discountRunning.typename != "DiscountAutomaticBxgy")
                ((controller.cart.discountCodes!.isEmpty ||
                            controller.cart.discountCodes![0].code == "") &&
                        (indexCollectionPromo >= 0) &&
                        collectionPromo!.subjectID != null &&
                        _cart.merchandise!.inventoryQuantity! > 0 &&
                        !(discountRunning.applied ?? false) &&
                        discountRunning.typename != "DiscountAutomaticBxgy" &&
                        !_cart.merchandise!.titleProduct!
                            .toLowerCase()
                            .contains("gift with"))
                    ? InkWell(
                        onTap: () {
                          Get.offNamed(Routes.COLLECTIONS, arguments: {
                            "menu": collectionPromo,
                            "indexMenu": null,
                            "sortBy": defaultSortBy
                          });
                        },
                        child: Container(
                          width: Get.width - 32,
                          margin: const EdgeInsets.only(bottom: 14),
                          color: colorBoxInfo,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.discount,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              CustomText(
                                text: (collectionPromo!.title ?? "") + ". ",
                                textAlign: TextAlign.center,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                              const CustomText(
                                text: "Tambah Lagi",
                                textAlign: TextAlign.center,
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                decoration: TextDecoration.underline,
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                // mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      CachedNetworkImage(
                        imageUrl: _cart.merchandise!.image!,
                        height: 130,
                        fit: BoxFit.fill,
                      ),
                      (_cart.merchandise!.inventoryQuantity! <= 0)
                          ? Container(
                              height: 130,
                              width: 90,
                              color: colorOverlay.withOpacity(0.5),
                              child: Center(
                                child: SizedBox(
                                  width: 60,
                                  height: 60,
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xFF212121)
                                        .withOpacity(0.75),
                                    child: const CustomText(
                                      text: "Habis",
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox()
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Get.width - 132,
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
                                      fontSize: 12, color: colorTextGrey),
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
                                      fontSize: 12, color: colorTextGrey),
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
                        (_cart.discountAllocations != null &&
                                _cart.discountAllocations!.title != null &&
                                _cart.discountAllocations!.typename ==
                                    "CartAutomaticDiscountAllocation" &&
                                _cart.merchandise!.inventoryQuantity! > 0 &&
                                (discountRunning.applied ?? false))
                            ? widgetDiscount()
                            : (discountRunning.typename ==
                                        "DiscountAutomaticBxgy" &&
                                    _cart.discountAllocations!.amount != "0.0")
                                ? widgetDiscount()
                                : CustomText(
                                    text:
                                        "Rp ${formatter.format(int.parse(_cart.merchandise!.price!.replaceAll(".00", "")))}",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                        //control qty
                        Container(
                          padding: const EdgeInsets.only(top: 16),
                          child: (_cart.merchandise!.inventoryQuantity! <= 0)
                              ? InkWell(
                                  onTap: () {
                                    controller.curIndex = index;
                                    controller.updateCart(
                                        _cart.merchandise!.id!, _cart.id!, 0);
                                  },
                                  child: SvgPicture.asset(
                                      "assets/icon/TrashAlt.svg"))
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        controller.curIndex = index;
                                        controller.updateCart(
                                            _cart.merchandise!.id!,
                                            _cart.id!,
                                            _cart.quantity! - 1);
                                      },
                                      child: Container(
                                          height: 26,
                                          width: 32,
                                          decoration: const BoxDecoration(
                                              border: Border(
                                                  left: BorderSide(
                                                      color: colorBorderGrey),
                                                  top: BorderSide(
                                                      color: colorBorderGrey),
                                                  bottom: BorderSide(
                                                      color: colorBorderGrey))),
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
                                          border: Border.all(
                                              color: colorBorderGrey)),
                                      child: Center(
                                        child: CustomText(
                                          text: controller
                                              .cart.lines![index].quantity!
                                              .toString(),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (_cart.merchandise!
                                                  .inventoryQuantity! <=
                                              _cart.quantity!)
                                          ? null
                                          : () {
                                              controller.curIndex = index;
                                              controller.updateCart(
                                                  _cart.merchandise!.id!,
                                                  _cart.id!,
                                                  _cart.quantity! + 1);
                                            },
                                      child: Container(
                                          height: 26,
                                          width: 32,
                                          decoration: BoxDecoration(
                                              color: (_cart.merchandise!
                                                          .inventoryQuantity! <=
                                                      _cart.quantity!)
                                                  ? colorBorderGrey
                                                  : Colors.transparent,
                                              border: const Border(
                                                  right: BorderSide(
                                                      color: colorBorderGrey),
                                                  top: BorderSide(
                                                      color: colorBorderGrey),
                                                  bottom: BorderSide(
                                                      color: colorBorderGrey))),
                                          child: const Center(
                                            child: CustomText(
                                              text: "+",
                                              fontSize: 20,
                                            ),
                                          )),
                                    ),
                                    const SizedBox(width: 16),
                                    (_cart.merchandise!.inventoryQuantity! <= 5)
                                        ? CustomText(
                                            text:
                                                "Tersisa ${_cart.merchandise!.inventoryQuantity!} produk",
                                            fontSize: 12,
                                            color: colorTextRed,
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
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

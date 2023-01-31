import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/collections/models/product_model.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/pcp_radio_color.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

class ItemCard extends StatelessWidget {
  final int index;
  final String? title;
  final String? price;
  final String? image;
  final String? compareAtPrice;
  final int? totalInventory;
  final Product product;
  final Function onPress;
  final dynamic controller;
  const ItemCard({
    Key? key,
    this.title,
    this.price,
    this.image,
    this.compareAtPrice,
    this.totalInventory,
    required this.onPress,
    required this.product,
    required this.index,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var calcu1 = int.parse(price!.replaceAll(".00", "")) /
        int.parse(compareAtPrice!.replaceAll(".00", ""));
    int indexLabel =
        product.tags!.indexWhere((e) => e.contains("label_produk_"));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            CachedNetworkImage(
              imageUrl: image!,
              imageBuilder: (context, imageProvider) => AspectRatio(
                aspectRatio: 2.08 / 3,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  AspectRatio(
                aspectRatio: 2.08 / 3,
                child: Image.asset(
                  "assets/images/Image.jpg",
                  fit: BoxFit.cover,
                ),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            (totalInventory != null && totalInventory == 0)
                ? AspectRatio(
                    aspectRatio: 2.08 / 3,
                    child: Container(
                        color: colorOverlay.withOpacity(0.5),
                        child: SizedBox(
                          height: 220,
                          child: Center(
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: CircleAvatar(
                                backgroundColor:
                                    const Color(0xFF212121).withOpacity(0.75),
                                child: const CustomText(
                                  text: "Habis",
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        )),
                  )
                : const SizedBox(),
            if (compareAtPrice != "0" && compareAtPrice != price)
              Positioned(
                top: 8,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  color: colorDangerSurface,
                  child: CustomText(
                    text: '-' + (100 - calcu1 * 100).ceil().toString() + '%',
                    fontSize: 12,
                    color: colorDangerHover,
                    fontWeight: FontWeight.w500,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        if (indexLabel >= 0) ...[
          const SizedBox(height: 4),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Color(0xFFFFEFD1),
                    Color(0xFFFED4AE),
                    Color(0xFFFBD5DA),
                    Color(0xFFF0C0CE),
                    Color(0xFFE5C1E5),
                  ]),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: CustomText(
              text: product.tags![indexLabel]
                  .replaceAll("label_produk_", "")
                  .replaceAll("_", " "),
              color: colorNeutral100,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
        const SizedBox(height: 8),
        Container(
          alignment: Alignment.centerLeft,
          child: CustomText(
            text: title!,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: colorNeutral90,
          ),
        ),
        const SizedBox(height: 4),
        (compareAtPrice == "0" || compareAtPrice == price)
            ? CustomText(
                text: "Rp " + formatter.format(int.parse(price!)),
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: colorNeutral100,
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Rp " + formatter.format(int.parse(compareAtPrice!)),
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: colorNeutral70,
                        decoration: TextDecoration.lineThrough),
                  ),
                  const SizedBox(width: 4),
                  CustomText(
                    text: "Rp " + formatter.format(int.parse(price!)),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: colorDangerHover,
                  ),
                ],
              ),
        const SizedBox(height: 8),
        SizedBox(
          height: 25,
          child: CustomPCPRadioColor(
            controller: controller,
            indexProduct: index,
            listData: product.options[1].values.toList(),
          ),
        ),
      ],
    );
  }
}

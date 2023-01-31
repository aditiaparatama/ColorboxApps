import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemCardCart extends StatelessWidget {
  const ItemCardCart({
    Key? key,
    required this.calcu1,
    required this.collection,
    required this.i,
  }) : super(key: key);

  final double calcu1;
  final dynamic collection;
  final int i;

  @override
  Widget build(BuildContext context) {
    bool indexLabel = collection.products[i].tags!.contains("label_produk_");
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PRODUCT, arguments: {
        "product": collection.products[i],
        "idCollection": collection.id,
        "handle": collection.products[i].handle
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: collection.products[i].image[0],
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
                        child: Image.asset("assets/images/Image.jpg")),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              if (collection.products[i].variants[0].compareAtPrice! != "0" &&
                  collection.products[i].variants[0].compareAtPrice! !=
                      collection.products[i].variants[0].price!)
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
          const SizedBox(height: 8),
          if (indexLabel) ...[
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
                text: collection.products[i].tags![indexLabel]
                    .replaceAll("label_produk_", "")
                    .replaceAll("_", " "),
                color: colorNeutral100,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
          ],
          CustomText(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            text: collection.products[i].title,
            textOverflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          (collection.products[i].variants[0].compareAtPrice! == "0" ||
                  collection.products[i].variants[0].compareAtPrice! ==
                      collection.products[i].variants[0].price!)
              ? CustomText(
                  text: "Rp " +
                      formatter.format(int.parse(collection
                          .products[i].variants[0].price!
                          .replaceAll(".00", ""))),
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                )
              : Column(
                  children: [
                    Row(
                      children: [
                        CustomText(
                          text: "Rp " +
                              formatter.format(int.parse(collection
                                  .products[i].variants[0].compareAtPrice!
                                  .replaceAll(".00", ""))),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: colorTextGrey,
                          decoration: TextDecoration.lineThrough,
                        ),
                        const SizedBox(width: 4),
                        CustomText(
                          text: "Rp " +
                              formatter.format(int.parse(collection
                                  .products[i].variants[0].price!
                                  .replaceAll(".00", ""))),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: colorDangerHover,
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

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
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PRODUCT, arguments: {
        "product": collection.products[i],
        "idCollection": collection.id
      }),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                Image.asset("assets/images/Image.jpg"),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(height: 12),
          CustomText(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            text: collection.products[i].title,
            textOverflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          (collection.products[i].variants[0].compareAtPrice! == "0" ||
                  collection.products[i].variants[0].compareAtPrice! ==
                      collection.products[i].variants[0].price!)
              ? CustomText(
                  text: "Rp " +
                      formatter.format(int.parse(collection
                          .products[i].variants[0].price!
                          .replaceAll(".00", ""))),
                  fontWeight: FontWeight.bold,
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
                                  .replaceAll(".00", ""))) +
                              "  ",
                          fontSize: 8,
                          fontWeight: FontWeight.w400,
                          color: colorTextGrey,
                          decoration: TextDecoration.lineThrough,
                        ),
                        const SizedBox(width: 2),
                        Container(
                          width: 30.0,
                          height: 15.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(2),
                            color: colorSaleRed,
                          ),
                          child: Center(
                            child: Text(
                              (100 - calcu1 * 100).ceil().toString() + '%',
                              style: const TextStyle(
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: (collection.products[i].variants[0]
                                        .compareAtPrice! ==
                                    "0" ||
                                collection.products[i].variants[0]
                                        .compareAtPrice! ==
                                    collection.products[i].variants[0].price!)
                            ? 0
                            : 4),
                    Column(
                      children: [
                        Row(
                          children: [
                            CustomText(
                              text: "Rp " +
                                  formatter.format(int.parse(collection
                                      .products[i].variants[0].price!
                                      .replaceAll(".00", ""))),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: colorTextRed,
                            ),
                          ],
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

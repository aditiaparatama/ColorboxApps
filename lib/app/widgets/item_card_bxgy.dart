import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/cart/views/widget/claim_bottomsheet.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_button.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemCardBxGy extends StatelessWidget {
  const ItemCardBxGy({
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
                  aspectRatio: 2.07 / 3,
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
                        aspectRatio: 2.07 / 3,
                        child: Image.asset("assets/images/Image.jpg")),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              (collection.products[i].totalInventory != null &&
                      collection.products[i].totalInventory == 0)
                  ? AspectRatio(
                      aspectRatio: 2.07 / 3,
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
          CustomText(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            text: collection.products[i].title,
            textOverflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if (collection.products[i].totalInventory != null &&
              collection.products[i].totalInventory > 0)
            CustomButton(
              height: 38,
              onPressed: () {
                claimBottomSheet(collection.products[i].handle);
              },
              backgroundColor: colorNeutral10,
              color: colorNeutral100,
              text: "Klaim",
              fontWeight: FontWeight.w400,
              fontSize: 12,
              padding: EdgeInsets.zero,
            )
        ],
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/skeleton.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class ItemCard extends StatelessWidget {
  final String? title;
  final String? price;
  final String? image;
  final String? compareAtPrice;
  final Function onPress;
  const ItemCard({
    Key? key,
    this.title,
    this.price,
    this.image,
    this.compareAtPrice,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat('###,000');
    var calcu1 = int.parse(price!.replaceAll(".00", "")) /
        int.parse(compareAtPrice!.replaceAll(".00", ""));
    int calcu2 = (100 - calcu1 * 100).ceil();

    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: image!,
              imageBuilder: (context, imageProvider) => Container(
                height: 265,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Shimmer.fromColors(
                      child: Skeleton(
                        height: Get.height * .3,
                        width: (Get.height * .42) / 2,
                      ),
                      baseColor: baseColorSkeleton,
                      highlightColor: highlightColorSkeleton),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    alignment: Alignment.centerLeft,
                    child: CustomText(
                      text: title!,
                    ),
                  ),
                  (compareAtPrice == "0")
                      ? Text(
                          "Rp " + formatter.format(int.parse(price!)),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Row(
                          children: [
                            Text(
                              "Rp " +
                                  formatter.format(int.parse(compareAtPrice!)),
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Color.fromRGBO(155, 155, 155, 1),
                                  decoration: TextDecoration.lineThrough),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: Container(
                                width: 30.0,
                                height: 20.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromRGBO(187, 9, 21, 1),
                                ),
                                child: Center(
                                  child: Text(
                                    calcu2.toString() + '%',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  Row(
                    children: [
                      Text(
                        "Rp " + formatter.format(int.parse(price!)),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 229, 57, 53)),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

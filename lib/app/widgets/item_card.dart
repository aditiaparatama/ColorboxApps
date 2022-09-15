import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

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
    var calcu1 = int.parse(price!.replaceAll(".00", "")) /
        int.parse(compareAtPrice!.replaceAll(".00", ""));
    int calcu2 = (100 - calcu1 * 100).ceil();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                Image.asset("assets/images/Image.jpg"),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          const SizedBox(height: 12),
          Container(
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: title!,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          (compareAtPrice == "0" || compareAtPrice == price)
              ? Text(
                  "Rp " + formatter.format(int.parse(price!)),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : Row(
                  children: [
                    Text(
                      "Rp " + formatter.format(int.parse(compareAtPrice!)),
                      style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(155, 155, 155, 1),
                          decoration: TextDecoration.lineThrough),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 30.0,
                      height: 15.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: colorSaleRed,
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
                  ],
                ),
          SizedBox(
              height:
                  (compareAtPrice == "0" || compareAtPrice == price) ? 0 : 4),
          (compareAtPrice == "0" || compareAtPrice == price)
              ? const SizedBox()
              : Row(
                  children: [
                    Text(
                      "Rp " + formatter.format(int.parse(price!)),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color.fromARGB(255, 229, 57, 53)),
                    ),
                  ],
                )
        ],
      ),
    );
  }
}

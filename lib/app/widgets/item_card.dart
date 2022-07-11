import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Container(
      padding: const EdgeInsets.all(5),
      // height: 180,
      // width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: image!,
            imageBuilder: (context, imageProvider) => Container(
              height: 230,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            alignment: Alignment.centerLeft,
            child: CustomText(
              text: title!.toUpperCase(),
            ),
          ),
          (compareAtPrice == "0")
              ? Text(
                  "Rp " + formatter.format(int.parse(price!)),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : Row(
                  children: [
                    const Text(
                      "Rp ",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      formatter.format(int.parse(compareAtPrice!)) + " ",
                      style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough),
                    ),
                    Text(
                      formatter.format(int.parse(price!)),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 229, 57, 53)),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}

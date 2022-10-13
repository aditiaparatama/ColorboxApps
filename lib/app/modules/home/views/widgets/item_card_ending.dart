import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/control/menu_model.dart';
import 'package:colorbox/app/modules/control/sub_menu_model.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemCardEnding extends StatelessWidget {
  const ItemCardEnding({
    Key? key,
    required this.calcu1,
    required this.collection,
    required this.homeCollection,
    this.isCart = false,
    required this.i,
  }) : super(key: key);

  final double calcu1;
  final dynamic collection;
  final dynamic homeCollection;
  final bool isCart;
  final int i;

  @override
  Widget build(BuildContext context) {
    var menu = Menu(
        subMenu: List<SubMenu>.empty(),
        title: homeCollection["title"],
        subjectID: homeCollection["subjectid"]);
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.COLLECTIONS,
          arguments: {"menu": menu, "indexMenu": null, "sortBy": 2}),
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
                    Image.asset("assets/images/Image.jpg"),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              AspectRatio(
                aspectRatio: 2.08 / 3,
                child: Container(
                    color: colorOverlay.withOpacity(0.5),
                    child: SizedBox(
                      height: 220,
                      child: Center(
                        child: Expanded(
                          child: CustomText(
                            text: (isCart)
                                ? "Lihat \nLebih Banyak"
                                : "Lihat Lebih Banyak",
                            color: Colors.white,
                            fontSize: (isCart) ? 12 : 14,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )),
              )
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

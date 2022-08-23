import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      // leading: ,
      title: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                alignment: Alignment.centerLeft,
                onPressed: () => Get.toNamed(Routes.COLLECTIONS),
                icon: const Icon(Icons.menu)),
            CachedNetworkImage(
              imageUrl:
                  "https://cdn.shopify.com/s/files/1/0423/9120/8086/files/Logo_CB_300x300.png",
              imageBuilder: (context, imageProvider) => Container(
                width: 200,
                height: 50,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            IconButton(
                alignment: Alignment.centerRight,
                onPressed: () => Get.toNamed(Routes.SEARCH),
                icon: const Icon(Icons.search))
          ],
        ),
      ),
    );
  }
}

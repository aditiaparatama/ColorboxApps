import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      // leading: ,
      title: GestureDetector(
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // IconButton(
            //     alignment: Alignment.centerLeft,
            //     onPressed: () => Get.toNamed(Routes.COLLECTIONS),
            //     icon: const Icon(Icons.menu)),
            CachedNetworkImage(
              imageUrl:
                  "https://cdn.shopify.com/s/files/1/0423/9120/8086/files/logo_cb_94567010-1400-4ef0-b1b9-d03c6428ef0f.png?v=1662458868",
              imageBuilder: (context, imageProvider) => Container(
                width: 150,
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
            // IconButton(
            //     alignment: Alignment.centerRight,
            //     onPressed: () => Get.toNamed(Routes.SEARCH),
            //     icon: const Icon(Icons.search))
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 8),
            child: InkWell(
              onTap: () => ZoomDrawer.of(context)!.toggle(),
              child: const Icon(
                Icons.menu,
                size: 32,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              // Get.toNamed(Routes.CONTROL, arguments: 'Home');
            },
            child: Image.network(
              'https://cdn.shopify.com/s/files/1/0584/9363/2674/files/new-Logo-bar.png?v=1654500845',
              fit: BoxFit.fill,
              width: Get.width - 150,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

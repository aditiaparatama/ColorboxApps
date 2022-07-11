import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/control/controllers/control_controller.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: InkWell(
        onTap: () => ZoomDrawer.of(context)!.toggle(),
        child: const Icon(
          Icons.menu,
          size: 32,
          color: Colors.black,
        ),
      ),
      title: GestureDetector(
        onTap: () {
          Get.find<ControlController>().currentItem = 'Home';
          Get.find<ControlController>().update();
        },
        child: CachedNetworkImage(
          imageUrl:
              "https://cdn.shopify.com/s/files/1/0584/9363/2674/files/new-Logo-bar.png?v=1654500845",
          imageBuilder: (context, imageProvider) => Container(
            width: Get.width,
            height: 25,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.fill,
              ),
            ),
          ),
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(
            Icons.search,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
        InkWell(
          onTap: () {
            Get.toNamed(Routes.CART);
          },
          child: Padding(
            padding: const EdgeInsets.only(
              right: 10,
            ),
            child: SvgPicture.asset("assets/icon/bx-cart.svg"),
          ),
        ),
      ],
    );
  }
}

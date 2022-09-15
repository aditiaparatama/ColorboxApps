import 'package:colorbox/app/modules/product/controllers/product_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';

class CarouselWithIndicatorProduct extends StatefulWidget {
  const CarouselWithIndicatorProduct({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final ProductController controller;

  @override
  State<CarouselWithIndicatorProduct> createState() =>
      _CarouselWithIndicatorProductState();
}

class _CarouselWithIndicatorProductState
    extends State<CarouselWithIndicatorProduct> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    var controller;
    controller.product = context;
    controller.variant = controller.product.variants[0];
    var collection = Get.arguments["idCollection"]
        .replaceAll('gid://shopify/Collection/', '');

    final List<Widget> imageSliders = widget.controller.product.image
        .map((item) => Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(0)),
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: controller.product.image[item],
                  ),
                ),
              ),
            ))
        .toList();

    return Column(
      children: [
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 5),
              aspectRatio: 1 / 1,
              viewportFraction: 1,
              enlargeCenterPage: true,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
          carouselController: _controller,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children:
              widget.controller.product.image.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (_current == entry.key)
                        ? colorTextBlack
                        : const Color(0xFFE5E8EB)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

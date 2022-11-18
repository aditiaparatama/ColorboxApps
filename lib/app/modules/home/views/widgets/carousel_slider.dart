import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

class CarouselWithIndicator extends StatefulWidget {
  const CarouselWithIndicator({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final HomeController controller;

  @override
  State<CarouselWithIndicator> createState() => _CarouselWithIndicatorState();
}

class _CarouselWithIndicatorState extends State<CarouselWithIndicator> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.controller.sliders
        .map((item) => Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(0)),
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: item.images!,
                  ),
                ),
              ),
            ))
        .toList();

    return (widget.controller.sliders.length > 2)
        ? Column(
            children: [
              CarouselSlider(
                items: imageSliders,
                options: CarouselOptions(
                    autoPlay:
                        (widget.controller.sliders.length > 2) ? true : false,
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
              (widget.controller.sliders.length > 2)
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.controller.sliders
                          .asMap()
                          .entries
                          .map((entry) {
                        return GestureDetector(
                          onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 8.0,
                            height: 8.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (_current == entry.key)
                                    ? colorTextBlack
                                    : const Color(0xFFE5E8EB)),
                          ),
                        );
                      }).toList(),
                    )
                  : const SizedBox(height: 12),
            ],
          )
        : Container(
            padding: const EdgeInsets.only(bottom: 12),
            child: CachedNetworkImage(
              imageUrl: widget.controller.sliders[0].images!,
              width: MediaQuery.of(context).size.width,
            ),
          );
  }
}

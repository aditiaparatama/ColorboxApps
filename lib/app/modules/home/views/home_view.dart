import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorbox/app/modules/home/views/collection_view.dart';
import 'package:colorbox/app/widgets/custom_appbar.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import '../controllers/home_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class HomeView extends GetView<HomeController> {
  final List<String> imgList = [
    'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/Mobile-disney_1aec8eef-b841-4856-b2f4-09775c726b92.jpg',
    'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/mobile-66.jpg',
    'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/Online-mobile.jpg',
    'https://cdn.shopify.com/s/files/1/0423/9120/8086/files/Mobile-bella.jpg',
  ];

  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            // const MenuHeader(),
            const SizedBox(
              height: 5,
            ),

            // ignore: sized_box_for_whitespace
            CarouselSlider.builder(
              itemCount: imgList.length,
              options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                aspectRatio: 1 / 1,
                viewportFraction: 1,
                enlargeCenterPage: true,
              ),
              itemBuilder: (context, index, realIdx) {
                return Container(
                  // margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                    child: Center(
                      child: CachedNetworkImage(
                        imageUrl: imgList[index],
                      ),
                    ),
                  ),
                );
              },
            ),

            Row(
              children: [
                SizedBox(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://cdn.shopify.com/s/files/1/0423/9120/8086/files/banner_02_1280x@2x.progressive.jpg?v=1648085406",
                        fit: BoxFit.cover,
                        width: Get.width / 2 - 5,
                        height: Get.height / 2 - 50,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://cdn.shopify.com/s/files/1/0423/9120/8086/files/banner_01_1280x@2x.progressive.jpg?v=1648085405",
                        fit: BoxFit.cover,
                        width: Get.width / 2 - 5,
                        height: Get.height / 2 - 50,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            const SizedBox(height: 4),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: CustomText(
                        text: "PRODUK TERFAVORIT",
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CollectionsHomeView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

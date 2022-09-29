import 'package:colorbox/app/modules/home/views/sections/collection1_home.dart';
import 'package:colorbox/app/modules/home/views/sections/collection2_home.dart';
import 'package:colorbox/app/modules/home/views/sections/collection3_home.dart';
import 'package:colorbox/app/modules/home/views/sections/collection4_home.dart';
import 'package:colorbox/app/modules/home/views/sections/category_home.dart';
import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/home/views/widgets/announcement_home.dart';
import 'package:colorbox/app/modules/home/views/widgets/carousel_slider.dart';
import 'package:colorbox/app/modules/home/views/widgets/home_header.dart';
import 'package:colorbox/app/widgets/custom_appbar.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class HomeView extends GetView<HomeController> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: CustomAppBar(),
      ),
      body: GetBuilder(
          init: Get.put(HomeController()),
          builder: (_) {
            return SafeArea(
              child: (controller.sliders.isEmpty)
                  ? loadingCircular()
                  : (controller.collections.isEmpty)
                      ? loadingCircular()
                      : ListView(
                          children: [
                            const HomeSearch(),
                            const SizedBox(height: 24),
                            // ignore: sized_box_for_whitespace
                            CarouselWithIndicator(controller: controller),

                            if (controller.announcementHome.isNotEmpty)
                              AnnouncementHome(controller: controller),

                            Container(
                              color: const Color(0xFFF5F5F5),
                              height: 8,
                              width: Get.width,
                            ),
                            const SizedBox(height: 24),
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const CustomText(
                                    text: "Kategori Pakaian",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(height: 24),
                                  CategoryHomeView(),
                                ],
                              ),
                            ),

                            const Divider(
                              thickness: 10,
                              color: colorDiver,
                            ),

                            Container(
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 24, bottom: 8),
                                    child: CustomText(
                                      text: (controller.collections.isEmpty)
                                          ? ""
                                          : controller.collections[0].title!,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 24),
                                    child: CustomText(
                                      text: (controller.collections.isEmpty)
                                          ? ""
                                          : controller
                                              .collections[0].deskripsi!,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(
                                    child: Center(
                                      child: CachedNetworkImage(
                                        imageUrl: (controller
                                                .collections.isEmpty)
                                            ? ""
                                            : controller.collections[0].images!,
                                        fit: BoxFit.cover,
                                        width: Get.width,
                                        height: 190,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: CollectionHome1((controller
                                            .collections.isEmpty)
                                        ? ""
                                        : controller.collections[0].subjectid!
                                            .toString()),
                                  ),
                                  const Divider(
                                    thickness: 10,
                                    color: colorDiver,
                                  ),
                                  const SizedBox(height: 24),
                                  CustomText(
                                    text: (controller.collections.isEmpty)
                                        ? ""
                                        : controller.collections[1].title!,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomText(
                                    text: (controller.collections.isEmpty)
                                        ? ""
                                        : controller.collections[1].deskripsi!,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: CollectionHome2((controller
                                            .collections.isEmpty)
                                        ? ""
                                        : controller.collections[1].subjectid!
                                            .toString()),
                                  ),
                                  const Divider(
                                    thickness: 10,
                                    color: colorDiver,
                                  ),
                                  const SizedBox(height: 24),
                                  CustomText(
                                    text: (controller.collections.isEmpty)
                                        ? ""
                                        : controller.collections[2].title!,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomText(
                                    text: (controller.collections.isEmpty)
                                        ? ""
                                        : controller.collections[2].deskripsi!,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    child: Center(
                                      child: CachedNetworkImage(
                                        imageUrl: (controller
                                                .collections.isEmpty)
                                            ? ""
                                            : controller.collections[2].images!,
                                        fit: BoxFit.cover,
                                        width: Get.width,
                                        height: 190,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: CollectionHome3((controller
                                            .collections.isEmpty)
                                        ? ""
                                        : controller.collections[2].subjectid!
                                            .toString()),
                                  ),
                                  const Divider(
                                    thickness: 10,
                                    color: colorDiver,
                                  ),
                                  const SizedBox(height: 24),
                                  CustomText(
                                    text: (controller.collections.isEmpty)
                                        ? ""
                                        : controller.collections[3].title!,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(height: 8),
                                  CustomText(
                                    text: (controller.collections.isEmpty)
                                        ? ""
                                        : controller.collections[3].deskripsi!,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  const SizedBox(height: 24),
                                  Container(
                                    color: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: CollectionHome4((controller
                                            .collections.isEmpty)
                                        ? ""
                                        : controller.collections[3].subjectid!
                                            .toString()),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
            );
          }),
    );
  }
}

import 'package:colorbox/app/modules/home/views/sections/category_home.dart';
import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:colorbox/app/modules/home/views/widgets/announcement_home.dart';
import 'package:colorbox/app/modules/home/views/widgets/carousel_slider.dart';
import 'package:colorbox/app/modules/home/views/widgets/home_header.dart';
import 'package:colorbox/app/modules/home/views/widgets/home_section.dart';
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

                            const HomeSectionWidget()
                          ],
                        ),
            );
          }),
    );
  }
}

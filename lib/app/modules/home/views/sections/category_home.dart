import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class CategoryHomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
        init: Get.put(HomeController()),
        builder: (controller) {
          return SizedBox(
            height: Get.height * .25,
            child: (controller.category.isEmpty)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: controller.category.length,
                    scrollDirection: Axis.horizontal,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 0,
                            childAspectRatio: .98),
                    itemBuilder: (_, i) {
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed(Routes.COLLECTIONS, arguments: {
                            "menu": controller.category[i],
                            "menuIndex": null,
                            "sortBy": defaultSortBy
                          });
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: CachedNetworkImage(
                                  imageUrl: controller.category[i].image!,
                                  fit: BoxFit.cover,
                                  height: 50.0,
                                  width: 50.0,
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: CustomText(
                                  text: controller.category[i].title,
                                  textOverflow: TextOverflow.fade,
                                  fontSize: 12,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
          );
        });
  }
}

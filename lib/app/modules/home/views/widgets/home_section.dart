import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:colorbox/app/modules/home/controllers/homecollections_controller.dart';
import 'package:colorbox/app/modules/home/views/sections/collection1_home.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeSectionWidget extends GetView<HomeController> {
  const HomeSectionWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.collections.length,
            separatorBuilder: (context, index) {
              return const Divider(
                thickness: 10,
                color: colorDiver,
              );
            },
            itemBuilder: (context, index) {
              return Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 8),
                  child: CustomText(
                    text: (controller.collections.isEmpty)
                        ? ""
                        : controller.collections[index].title!,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                (controller.collections[index].deskripsi == null ||
                        controller.collections[index].deskripsi == "")
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: CustomText(
                          text: (controller.collections.isEmpty)
                              ? ""
                              : controller.collections[index].deskripsi!,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                (controller.collections[index].images == null ||
                        controller.collections[index].images == "")
                    ? const SizedBox()
                    : SizedBox(
                        child: Center(
                          child: CachedNetworkImage(
                            imageUrl: controller.collections[index].images!,
                            fit: BoxFit.cover,
                            width: Get.width,
                          ),
                        ),
                      ),
                const SizedBox(height: 12),
                CollectionHome1(
                    id: controller.collections[index].subjectid!, index: index),
              ]);
            }));
  }
}

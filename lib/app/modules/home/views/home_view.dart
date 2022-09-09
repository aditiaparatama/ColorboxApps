import 'package:colorbox/app/modules/home/views/sections/collection1_home.dart';
import 'package:colorbox/app/modules/home/views/sections/collection2_home.dart';
import 'package:colorbox/app/modules/home/views/sections/collection3_home.dart';
import 'package:colorbox/app/modules/home/views/sections/collection4_home.dart';
import 'package:colorbox/app/modules/home/views/sections/category_home.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/home/controllers/home_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:colorbox/app/widgets/custom_appbar.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class HomeView extends GetView<HomeController> {
  TextEditingController search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: CustomAppBar(),
      ),
      body: GetBuilder(
          init: Get.put(HomeController()),
          builder: (_) {
            return SafeArea(
              child: (controller.sliders.isEmpty &&
                      controller.collections.isEmpty)
                  ? loadingCircular()
                  : ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 8, 0, 16),
                              child: SizedBox(
                                height: 36,
                                width: MediaQuery.of(context).size.width - 100,
                                child: TextFormField(
                                  onTap: () => Get.toNamed(Routes.SEARCH),
                                  cursorColor:
                                      const Color.fromRGBO(245, 246, 248, 1),
                                  decoration: InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(245, 246, 248, 1),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: const BorderSide(
                                        color: Color.fromRGBO(245, 246, 248, 1),
                                        width: 1.0,
                                      ),
                                    ),
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(16, 10, 0, 0),
                                    disabledBorder: InputBorder.none,
                                    labelStyle: const TextStyle(
                                        fontSize: 12,
                                        color:
                                            Color.fromRGBO(245, 246, 248, 1)),
                                    hintText: "Cari produk disini",
                                    filled: true,
                                    fillColor:
                                        const Color.fromRGBO(245, 246, 248, 1),
                                    suffixIcon: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      child: GestureDetector(
                                        onTap: () => Get.toNamed(Routes.SEARCH),
                                        child: SvgPicture.asset(
                                            "assets/icon/bx-search1.svg"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 36,
                              width: 30,
                              child: InkWell(
                                onTap: () => Get.toNamed(Routes.CART,
                                    arguments: "collection"),
                                child: Stack(
                                  children: [
                                    Center(
                                      child: CircleAvatar(
                                        radius: 16.0,
                                        child: SvgPicture.asset(
                                            "assets/icon/bx-handbag.svg"),
                                      ),
                                    ),
                                    Get.find<CartController>()
                                            .cart
                                            .lines!
                                            .isNotEmpty
                                        ? Container(
                                            alignment: Alignment.centerRight,
                                            padding: const EdgeInsets.only(
                                                left: 15, bottom: 5),
                                            child: Container(
                                              width: 15,
                                              height: 15,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  color: Colors.red),
                                              child: CustomText(
                                                text: Get.find<CartController>()
                                                    .cart
                                                    .lines!
                                                    .length
                                                    .toString(),
                                                fontSize: 10,
                                                color: Colors.white,
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        // ignore: sized_box_for_whitespace
                        CarouselSlider.builder(
                          itemCount: controller.sliders.length,
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
                              decoration:
                                  const BoxDecoration(shape: BoxShape.circle),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(0)),
                                child: Center(
                                  child: CachedNetworkImage(
                                    imageUrl: controller.sliders[index].images!,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 16, bottom: 6),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(238, 242, 246, 1),
                              border: Border.all(
                                  width: 1.0,
                                  color:
                                      const Color.fromRGBO(238, 242, 246, 1)),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(12, 16, 8, 16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  CircleAvatar(
                                    radius: 16.0,
                                    child: SvgPicture.asset(
                                        "assets/icon/bx-speaker.svg"),
                                    backgroundColor: Colors.transparent,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: CustomText(
                                      text:
                                          'Sehubungan dengan adanya perbaikan sistem, \nmaka akan ada keterlambatan dalam proses \npengiriman pesanan anda. Terima kasih atas \npengertian anda dan mohon maaf \natas ketidaknyamananya',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const Divider(
                          height: 30,
                          thickness: 10,
                          color: Color.fromRGBO(245, 245, 245, 1),
                        ),

                        Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: CustomText(
                                    text: "Kategori Pakaian",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                CategoryHomeView(),
                              ],
                            ),
                          ),
                        ),

                        const Divider(
                          thickness: 10,
                          color: Color.fromRGBO(245, 245, 245, 1),
                        ),

                        Container(
                          decoration: const BoxDecoration(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 24, bottom: 8),
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
                                      : controller.collections[0].deskripsi!,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                child: Center(
                                  child: CachedNetworkImage(
                                    imageUrl: (controller.collections.isEmpty)
                                        ? ""
                                        : controller.collections[0].images!,
                                    fit: BoxFit.cover,
                                    width: Get.width,
                                    height: 190,
                                  ),
                                ),
                              ),
                              Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 12, 16, 0),
                                  child: CollectionHome1(
                                      (controller.collections.isEmpty)
                                          ? ""
                                          : controller.collections[0].subjectid!
                                              .toString()),
                                ),
                              ),
                              const Divider(
                                thickness: 10,
                                color: Color.fromRGBO(245, 245, 245, 1),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 24, bottom: 8),
                                child: CustomText(
                                  text: (controller.collections.isEmpty)
                                      ? ""
                                      : controller.collections[1].title!,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: CustomText(
                                  text: (controller.collections.isEmpty)
                                      ? ""
                                      : controller.collections[1].deskripsi!,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 12, 16, 0),
                                  child: CollectionHome2(
                                      (controller.collections.isEmpty)
                                          ? ""
                                          : controller.collections[1].subjectid!
                                              .toString()),
                                ),
                              ),
                              const Divider(
                                thickness: 10,
                                color: Color.fromRGBO(245, 245, 245, 1),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 24, bottom: 8),
                                child: CustomText(
                                  text: (controller.collections.isEmpty)
                                      ? ""
                                      : controller.collections[2].title!,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: CustomText(
                                  text: (controller.collections.isEmpty)
                                      ? ""
                                      : controller.collections[2].deskripsi!,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                child: Center(
                                  child: CachedNetworkImage(
                                    imageUrl: (controller.collections.isEmpty)
                                        ? ""
                                        : controller.collections[2].images!,
                                    fit: BoxFit.cover,
                                    width: Get.width,
                                    height: 190,
                                  ),
                                ),
                              ),
                              Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 12, 16, 0),
                                  child: CollectionHome3(
                                      (controller.collections.isEmpty)
                                          ? ""
                                          : controller.collections[2].subjectid!
                                              .toString()),
                                ),
                              ),
                              const Divider(
                                thickness: 10,
                                color: Color.fromRGBO(245, 245, 245, 1),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 24, bottom: 8),
                                child: CustomText(
                                  text: (controller.collections.isEmpty)
                                      ? ""
                                      : controller.collections[3].title!,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 24),
                                child: CustomText(
                                  text: (controller.collections.isEmpty)
                                      ? ""
                                      : controller.collections[3].deskripsi!,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 12, 16, 0),
                                  child: CollectionHome4(
                                      (controller.collections.isEmpty)
                                          ? ""
                                          : controller.collections[3].subjectid!
                                              .toString()),
                                ),
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

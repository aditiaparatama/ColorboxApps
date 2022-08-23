import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/modules/collections/views/widgets/collection_body.dart';
import 'package:colorbox/app/modules/collections/views/widgets/search_form.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class CollectionsMainView extends GetView<CollectionsController> {
  final ScrollController _sControl = ScrollController();
  final PageController _pControl = PageController();

  void onScroll() {
    double maxScroll = _sControl.position.maxScrollExtent;
    double currentScroll = _sControl.position.pixels;

    if (currentScroll == maxScroll && controller.collection.hasNextPage!) {
      if (!controller.nextLoad.value) {
        controller.fetchAddCollectionProduct(controller.subjectID);
        controller.update();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var sortBy = Get.arguments["sortBy"];
    var indexMenu = Get.arguments["indexMenu"];

    controller.setTabBar(Get.arguments["menu"],
        parent: (Get.arguments["indexMenu"] == null) ? true : false);
    controller.fetchCollectionProduct(
        (Get.arguments["indexMenu"] == null)
            ? controller.menu.subjectID!
            : controller.menu[Get.arguments["indexMenu"]].subjectID!,
        sortBy!);
    controller.subjectID = (Get.arguments["indexMenu"] == null)
        ? controller.menu.subjectID!
        : controller.menu[Get.arguments["indexMenu"]].subjectID!;
    _sControl.addListener(onScroll);
    if (Get.arguments["indexMenu"] != null) {
      controller.onChangeList(indexMenu);
    }

    const textStyle = TextStyle(
        fontSize: 14.0, color: Colors.white, fontWeight: FontWeight.w400);

    return GetBuilder<CollectionsController>(
        init: Get.put(CollectionsController()),
        builder: (control) {
          return (control.listTabs.isEmpty)
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : DefaultTabController(
                  length: control.listTabs.length,
                  child: Builder(builder: (context) {
                    final TabController tabController =
                        DefaultTabController.of(context)!;
                    if (Get.arguments["indexMenu"] != null) {
                      tabController.index = controller.selectedIndex;
                    }
                    return Scaffold(
                        appBar: AppBar(
                          elevation: 1,
                          title: const SearchCollection(),
                        ),
                        body: PageView.builder(
                            controller: _pControl,
                            itemCount: control.listTabs.length,
                            onPageChanged: (index) {
                              controller.selectedIndex = index;
                              controller.onChangeList(index);
                              tabController.index = index;
                            },
                            itemBuilder: ((context, index) {
                              return controller.loading.value
                                  ? SizedBox(
                                      height: Get.height * .5,
                                      child: const Center(
                                          child: CircularProgressIndicator(
                                        color: Colors.black,
                                      )),
                                    )
                                  : (control.collection.products.isEmpty)
                                      ? SizedBox(
                                          height: Get.height * .5,
                                          child: const Center(
                                              child: Text("Data not found")))
                                      : Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          16, 26, 0, 0),
                                                      child: CustomText(
                                                        text:
                                                            "${control.collection.handle!.toUpperCase().replaceAll("-NEW-ARRIVAL", "").replaceAll("WOMEN-", "").replaceAll("MEN-", "")} "
                                                            "",
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 28, 16, 0),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        child: InkWell(
                                                          onTap: () {
                                                            bottomSheet(control
                                                                .collection
                                                                .id!);
                                                          },
                                                          child: Row(
                                                            children: [
                                                              CircleAvatar(
                                                                radius: 16.0,
                                                                child: SvgPicture
                                                                    .asset(
                                                                        "assets/icon/bx-sort-amount.svg"),
                                                              ),
                                                              const CustomText(
                                                                text: 'Urutkan',
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // ignore: avoid_unnecessary_containers
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      16, 5, 16, 5),
                                              child: TabBar(
                                                controller: tabController,
                                                isScrollable: true,
                                                tabs: control.listTabs,
                                                labelColor: Colors.white,
                                                labelStyle: textStyle.copyWith(
                                                    fontSize: 14.0,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w600),
                                                indicator: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            0), // Creates border
                                                    color: Colors.black),
                                                unselectedLabelColor:
                                                    const Color.fromRGBO(
                                                        155, 155, 155, 1),
                                                onTap: (index) {
                                                  _pControl.jumpToPage(index);
                                                },
                                              ),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 5, 0, 5),
                                              child: CollectionBody(
                                                  controller: controller,
                                                  sControl: _sControl),
                                            ),
                                          ],
                                        );
                            })));
                  }),
                );
        });
  }

  Container bagWidget() {
    return Container(
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(left: 15, bottom: 5),
      child: Container(
        width: 15,
        height: 15,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.red),
        child: CustomText(
          text: Get.find<CartController>().cart.lines!.length.toString(),
          fontSize: 10,
          color: Colors.white,
        ),
      ),
    );
  }

  void bottomSheet(context) {
    var sortByContext =
        int.parse(context.replaceAll("gid://shopify/Collection/", ""));
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(defaultPadding),
        height: Get.height * .41,
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(
                      Icons.close,
                      size: 16,
                    )),
                const CustomText(
                  text: "Urut Berdasarkan :",
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ],
            ),
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(Get.width, 20),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                controller.fetchCollectionProduct(sortByContext, 1);
                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CustomText(
                    text: 'Popularitas',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  // SizedBox(
                  //   child: InkWell(
                  //     onTap: () {},
                  //     child: CircleAvatar(
                  //       radius: 16.0,
                  //       child:
                  //           SvgPicture.asset("assets/icon/bx-sort-amount.svg"),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(Get.width, 10),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                controller.fetchCollectionProduct(sortByContext, 2);
                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const CustomText(
                    text: 'Produk Terbaru',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  SizedBox(
                    child: InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 16.0,
                        child: SvgPicture.asset("assets/icon/bx-check.svg"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(Get.width, 10),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                controller.fetchCollectionProduct(sortByContext, 3);
                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CustomText(
                    text: 'Harga Tinggi ke Rendah',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  // SizedBox(
                  //   child: InkWell(
                  //     onTap: () {},
                  //     child: CircleAvatar(
                  //       radius: 16.0,
                  //       child:
                  //           SvgPicture.asset("assets/icon/bx-sort-amount.svg"),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
            TextButton(
              style: TextButton.styleFrom(
                  fixedSize: Size(Get.width, 10),
                  alignment: Alignment.centerLeft),
              onPressed: () {
                controller.fetchCollectionProduct(sortByContext, 4);
                Get.back();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  CustomText(
                    text: 'Harga Rendah ke Tinggi',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  // SizedBox(
                  //   child: InkWell(
                  //     onTap: () {},
                  //     child: CircleAvatar(
                  //       radius: 16.0,
                  //       child:
                  //           SvgPicture.asset("assets/icon/bx-sort-amount.svg"),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            const Divider(
              color: colorDiver,
              thickness: 1,
            ),
          ],
        ),
      ),
      isDismissible: true,
      enableDrag: false,
    );
  }
}

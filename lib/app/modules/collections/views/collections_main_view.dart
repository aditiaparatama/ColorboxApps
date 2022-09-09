import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/modules/collections/views/widgets/collection_body.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/collections/views/widgets/search_collection.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/empty_page.dart';
import 'package:colorbox/app/widgets/widget.dart';
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
        parent: (Get.arguments["indexMenu"] == null) ? true : false,
        index: indexMenu ?? 0);
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
          return DefaultTabController(
            length: control.listTabs.length,
            child: Builder(builder: (context) {
              final TabController tabController =
                  DefaultTabController.of(context)!;
              if (indexMenu != null) {
                tabController.index = controller.selectedIndex;
              }
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  backgroundColor: Colors.white,
                  appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(56),
                    child: AppBar(
                      title: const SearchCollection(),
                      centerTitle: false,
                      elevation: 3,
                      shadowColor: Colors.grey.withOpacity(0.3),
                      leadingWidth: 36,
                      leading: IconButton(
                          padding: const EdgeInsets.all(16),
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back)),
                      actions: [
                        bagWidget(),
                      ],
                    ),
                  ),
                  body: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 16, right: 16, top: 16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: Get.width * .65,
                              child: TabBar(
                                isScrollable: true,
                                tabs: control.listTabs,
                                controller: tabController,
                                labelColor: Colors.black,
                                labelPadding:
                                    const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                labelStyle: textStyle.copyWith(
                                    fontSize: 14.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                                unselectedLabelStyle: textStyle.copyWith(
                                    fontSize: 14.0,
                                    color: const Color(0xFF9B9B9B)),
                                onTap: (index) {
                                  controller.setTabBar(Get.arguments["menu"],
                                      parent:
                                          (Get.arguments["indexMenu"] == null)
                                              ? true
                                              : false,
                                      index: index);
                                  _pControl.jumpToPage(index);
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: () => bottomSheet(control.collection.id!),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 8),
                                decoration: const BoxDecoration(
                                  border: Border(
                                      left:
                                          BorderSide(color: Color(0xFFE5E8EB)),
                                      top: BorderSide(color: Color(0xFFE5E8EB)),
                                      bottom:
                                          BorderSide(color: Color(0xFFE5E8EB))),
                                ),
                                child: SvgPicture.asset(
                                    "assets/icon/ArrowsDownUp.svg"),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 11, vertical: 8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFE5E8EB))),
                              child: SvgPicture.asset(
                                  "assets/icon/SlidersHorizontal.svg"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: Get.height * .77,
                        child: PageView.builder(
                            controller: _pControl,
                            itemCount: control.listTabs.length,
                            onPageChanged: (index) {
                              controller.selectedIndex = index;
                              controller.onChangeList(index);
                              tabController.index = index;
                              controller.setTabBar(Get.arguments["menu"],
                                  parent: (Get.arguments["indexMenu"] == null)
                                      ? true
                                      : false,
                                  index: index);
                            },
                            itemBuilder: ((context, index) {
                              return Container(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                  child: controller.loading.value
                                      ? Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          child: GridView.builder(
                                              controller: _sControl,
                                              itemCount: 4,
                                              gridDelegate:
                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                mainAxisSpacing: 3,
                                                crossAxisSpacing: 3,
                                                childAspectRatio: 0.52,
                                              ),
                                              itemBuilder: (_, i) {
                                                return loadingProduct();
                                              }),
                                        )
                                      : (control.collection.products.isEmpty)
                                          ? SizedBox(
                                              height: Get.height * .5,
                                              child: EmptyPage(
                                                image: Image.asset(
                                                  "assets/icon/SEARCH.gif",
                                                  height: 180,
                                                ),
                                                textHeader:
                                                    "Data Tidak Tersedia",
                                                textContent:
                                                    "Tidak ada data yang ditampilkan",
                                              ))
                                          : CollectionBody(
                                              controller: controller,
                                              sControl: _sControl));
                            })),
                      )
                    ],
                  ));
            }),
          );
        });
  }

  Widget checklistWidget(int sortBy, String text) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      CustomText(
        text: text,
        fontSize: 14,
        fontWeight: (sortBy == controller.orderBy)
            ? FontWeight.bold
            : FontWeight.normal,
      ),
      (sortBy == controller.orderBy)
          ? CircleAvatar(
              radius: 16.0,
              child: SvgPicture.asset("assets/icon/bx-check.svg"),
            )
          : const SizedBox()
    ]);
  }

  Widget bagWidget() {
    return Center(
      child: InkWell(
        onTap: () => Get.toNamed(Routes.CART),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 16,
              ),
              child: SvgPicture.asset(
                "assets/icon/Handbag.svg",
              ),
            ),
            Get.find<CartController>().cart.lines!.isNotEmpty
                ? Positioned(
                    top: 0,
                    right: 10,
                    child: Container(
                      width: 15,
                      height: 15,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
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
    );
  }

  void bottomSheet(id) {
    var sortByContext =
        int.parse(id.replaceAll("gid://shopify/Collection/", ""));
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(defaultPadding),
        height: Get.height * .45,
        decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: GetBuilder<CollectionsController>(builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(
                        Icons.close,
                        size: 18,
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
                    fixedSize: Size(Get.width, 10),
                    alignment: Alignment.centerLeft),
                onPressed: () {
                  controller.fetchCollectionProduct(sortByContext, 2);
                  Get.back();
                },
                child: checklistWidget(2, "Produk Terbaru"),
              ),
              const Divider(
                color: colorDiver,
                thickness: 1,
              ),
              TextButton(
                style: TextButton.styleFrom(
                    fixedSize: Size(Get.width, 20),
                    alignment: Alignment.centerLeft),
                onPressed: () {
                  controller.fetchCollectionProduct(sortByContext, 1);
                  Get.back();
                },
                child: checklistWidget(1, "Popularitas"),
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
                child: checklistWidget(3, "Harga Tinggi ke Rendah"),
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
                child: checklistWidget(4, "Harga Rendah ke Tinggi"),
              ),
              const Divider(
                color: colorDiver,
                thickness: 1,
              ),
            ],
          );
        }),
      ),
      isDismissible: true,
      enableDrag: false,
      isScrollControlled: true,
    );
  }
}

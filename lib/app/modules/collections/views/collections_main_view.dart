import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/modules/collections/views/widgets/collection_body.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/collections/views/widgets/filter_bottomsheet.dart';
import 'package:colorbox/app/modules/collections/views/widgets/search_collection.dart';
import 'package:colorbox/app/modules/collections/views/widgets/sort_bottomsheet.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/empty_page.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    var _menu = Get.arguments["menu"];

    controller.setTabBar(_menu,
        parent: (indexMenu == null) ? true : false, index: indexMenu ?? 0);
    controller.fetchCollectionProduct(
        (indexMenu == null)
            ? controller.menu.subjectID!
            : controller.menu[indexMenu].subjectID!,
        sortBy!);
    controller.subjectID = (indexMenu == null)
        ? controller.menu.subjectID!
        : controller.menu[indexMenu].subjectID!;
    _sControl.addListener(onScroll);
    if (indexMenu != null) {
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
                            Expanded(
                              child: SizedBox(
                                child: TabBar(
                                  isScrollable: true,
                                  tabs: control.listTabs,
                                  controller: tabController,
                                  labelColor: colorTextBlack,
                                  labelPadding:
                                      const EdgeInsets.fromLTRB(0, 0, 8, 0),
                                  labelStyle: textStyle.copyWith(
                                      fontSize: 14.0,
                                      color: colorTextBlack,
                                      fontWeight: FontWeight.w600),
                                  unselectedLabelStyle: textStyle.copyWith(
                                      fontSize: 14.0,
                                      color: const Color(0xFF9B9B9B)),
                                  onTap: (index) {
                                    controller.setTabBar(_menu,
                                        parent:
                                            (indexMenu == null) ? true : false,
                                        index: index);
                                    _pControl.jumpToPage(index);
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            InkWell(
                              onTap: (controller.loading.value)
                                  ? null
                                  : () =>
                                      sortBottomSheet(control.collection.id!),
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
                            InkWell(
                              onTap: (controller.loading.value)
                                  ? null
                                  : () => filterBottomSheet(),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 11, vertical: 8),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: const Color(0xFFE5E8EB))),
                                child: SvgPicture.asset(
                                    "assets/icon/SlidersHorizontal.svg"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: PageView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              controller: _pControl,
                              itemCount: control.listTabs.length,
                              onPageChanged: (index) {
                                controller.selectedIndex = index;
                                tabController.index = index;
                                controller.setTabBar(_menu,
                                    parent: (indexMenu == null) ? true : false,
                                    index: index);
                                controller.onChangeList(index);
                              },
                              itemBuilder: ((context, index) {
                                return SizedBox(
                                    child: controller.loading.value
                                        ? GridView.builder(
                                            shrinkWrap: true,
                                            controller: _sControl,
                                            itemCount: 4,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 24,
                                              crossAxisSpacing: 24,
                                              childAspectRatio: 9 / 16,
                                            ),
                                            itemBuilder: (_, i) {
                                              return loadingProduct();
                                            })
                                        : (control.collection.products.isEmpty)
                                            ? SizedBox(
                                                height: Get.height * .5,
                                                child: EmptyPage(
                                                  image: Image.asset(
                                                    "assets/icon/SEARCH.gif",
                                                    height: 180,
                                                  ),
                                                  textHeader:
                                                      "Produk tidak ditemukan",
                                                  textContent:
                                                      "Produk yang kamu cari tidak tersedia",
                                                ))
                                            : CollectionBody(
                                                controller: controller,
                                                sControl: _sControl));
                              })),
                        ),
                      )
                    ],
                  ));
            }),
          );
        });
  }

  Widget bagWidget() {
    return GetBuilder<CartController>(
        init: Get.put(CartController()),
        builder: (cartController) {
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
                  cartController.cart.lines!.isNotEmpty
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
                              text:
                                  cartController.cart.totalQuantity.toString(),
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
        });
  }
}

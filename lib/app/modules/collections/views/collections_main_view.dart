import 'package:colorbox/app/modules/collections/controllers/collections_controller.dart';
import 'package:colorbox/app/modules/collections/views/widgets/collection_body.dart';
import 'package:colorbox/app/modules/collections/views/widgets/filter_bottomsheet.dart';
import 'package:colorbox/app/modules/collections/views/widgets/sort_bottomsheet.dart';
import 'package:colorbox/app/widgets/appbar_new.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/empty_page.dart';
import 'package:colorbox/app/widgets/widget.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class CollectionsMainView extends GetView<CollectionsController> {
  final ScrollController _sControl = ScrollController();
  final PageController _pControl = PageController();

  bool showBtn = false;

  void onScroll() {
    double maxScroll = _sControl.position.maxScrollExtent;
    double currentScroll = _sControl.position.pixels;

    if (currentScroll == maxScroll && controller.collection.hasNextPage!) {
      if (!controller.nextLoad.value) {
        controller.fetchAddCollectionProduct(controller.subjectID);
        controller.update();
      }
    }

    double showoffset =
        100.0; //Back to top botton will show on scroll offset 10.0

    if (_sControl.offset > showoffset) {
      showBtn = true;
      controller.update();
    } else {
      showBtn = false;
      controller.update();
    }
  }

  // This function is triggered when the user presses the back-to-top button
  void _scrollToTop() {
    _sControl.animateTo(0,
        duration: const Duration(seconds: 1), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    var sortBy = Get.arguments["sortBy"];
    var indexMenu = Get.arguments["indexMenu"];
    var _menu = Get.arguments["menu"];

    Smartlook.instance.trackEvent('PCP');

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
                    child: AppBarNew(
                      title: (indexMenu == null)
                          ? _menu.title.toUpperCase()
                          : _menu[0].subject.toUpperCase(),
                    )),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 16),
                      child: Row(
                        children: [
                          if (control.listTabs.length > 1) ...[
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
                          ],
                          InkWell(
                            onTap: (controller.loading.value)
                                ? null
                                : () => sortBottomSheet(control.collection.id!),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.5, vertical: 6.2),
                              decoration: const BoxDecoration(
                                border: Border(
                                    left: BorderSide(color: Color(0xFFE5E8EB)),
                                    top: BorderSide(color: Color(0xFFE5E8EB)),
                                    bottom:
                                        BorderSide(color: Color(0xFFE5E8EB))),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      "assets/icon/arrows-up-down.svg"),
                                  if (control.listTabs.length == 1) ...[
                                    const SizedBox(width: 8),
                                    const CustomText(
                                      text: "Sortir",
                                      color: colorNeutral100,
                                      fontWeight: FontWeight.w400,
                                    )
                                  ]
                                ],
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (controller.loading.value)
                                ? null
                                : () => filterBottomSheet(),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.5, vertical: 6.2),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFE5E8EB))),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                      "assets/icon/adjustments-horizontal.svg"),
                                  if (control.listTabs.length == 1) ...[
                                    const SizedBox(width: 8),
                                    const CustomText(
                                      text: "Filter",
                                      color: colorNeutral100,
                                      fontWeight: FontWeight.w400,
                                    )
                                  ]
                                ],
                              ),
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
                                            mainAxisSpacing: 16,
                                            crossAxisSpacing: 16,
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
                ),
                floatingActionButton: AnimatedOpacity(
                    opacity: showBtn ? 1.0 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: FloatingActionButton.small(
                      backgroundColor: Colors.white.withOpacity(0.7),
                      // foregroundColor: Colors.white.withOpacity(0.5),
                      onPressed: () => _scrollToTop(),
                      child: const Icon(
                        Icons.keyboard_arrow_up_rounded,
                        size: 28,
                      ),
                    )),
              );
            }),
          );
        });
  }
}

import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/modules/collections/views/widgets/collection_body.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/collections_controller.dart';

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
    var indexMenu = Get.arguments["indexMenu"];
    controller.setTabBar(Get.arguments["menu"]);
    controller.fetchCollectionProduct(controller.menu[0].subjectID!);
    controller.subjectID = controller.menu[0].subjectID!;
    _sControl.addListener(onScroll);
    controller.onChangeList(indexMenu);

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
                    tabController.index = indexMenu;
                    return Scaffold(
                        appBar: AppBar(
                          title: Text(
                              "${control.collection.handle!.toUpperCase().replaceAll("-NEW-ARRIVAL", "").replaceAll("WOMEN-", "").replaceAll("MEN-", "")} (" +
                                  control.collection.productsCount.toString() +
                                  ")"),
                          centerTitle: true,
                          actions: [
                            InkWell(
                              onTap: () {
                                Get.toNamed(Routes.CART,
                                    arguments: "collection");
                              },
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(right: 10),
                                    child: Center(
                                      child: SvgPicture.asset(
                                          "assets/icon/bx-shopping-bag.svg"),
                                    ),
                                  ),
                                  Get.find<CartController>()
                                          .cart
                                          .lines!
                                          .isNotEmpty
                                      ? bagWidget()
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ],
                          bottom: TabBar(
                            controller: tabController,
                            indicatorColor: Colors.black,
                            isScrollable: true,
                            tabs: control.listTabs,
                            onTap: (index) {
                              _pControl.jumpToPage(index);
                              // controller.onChangeList(index);
                            },
                          ),
                        ),
                        body: PageView.builder(
                            controller: _pControl,
                            itemCount: control.listTabs.length,
                            onPageChanged: (index) {
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
                                      : Container(
                                          margin: const EdgeInsets.only(top: 5),
                                          child: CollectionBody(
                                              controller: controller,
                                              sControl: _sControl),
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
}

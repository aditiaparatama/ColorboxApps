import 'package:colorbox/app/modules/search/controllers/search_controller.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/item_card.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable, use_key_in_widget_constructors
class SearchView extends GetView<SearchController> {
  TextEditingController search = TextEditingController();
  final ScrollController _sControl = ScrollController();

  void onScroll() {
    double maxScroll = _sControl.position.maxScrollExtent;
    double currentScroll = _sControl.position.pixels;

    if (currentScroll == maxScroll &&
        controller.product[controller.product.length - 1].hasNextPage!) {
      if (!controller.nextLoad.value) {
        controller.fetchAddSearchProduct(search.text);
        controller.update();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _sControl.addListener(onScroll);
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            title: searchWidget(context),
          ),
        ),
        body: GetBuilder<SearchController>(
            init: Get.put(SearchController()),
            builder: (control) {
              return (control.loading.value)
                  ? const Center(child: CircularProgressIndicator())
                  : (control.product.isEmpty)
                      ? Column()
                      : Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(7,0,7,24),
                            child: SizedBox(
                                height: MediaQuery.of(context).size.height *
                                    (controller.nextLoad.value ? .8 : .84),
                                child: GridView.builder(
                                    itemCount: control.product.length,
                                    controller: _sControl,
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 10,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 0.52,
                                    ),
                                    itemBuilder: (_, i) {
                                      return GestureDetector(
                                        onTap: () => Get.toNamed(
                                            Routes.PRODUCT,
                                            arguments: {
                                              "product": control.product[i],
                                              "idCollection": NewArrivalString
                                            }),
                                        child: ItemCard(
                                          title: control.product[i].title!,
                                          image: control.product[i].image[0],
                                          price: control
                                              .product[i].variants[0].price!
                                              .replaceAll(".00", ""),
                                          compareAtPrice: (control
                                                      .product[i]
                                                      .variants[0]
                                                      .compareAtPrice ==
                                                  null)
                                              ? "0"
                                              : control.product[i].variants[0]
                                                  .compareAtPrice!
                                                  .replaceAll(".00", ""),
                                          onPress: () {},
                                        ),
                                      );
                                    })),
                          ),
                          controller.nextLoad.value
                              ? const Center(
                                  child: SizedBox(
                                    child: CircularProgressIndicator(
                                      color: Colors.blue,
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      );
            }));
  }

  Row searchWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(
          height: 36,
          width: MediaQuery.of(context).size.width - 140,
          child: TextField(
            autofocus: true,
            controller: search,
            onChanged: (value) {
              controller.fetchSearchProduct(search.text);
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color.fromRGBO(250, 250, 250, 1),
              hintText: "Cari produk disini",
              suffixIcon: IconButton(
                onPressed: () {
                  controller.fetchSearchProduct(search.text);
                },
                icon: Icon(Icons.search, color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(250, 250, 250, 1),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5.0),
                borderSide: const BorderSide(
                  color: Color.fromRGBO(250, 250, 250, 1),
                  width: 1.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 36,
          width: 50,
          child: InkWell(
            onTap: () => Get.toNamed(Routes.CART, arguments: "collection"),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Center(
                    child: CircleAvatar(
                      radius: 16.0,
                      child: SvgPicture.asset("assets/icon/bx-handbag.svg"),
                    ),
                  ),
                ),
                Get.find<CartController>().cart.lines!.isNotEmpty
                    ? Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(left: 15, bottom: 5),
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
        ),
      ],
    );
  }
}

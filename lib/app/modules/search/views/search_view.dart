import 'package:colorbox/app/modules/search/controllers/search_controller.dart';
import 'package:colorbox/app/modules/cart/controllers/cart_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/app/widgets/empty_page.dart';
import 'package:colorbox/app/widgets/item_card.dart';
import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/globalvar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

// ignore: must_be_immutable, use_key_in_widget_constructors
class SearchView extends GetView<SearchController> {
  TextEditingController search = TextEditingController();
  final ScrollController _sControl = ScrollController();
  Timer? _debounce;

  _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      // do something with query
      controller.fetchSearchProduct(search.text);
    });
  }

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
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: AppBar(
            title: searchWidget(context),
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
        body: GetBuilder<SearchController>(
            init: Get.put(SearchController()),
            builder: (control) {
              return (control.loading.value)
                  ? const Center(child: CircularProgressIndicator())
                  : (control.firstView)
                      ? const SizedBox()
                      : (control.product.isEmpty)
                          ? Column(
                              children: [
                                const SizedBox(height: 40),
                                EmptyPage(
                                  image: Image.asset(
                                    "assets/icon/SEARCH.gif",
                                    height: 180,
                                  ),
                                  textHeader: "Pencarian Tidak Ditemukan",
                                  textContent:
                                      "Hasil pencarian '${search.text}' tidak ditemukan. \nCoba kata kunci lain",
                                ),
                              ],
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 24),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Hasil pencarian ',
                                      style: const TextStyle(
                                          fontSize: 14, color: Colors.black),
                                      children: <TextSpan>[
                                        const TextSpan(
                                          text: '"',
                                        ),
                                        TextSpan(
                                            text: search.text,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14)),
                                        const TextSpan(
                                          text: '"',
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  Flexible(
                                    child: SizedBox(
                                        child: GridView.builder(
                                            shrinkWrap: true,
                                            itemCount: control.product.length,
                                            controller: _sControl,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              mainAxisSpacing: 24,
                                              crossAxisSpacing: 24,
                                              childAspectRatio: 2.6 / 5,
                                            ),
                                            itemBuilder: (_, i) {
                                              return GestureDetector(
                                                onTap: () => Get.toNamed(
                                                    Routes.PRODUCT,
                                                    arguments: {
                                                      "product":
                                                          control.product[i],
                                                      "idCollection":
                                                          NewArrivalString
                                                    }),
                                                child: ItemCard(
                                                  title:
                                                      control.product[i].title!,
                                                  image: control
                                                      .product[i].image[0],
                                                  price: control.product[i]
                                                      .variants[0].price!
                                                      .replaceAll(".00", ""),
                                                  compareAtPrice: (control
                                                              .product[i]
                                                              .variants[0]
                                                              .compareAtPrice ==
                                                          null)
                                                      ? "0"
                                                      : control
                                                          .product[i]
                                                          .variants[0]
                                                          .compareAtPrice!
                                                          .replaceAll(
                                                              ".00", ""),
                                                  onPress: () {},
                                                ),
                                              );
                                            })),
                                  ),
                                  controller.nextLoad.value
                                      ? Container(
                                          padding: const EdgeInsets.all(12),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              color: colorTextBlack,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            );
            }));
  }

  Widget searchWidget(BuildContext context) {
    return SizedBox(
      height: 36,
      child: TextField(
        cursorColor: colorTextBlack,
        autofocus: true,
        controller: search,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          hintText: "Cari produk disini",
          suffixIcon: IconButton(
            onPressed: () {
              controller.fetchSearchProduct(search.text);
            },
            icon: Icon(Icons.search, color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(
              color: Color(0xFFFAFAFA),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6.0),
            borderSide: const BorderSide(
              color: Color(0xFFFAFAFA),
              width: 1.0,
            ),
          ),
        ),
      ),
    );
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
}

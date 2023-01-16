import 'package:colorbox/app/modules/search/controllers/search_controller.dart';
import 'package:colorbox/app/modules/wishlist/controllers/wishlist_controller.dart';
import 'package:colorbox/app/widgets/custom_text.dart';
import 'package:colorbox/constance.dart';
import 'package:colorbox/helper/custom_colors.dart';
import 'package:flutter/material.dart';

class CustomPCPRadioColor extends StatefulWidget {
  final int indexProduct;
  final List<String>? listData;
  final dynamic controller;

  const CustomPCPRadioColor(
      {Key? key,
      required this.listData,
      required this.indexProduct,
      this.controller})
      : super(key: key);

  @override
  createState() {
    return CustomPCPRadioColorState();
  }
}

class CustomPCPRadioColorState extends State<CustomPCPRadioColor> {
  List<RadioModel> radioData = [];
  int lastIndex = 0;
  // CollectionsController controller = Get.find<CollectionsController>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeSettings() async {
    radioData = [];
    for (int i = 0; i < widget.listData!.length; i++) {
      if (i == 3) break;
      radioData.add(
          RadioModel((i == lastIndex) ? true : false, widget.listData![i]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeSettings(),
        builder: (context, snapshot) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: widget.listData!.length > 3 ? 4 : radioData.length,
            itemBuilder: (BuildContext context, int index) {
              return (index == 3)
                  ? Center(
                      child: CustomText(
                        text: "+${widget.listData!.length - 3} warna",
                        color: colorNeutral90,
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                      ),
                    )
                  : InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        setState(() {
                          if (widget.controller is WishlistController ||
                              widget.controller is SearchController) {
                            widget.controller.changeColorProduct(
                                widget.indexProduct,
                                radioData[index].buttonText,
                                widget.controller.product[widget.indexProduct]
                                    .handle!);
                          } else {
                            widget.controller.changeColorProduct(
                                widget.indexProduct,
                                radioData[index].buttonText,
                                widget.controller.collection
                                    .products[widget.indexProduct].handle!);
                          }
                          for (final x in radioData) {
                            x.isSelected = false;
                          }
                          radioData[index].isSelected = true;
                          lastIndex = index;
                        });
                      },
                      child: RadioItem(radioData[index]),
                    );
            },
          );
        });
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  // ignore: prefer_const_constructors_in_immutables
  RadioItem(this._item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Row(
        children: <Widget>[
          Container(
            height: 24.0,
            width: 24.0,
            decoration: BoxDecoration(
              border: Border.all(
                color: _item.isSelected ? colorNeutral100 : colorNeutral60,
                width: 1.0,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: Center(
              child: Container(
                height: 18.0,
                width: 18.0,
                child: const Center(),
                decoration: BoxDecoration(
                  color: customColors(_item.buttonText),
                  borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String buttonText;

  RadioModel(this.isSelected, this.buttonText);
}

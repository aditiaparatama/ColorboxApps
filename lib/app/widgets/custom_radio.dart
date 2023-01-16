import 'package:colorbox/app/modules/product/controllers/product_controller.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

class CustomRadio extends StatefulWidget {
  final List<String>? listData;
  final ProductController controller;
  const CustomRadio(
      {Key? key, required this.listData, required this.controller})
      : super(key: key);

  @override
  createState() {
    return CustomRadioState();
  }
}

class CustomRadioState extends State<CustomRadio> {
  List<RadioModel> radioData = [];
  int? lastIndex;
  // final ProductController _productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeSettings() async {
    radioData = [];
    for (int i = 0; i < widget.listData!.length; i++) {
      radioData.add(RadioModel(
          (lastIndex != null && lastIndex == i) ? true : false,
          widget.listData![i],
          widget.controller.getStock(
              widget.listData![i],
              (widget.controller.variant!.options.length > 1)
                  ? widget.controller.variant!.options[1].value!
                  : "")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        initialData: initializeSettings(),
        builder: (context, snapshot) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.listData!.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                //highlightColor: Colors.red,
                splashColor: Colors.blueAccent,
                onTap: () {
                  lastIndex = index;
                  widget.controller.sizeTemp = radioData[index].buttonText;
                  widget.controller.getSelectedValue(
                      radioData[index].buttonText,
                      (widget.controller.variant!.options.length > 1)
                          ? widget.controller.variant!.options[1].value!
                          : "");
                  setState(() {
                    // ignore: avoid_function_literals_in_foreach_calls
                    radioData.forEach((element) => element.isSelected = false);
                    radioData[index].isSelected = true;
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
      margin: const EdgeInsets.only(right: 10),
      child: Stack(
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 5),
            padding: const EdgeInsets.symmetric(horizontal: 5),
            height: 30.0,
            width: (_item.buttonText.length > 6) ? 85.0 : 50.0,
            child: Center(
              child: Text(_item.buttonText,
                  style: TextStyle(
                      color: _item.stock == 0
                          ? const Color.fromRGBO(155, 155, 155, 1)
                          : _item.isSelected
                              ? Colors.white
                              : colorTextBlack,
                      fontWeight: _item.isSelected
                          ? FontWeight.w400
                          : FontWeight.normal,
                      fontSize: 14.0)),
            ),
            decoration: BoxDecoration(
              color: _item.stock == 0
                  ? const Color.fromRGBO(229, 232, 235, 1)
                  : _item.isSelected
                      ? colorTextBlack
                      : Colors.transparent,
              border: Border.all(
                  width: 1.0,
                  color: _item.isSelected
                      ? colorTextBlack
                      : const Color.fromRGBO(155, 155, 155, 0.3)),
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
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
  final int stock;

  RadioModel(this.isSelected, this.buttonText, this.stock);
}

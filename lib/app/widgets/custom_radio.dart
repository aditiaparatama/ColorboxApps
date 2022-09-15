import 'package:colorbox/app/modules/product/controllers/product_controller.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomRadio extends StatefulWidget {
  final List<String>? listData;
  const CustomRadio({Key? key, required this.listData}) : super(key: key);

  @override
  createState() {
    return CustomRadioState();
  }
}

class CustomRadioState extends State<CustomRadio> {
  List<RadioModel> radioData = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.listData!.length; i++) {
      radioData.add(RadioModel(
          false,
          widget.listData![i],
          Get.find<ProductController>().getStock(
              widget.listData![i],
              (Get.find<ProductController>().variant!.options.length > 1)
                  ? Get.find<ProductController>().variant!.options[1].value!
                  : "")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.listData!.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          //highlightColor: Colors.red,
          splashColor: Colors.blueAccent,
          onTap: () {
            Get.find<ProductController>().getSelectedValue(
                radioData[index].buttonText,
                (Get.find<ProductController>().variant!.options.length > 1)
                    ? Get.find<ProductController>().variant!.options[1].value!
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
            width: 50.0,
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

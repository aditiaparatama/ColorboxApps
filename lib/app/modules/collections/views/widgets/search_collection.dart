import 'package:colorbox/app/routes/app_pages.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchCollection extends StatelessWidget {
  const SearchCollection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: TextFormField(
        readOnly: true,
        onTap: () => Get.toNamed(Routes.SEARCH),
        cursorColor: colorTextBlack,
        decoration: InputDecoration(
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
          contentPadding: const EdgeInsets.fromLTRB(16, 10, 0, 0),
          disabledBorder: InputBorder.none,
          // labelStyle: const TextStyle(
          //     fontSize: 10, color: Color.fromARGB(155, 155, 155, 1)),
          hintText: "Cari produk disini",
          hintStyle: const TextStyle(fontSize: 12, color: Color(0xFF9B9B9B)),
          filled: true,
          fillColor: const Color(0xFFF5F6F8),
          suffixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: GestureDetector(
              onTap: () => Get.toNamed(Routes.SEARCH),
              child: SvgPicture.asset("assets/icon/bx-search1.svg",
                  color: const Color(0xFF9B9B9B)),
            ),
          ),
        ),
      ),
    );
  }
}

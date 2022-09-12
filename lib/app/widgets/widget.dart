import 'package:colorbox/app/widgets/skeleton.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

Container searchWidget(BuildContext context) {
  return Container(
    padding: const EdgeInsets.only(top: 0, right: 10),
    width: MediaQuery.of(context).size.width,
    height: 45,
    child: TextField(
      autofocus: true,
      onChanged: (value) {
        // ignore: avoid_print
        print(value);
      },
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Colors.grey.shade400),
        labelText: "Search...",
        suffixIcon: IconButton(
          onPressed: () {},
          icon: Icon(Icons.search, color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 1, color: Colors.grey.shade400),
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
      ),
    ),
  );
}

Shimmer loadingProduct() {
  return Shimmer.fromColors(
    baseColor: baseColorSkeleton,
    highlightColor: highlightColorSkeleton,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeleton(
          height: 220,
          width: (Get.height * .45) / 2,
        ),
        const SizedBox(height: 2),
        const Skeleton(
          height: 10,
          width: 150,
        ),
        const SizedBox(height: 2),
        const Skeleton(
          height: 15,
          width: 125,
        )
      ],
    ),
  );
}

Center loadingCircular() {
  return const Center(
    child: CircularProgressIndicator(
      color: Colors.black,
    ),
  );
}

Widget customDivider() {
  return const Padding(
    padding: EdgeInsets.only(top: 4, bottom: 6),
    child: Divider(
      color: colorDiver,
      thickness: 1,
    ),
  );
}

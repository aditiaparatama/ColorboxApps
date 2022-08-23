import 'package:colorbox/app/widgets/my_input_theme.dart';
import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';
import 'app/routes/app_pages.dart';
import 'package:get/get.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Colorbox",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData(
        primarySwatch: primaryWhite,
        fontFamily: "Inter",
        backgroundColor: Colors.grey.shade200,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: MyInputTheme().theme(),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.blue,
          selectionHandleColor: Colors.black,
        ),
      ),
    ),
  );
}

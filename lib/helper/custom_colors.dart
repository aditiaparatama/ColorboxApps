import 'package:colorbox/constance.dart';
import 'package:flutter/material.dart';

Color customColors(String color) {
  switch (color.toLowerCase().replaceAll(" ", "")) {
    case "white":
      return Colors.white;
    case "red":
      return Colors.red;
    case "pink":
      return Colors.pink;
    case "softpink":
      return Colors.pink.shade100;
    case "lightpink":
      return Colors.pink.shade100;
    case "grey":
      return Colors.grey;
    case "blue":
      return Colors.blue;
    case "black":
      return colorTextBlack;
    case "green":
      return Colors.green;
    case "brown":
      return Colors.brown;
    case "orange":
      return Colors.orange;
    case "yellow":
      return Colors.yellow;
    case "gold":
      return const Color(0xFFFFD700);
    case "banana":
      return const Color(0xFFFFE135);
    case "honey":
      return const Color(0xFFF9C901);
    case "mango":
      return const Color(0xFFF4BB44);
    case "lightgrey":
      return const Color(0xFFD3D3D3);
    case "lt.grey":
      return const Color(0xFFD3D3D3);
    case "lightblue":
      return Colors.lightBlue;
    case "lt.blue":
      return Colors.lightBlue;
    case "olive":
      return const Color(0xFF808000);
    case "purple":
      return Colors.purple;
    case "maroon":
      return const Color(0xFF800000);
    case "darkred":
      return const Color(0xFF9D0000);
    case "navy":
      return const Color(0xFF0B0B45);
    case "khaki":
      return const Color(0xFFF0E68C);
    case "beige":
      return const Color(0xFFF5F5DC);
    case "ash":
      return const Color(0xFF696969);
    case "army":
      return const Color(0xFF4b5320);
    case "indigo":
      return const Color(0xFF4b0082);
    case "ochre":
      return const Color(0xFFCC7722);
    case "burntorange":
      return const Color(0xFFCC5500);
    case "charcoal":
      return const Color(0xFF36454f);
    case "terracotta":
      return const Color(0xFFEC7063);
    case "chocolate":
      return const Color(0xFFD2691E);
    case "taupe":
      return const Color(0xFF483c32);
    case "lime":
      return const Color(0xFF27D507);
    case "dustypink":
      return const Color(0xFFb77b82);
    case "burgundy":
      return const Color(0xFF800020);
    case "darkgrey":
      return const Color(0xFF6B6B6B);
    case "copper":
      return const Color(0xFFB87333);
    case "wine":
      return const Color(0xFF742F37);
    case "darkbrown":
      return const Color(0xFF4E3524);
    case "mint":
      return const Color(0xFF98FF98);
    case "offwhite":
      return const Color(0xFFF8F8FF);
    case "tosca":
      return const Color(0xFF68F3F8);
    case "lavender":
      return const Color(0xFFE6E6FA);
    case "chartreuse":
      return const Color(0xFFE1E100);
    case "citrus":
      return const Color(0xFF9FB70A);
    case "jade":
      return const Color(0xFF00a86b);
    case "limegreen":
      return const Color(0xFF27D507);
    case "camel":
      return const Color(0xFFC19A6B);
    default:
      return Colors.grey;
  }
}

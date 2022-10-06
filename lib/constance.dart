import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const int _blackPrimaryValue = 0xFF000000;
const int _whitePrimaryValue = 0xFFFFFFFF;
const double sfontTitle = 20;
const double sfontPrice = 18;
const double sfontPromo = 16;
const double sfontDefault = 14;
const Color colorPrimary = colorTextBlack;
const Color secondColor = Colors.white;
const Color colorDiver = Color(0xFFF5F6F8);

const Color colorBorderGrey = Color(0xFFE5E8EB);
const Color colorTextGrey = Color(0xFF9B9B9B);
const Color colorTextBlack = Color(0xFF212121);
const Color colorSaleRed = Color(0xFFBB0915);
const Color colorTextRed = Color(0xFFDA2929);
const Color colorTextBlue = Color(0xFF115AC8);
const Color colorOverlay = Color(0xFF777777);
const Color colorBoxInfo = Color(0xFFEEF2F6);

// ignore: constant_identifier_names
const CACHED_CART_DATA = 'CACHED_CART_DATA';
// ignore: constant_identifier_names
const CACHED_USER_DATA = 'CACHED_USER_DATA';
// ignore: constant_identifier_names
const CACHED_USER_TOKEN = 'CACHED_USER_TOKEN';

const Color primaryColor = Color(0xFFFFFFFF);
const Color grayColor = Color(0xFF8D8D8E);
const Color baseColorSkeleton = colorTextBlack;
const Color highlightColorSkeleton = Colors.grey;

var formatter = NumberFormat.decimalPattern("id");

const double defaultPadding = 8.0;

const MaterialColor primaryBlack = MaterialColor(
  _blackPrimaryValue,
  <int, Color>{
    50: Color(0xFE111111),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(_blackPrimaryValue),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);

const MaterialColor primaryWhite = MaterialColor(
  _whitePrimaryValue,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(_whitePrimaryValue),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

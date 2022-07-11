import 'package:flutter/material.dart';

const int _blackPrimaryValue = 0xFF000000;
const int _whitePrimaryValue = 0xFFFFFFFF;

const double sfontTitle = 20;
const double sfontPrice = 18;
const double sfontPromo = 16;
const double sfontDefault = 14;
const double defaultPadding = 16.0;
const double defaultBorderRadius = 12.0;

const Color colorPrimary = Colors.black;
const Color secondColor = Colors.white;

// ignore: constant_identifier_names
const CACHED_CART_DATA = 'CACHED_CART_DATA';
// ignore: constant_identifier_names
const CACHED_USER_DATA = 'CACHED_USER_DATA';
// ignore: constant_identifier_names
const CACHED_USER_TOKEN = 'CACHED_USER_TOKEN';

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

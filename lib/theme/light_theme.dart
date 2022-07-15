import 'package:flutter/material.dart';

import 'base_theme.dart';

var lightTheme = BaseTheme(
  brightness: Brightness.light,
  backgroundColor: const Color(0xFFFFFFFF),
  inputFillColor: const Color(0xFFEFEFF0),
  inputPrefixIconColor: const Color(0xFF848484),
  bottomNavBarBackgroundColor: const Color(0xFFF5F5F5).withOpacity(.65),
  bottomNavBarUnselectedColor: const Color(0xFF959595),
  appBarBackgroundColor: const Color(0xFFF5F5F5).withOpacity(.65),
  dividerColor: const Color(0XFFD9D9D9),
  cardColor: const Color(0XFFF5F5F5),
  textColor: Colors.black,
  secondaryIconColor: const Color(0xFF999999),
  messageBoxBorderColor: const Color(0xFFc5c5c7),
  outMessageBackgroundColor: const Color(0xFFe9e9eb),
);

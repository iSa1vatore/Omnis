import 'package:flutter/material.dart';

import 'base_theme.dart';

var darkTheme = BaseTheme(
  brightness: Brightness.dark,
  backgroundColor: const Color(0xFF000000),
  inputPrefixIconColor: const Color(0xFF98989F),
  inputFillColor: const Color(0XFF1C1C1F),
  bottomNavBarBackgroundColor: const Color(0xFF1B1B1B).withOpacity(0.65),
  bottomNavBarUnselectedColor: const Color(0XFF7D7E7D),
  appBarBackgroundColor: const Color(0xFF1B1B1B).withOpacity(0.65),
  dividerColor: const Color(0XFF333336),
  cardColor: const Color(0XFF1C1C1E),
  textColor: Colors.white,
  secondaryIconColor: const Color(0xFF757575),
  messageBoxBorderColor: const Color(0xFF464649),
  outMessageBackgroundColor: const Color(0xFF262629),
);

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/extensions/color.dart';
import 'package:omnis/theme/styles/slider.dart';

import 'extra_colors.dart';

class BaseTheme {
  final Color backgroundColor;
  final Brightness brightness;
  final Color inputFillColor;
  final Color inputPrefixIconColor;
  final Color bottomNavBarBackgroundColor;
  final Color bottomNavBarUnselectedColor;
  final Color appBarBackgroundColor;
  final Color dividerColor;
  final Color cardColor;
  final Color textColor;
  final Color secondaryIconColor;
  final Color messageBoxBorderColor;
  final Color outMessageBackgroundColor;
  final Color contextMenuColor;
  final Color inverseTextColor;

  TextStyle defaultTextStyle = const TextStyle();

  static List<MaterialColor> get accents => [
        const Color(0xFF4ab841).toMaterialColor(),
        const Color(0xFF4ab5d3).toMaterialColor(),
        const Color(0xFF7988a3).toMaterialColor(),
        const Color(0xFFd04336).toMaterialColor(),
        const Color(0xFF936cda).toMaterialColor(),
        const Color(0xFFe27d2b).toMaterialColor(),
      ];

  BaseTheme({
    required this.backgroundColor,
    required this.brightness,
    required this.inputFillColor,
    required this.inputPrefixIconColor,
    required this.bottomNavBarBackgroundColor,
    required this.bottomNavBarUnselectedColor,
    required this.appBarBackgroundColor,
    required this.dividerColor,
    required this.cardColor,
    required this.textColor,
    required this.secondaryIconColor,
    required this.messageBoxBorderColor,
    required this.outMessageBackgroundColor,
    required this.contextMenuColor,
    required this.inverseTextColor,
  });

  ThemeData build(
    BuildContext context, {
    required MaterialColor accentColor,
  }) {
    if (context.platform.isAndroid) {
      defaultTextStyle = const TextStyle(
        fontFamily: 'Ubuntu',
        letterSpacing: 0.2,
      );
    }

    var splashColor = context.platform.isAndroid
        ? accentColor.withOpacity(.5)
        : Colors.transparent;

    var highlightColor =
        context.platform.isAndroid ? accentColor.withOpacity(.25) : null;

    var appBarTheme = context.platform.isIos
        ? AppBarTheme(
            backgroundColor: appBarBackgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: accentColor),
          )
        : AppBarTheme(
            backgroundColor: appBarBackgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(color: accentColor),
            titleTextStyle: defaultTextStyle.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 26,
              color: textColor,
            ),
            systemOverlayStyle: brightness == Brightness.light
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light,
          );

    return ThemeData(
      extensions: <ThemeExtension<dynamic>>[
        ExtraColors(
          secondaryIconColor: secondaryIconColor,
          messageBackgroundColor: accentColor,
          outMessageBackgroundColor: outMessageBackgroundColor,
          messageBoxBorderColor: messageBoxBorderColor,
          outMessageTextColor:
              outMessageBackgroundColor.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
          messageTextColor: accentColor.computeLuminance() > 0.5
              ? Colors.black
              : Colors.white,
          dangerColor: const Color(0xFFff453a),
          contextMenuColor: contextMenuColor,
          inverseTextColor: inverseTextColor,
        ),
      ],
      cardColor: cardColor,
      splashColor: splashColor,
      highlightColor: highlightColor,
      dividerColor: dividerColor,
      brightness: brightness,
      scaffoldBackgroundColor: backgroundColor,
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
        fillColor: inputFillColor,
        filled: true,
        prefixIconColor: inputFillColor,
        hintStyle: defaultTextStyle.copyWith(
          fontSize: 16.0,
          height: 1.25,
        ),
      ),
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: accentColor,
      ).copyWith(
        secondary: accentColor,
        brightness: brightness,
      ),
      appBarTheme: appBarTheme,
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 0,
        backgroundColor: bottomNavBarBackgroundColor,
        selectedLabelStyle: defaultTextStyle.copyWith(
          fontSize: 12.0,
          height: 1.4,
        ),
        unselectedLabelStyle: defaultTextStyle.copyWith(
          fontSize: 12.0,
          height: 1.4,
        ),
        selectedItemColor: accentColor,
        unselectedItemColor: bottomNavBarUnselectedColor,
        selectedIconTheme: const IconThemeData(size: 27),
        unselectedIconTheme: const IconThemeData(size: 27),
      ),
      textTheme: const TextTheme().copyWith(
        caption: defaultTextStyle.copyWith(
          color: const Color(0xFF8d8d8e),
          fontSize: 14.0,
        ),
        subtitle1: defaultTextStyle.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 15.0,
        ),
        subtitle2: defaultTextStyle.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 16.0,
        ),
        bodyText1: defaultTextStyle.copyWith(
          fontSize: 16.0,
          fontWeight: FontWeight.normal,
        ),
        bodyText2: defaultTextStyle.copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.normal,
        ),
        button: defaultTextStyle.copyWith(
          fontSize: 13.0,
          fontWeight: FontWeight.w500,
        ),
      ),
      sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
        trackHeight: 2.5,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:omnis/theme/extra_colors.dart';

import '../utils/platform_utils.dart';

extension LocalizedBuildContext on BuildContext {
  AppLocalizations get loc =>
      Localizations.of<AppLocalizations>(this, AppLocalizations)!;

  ThemeData get theme => Theme.of(this);

  ExtraColors get extraColors => Theme.of(this).extension<ExtraColors>()!;

  TextTheme get textTheme => theme.textTheme;

  PlatformUtils get platform => PlatformUtils(this);

  EdgeInsets get safeInsets => MediaQuery.of(this).padding;

  EdgeInsets safePadding({
    double left = 0,
    double right = 0,
    double top = 0,
    double bottom = 0,
  }) {
    return EdgeInsets.only(
      left: safeInsets.left + left,
      right: safeInsets.right + right,
      top: safeInsets.top + top,
      bottom: safeInsets.bottom + bottom + kBottomNavigationBarHeight,
    );
  }

  Size get mediaQuerySize => MediaQuery.of(this).size;

  double get appBarHeight {
    if (platform.isIos) {
      return kMinInteractiveDimensionCupertino +
          MediaQuery.of(this).padding.top +
          16;
    } else {
      return kToolbarHeight + MediaQuery.of(this).padding.top + 16;
    }
  }

  double get mediaQueryShortestSide => mediaQuerySize.shortestSide;

  Orientation get orientation => MediaQuery.of(this).orientation;

  bool get isLandscape => orientation == Orientation.landscape;

  bool get isPortrait => orientation == Orientation.portrait;

  bool get isPhone => (mediaQueryShortestSide < 600);

  bool get isSmallTablet => (mediaQueryShortestSide >= 600);

  bool get isLargeTablet => (mediaQueryShortestSide >= 720);

  bool get isTablet => isSmallTablet || isLargeTablet;

  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    var deviceWidth = mediaQuerySize.shortestSide;
    if (platform.isDesktop) {
      deviceWidth = mediaQuerySize.width;
    }
    if (deviceWidth >= 1200 && desktop != null) return desktop;
    if (deviceWidth >= 600 && tablet != null) return tablet;

    return mobile;
  }
}

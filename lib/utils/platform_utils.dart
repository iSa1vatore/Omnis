import 'package:flutter/cupertino.dart';
import 'package:omnis/extensions/build_context.dart';

class PlatformUtils {
  final BuildContext context;

  PlatformUtils(this.context);

  TargetPlatform get type => context.theme.platform;

  bool get isAndroid => type == TargetPlatform.android;

  bool get isIos => type == TargetPlatform.iOS;

  bool get isMacOS => type == TargetPlatform.macOS;

  bool get isWindows => type == TargetPlatform.windows;

  bool get isLinux => type == TargetPlatform.linux;

  bool get isDesktop => isMacOS || isWindows || isLinux;
}

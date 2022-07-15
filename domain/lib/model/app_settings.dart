import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_settings.freezed.dart';

@freezed
class AppSettings with _$AppSettings {
  const factory AppSettings({
    required bool privacyShowInPeopleNearby,
    required bool privacyClosedMessages,
    required int interfaceDarkThemeId,
    required int interfaceLightThemeId,
    required int interfaceColorAccent,
    required int interfaceMessageTextSize,
    required int interfaceMessageCornerRadius,
    required bool interfaceBlurEffect,
    required bool interfaceForceDarkMode,
    required String? interfaceChatBackground,
    required bool connectionUseSockets,
    required bool connectionKeepInBackground,
  }) = _AppSettings;
}

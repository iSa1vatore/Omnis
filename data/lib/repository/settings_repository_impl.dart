import 'package:domain/model/app_settings.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton()
class SettingsRepository {
  final SharedPreferences storage;

  SettingsRepository({
    required this.storage,
  });

  final _settingsStream = BehaviorSubject<AppSettings>();

  Stream<AppSettings> observe() {
    return _settingsStream.asBroadcastStream();
  }

  AppSettings get _value => _settingsStream.value;

  bool get privacyShowInPeopleNearby => _value.privacyShowInPeopleNearby;

  bool get privacyClosedMessages => _value.privacyClosedMessages;

  void load() {
    _settingsStream.add(AppSettings(
      privacyShowInPeopleNearby: storage.getBool(
            SettingsKeys.showInPeopleNearby,
          ) ??
          true,
      privacyClosedMessages: storage.getBool(
            SettingsKeys.closedMessages,
          ) ??
          false,
      interfaceDarkThemeId: storage.getInt(SettingsKeys.darkThemeId) ?? 1,
      interfaceLightThemeId: storage.getInt(SettingsKeys.lightThemeId) ?? 1,
      interfaceColorAccent: storage.getInt(SettingsKeys.colorAccent) ?? 0,
      interfaceMessageTextSize:
          storage.getInt(SettingsKeys.messageTextSize) ?? 16,
      interfaceMessageCornerRadius:
          storage.getInt(SettingsKeys.messageCornerRadius) ?? 12,
      interfaceBlurEffect: storage.getBool(SettingsKeys.blurEffect) ?? true,
      interfaceForceDarkMode:
          storage.getBool(SettingsKeys.forceDarkMode) ?? false,
      interfaceChatBackground: storage.getString(SettingsKeys.chatBackground),
      connectionUseSockets: storage.getBool(SettingsKeys.useSockets) ?? true,
      connectionKeepInBackground:
          storage.getBool(SettingsKeys.keepInBackground) ?? true,
    ));
  }

  Future<bool> setPrivacyShowInPeopleNearby(bool value) {
    _settingsStream.add(_value.copyWith(privacyShowInPeopleNearby: value));

    return storage.setBool(SettingsKeys.showInPeopleNearby, value);
  }

  Future<bool> setPrivacyClosedMessages(bool value) {
    _settingsStream.add(_value.copyWith(privacyClosedMessages: value));

    return storage.setBool(SettingsKeys.closedMessages, value);
  }

  Future<bool> setInterfaceBlurEffect(bool value) {
    _settingsStream.add(_value.copyWith(interfaceBlurEffect: value));

    return storage.setBool(SettingsKeys.blurEffect, value);
  }

  Future<bool> setInterfaceForceDarkMode(bool value) {
    _settingsStream.add(_value.copyWith(interfaceForceDarkMode: value));

    return storage.setBool(SettingsKeys.forceDarkMode, value);
  }

  Future<bool> setInterfaceColorAccent(int value) {
    _settingsStream.add(_value.copyWith(interfaceColorAccent: value));

    return storage.setInt(SettingsKeys.colorAccent, value);
  }

  Future<bool> setConnectionUseSockets(bool value) {
    _settingsStream.add(_value.copyWith(connectionUseSockets: value));

    return storage.setBool(SettingsKeys.useSockets, value);
  }

  Future<bool> setConnectionKeepInBackground(bool value) {
    _settingsStream.add(_value.copyWith(connectionKeepInBackground: value));

    return storage.setBool(SettingsKeys.keepInBackground, value);
  }
}

abstract class SettingsKeys {
  const SettingsKeys._();

  static const String showInPeopleNearby = 'privacy-show-in-people-nearby';
  static const String closedMessages = 'privacy-closed-messaged';

  static const String darkThemeId = 'interface-dark-theme-id';
  static const String lightThemeId = 'interface-light-theme-id';
  static const String colorAccent = 'interface-color-accent';
  static const String messageTextSize = 'interface-message-text-size';
  static const String messageCornerRadius = 'interface-message-corner-radius';
  static const String blurEffect = 'interface-blur-effect';
  static const String forceDarkMode = 'interface-force-dark-mode';
  static const String chatBackground = 'interface-chat-background';

  static const String useSockets = 'connection-use-sockets';
  static const String keepInBackground = 'connection-background';
}

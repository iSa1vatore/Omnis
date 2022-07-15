import 'package:data/repository/settings_repository_impl.dart';
import 'package:domain/model/app_settings.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'settings_bloc.freezed.dart';

@injectable
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingsRepository settingsRepository;

  SettingsBloc(this.settingsRepository) : super(const SettingsState()) {
    on<InitEvent>((event, emit) async {
      settingsRepository.load();

      await emit.forEach<AppSettings>(
        settingsRepository.observe(),
        onData: (settings) => SettingsState(
          privacyShowInPeopleNearby: settings.privacyShowInPeopleNearby,
          privacyClosedMessages: settings.privacyClosedMessages,
          interfaceDarkThemeId: settings.interfaceDarkThemeId,
          interfaceLightThemeId: settings.interfaceLightThemeId,
          interfaceColorAccent: settings.interfaceColorAccent,
          interfaceMessageTextSize: settings.interfaceMessageTextSize,
          interfaceMessageCornerRadius: settings.interfaceMessageCornerRadius,
          interfaceBlurEffect: settings.interfaceBlurEffect,
          interfaceForceDarkMode: settings.interfaceForceDarkMode,
          interfaceChatBackground: settings.interfaceChatBackground,
          connectionUseSockets: settings.connectionUseSockets,
          connectionKeepInBackground: settings.connectionKeepInBackground,
        ),
      );
    });

    on<SetThemeAccent>((event, emit) {
      settingsRepository.setInterfaceColorAccent(event.accent);
    });

    on<ToggleInterfaceBlur>((event, emit) {
      settingsRepository.setInterfaceBlurEffect(!state.interfaceBlurEffect);
    });

    on<ToggleForceDarkMode>((event, emit) {
      settingsRepository.setInterfaceForceDarkMode(
        !state.interfaceForceDarkMode,
      );
    });

    on<ToggleShowInPeopleNearby>((event, emit) {
      settingsRepository.setPrivacyShowInPeopleNearby(
        !state.privacyShowInPeopleNearby,
      );
    });

    on<ToggleClosedMessages>((event, emit) {
      settingsRepository.setPrivacyClosedMessages(
        !state.privacyClosedMessages,
      );
    });

    on<ToggleUseSockets>((event, emit) {
      settingsRepository.setConnectionUseSockets(
        !state.connectionUseSockets,
      );
    });

    on<ToggleKeepInBackground>((event, emit) {
      settingsRepository.setConnectionKeepInBackground(
        !state.connectionKeepInBackground,
      );
    });
  }
}

@freezed
class SettingsEvent with _$SettingsEvent {
  const factory SettingsEvent.init() = InitEvent;

  const factory SettingsEvent.setThemeAccent(int accent) = SetThemeAccent;

  const factory SettingsEvent.toggleInterfaceBlur() = ToggleInterfaceBlur;

  const factory SettingsEvent.toggleForceDarkMode() = ToggleForceDarkMode;

  const factory SettingsEvent.toggleShowInPeopleNearby() =
      ToggleShowInPeopleNearby;

  const factory SettingsEvent.toggleClosedMessages() = ToggleClosedMessages;

  const factory SettingsEvent.toggleUseSockets() = ToggleUseSockets;

  const factory SettingsEvent.toggleKeepInBackground() = ToggleKeepInBackground;
}

@freezed
class SettingsState with _$SettingsState {
  const SettingsState._();

  const factory SettingsState({
    @Default(true) bool privacyShowInPeopleNearby,
    @Default(false) bool privacyClosedMessages,
    @Default(1) int interfaceDarkThemeId,
    @Default(1) int interfaceLightThemeId,
    @Default(0) int interfaceColorAccent,
    @Default(16) int interfaceMessageTextSize,
    @Default(12) int interfaceMessageCornerRadius,
    @Default(true) bool interfaceBlurEffect,
    @Default(false) bool interfaceForceDarkMode,
    @Default(null) String? interfaceChatBackground,
    @Default(true) bool connectionUseSockets,
    @Default(true) bool connectionKeepInBackground,
  }) = Initial;
}

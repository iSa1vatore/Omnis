import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/pages/settings/widgets/settings_param_cell.dart';
import 'package:omnis/theme/base_theme.dart';
import 'package:omnis/widgets/adaptive_slider.dart';
import 'package:omnis/widgets/divider.dart';

import '../../../../widgets/adaptive_app_bar.dart';
import '../../../../widgets/adaptive_switch.dart';
import '../../../../widgets/simple_color_selector.dart';
import '../../settings_bloc.dart';
import '../../widgets/chat_preview.dart';
import '../../widgets/settings_params_container.dart';
import '../../widgets/theme_preview.dart';

class SettingsInterfacePage extends StatelessWidget {
  const SettingsInterfacePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SettingsInterfaceView();
  }
}

class SettingsInterfaceView extends StatelessWidget {
  const SettingsInterfaceView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsBloc = context.watch<SettingsBloc>();

    var bodyPadding = context
        .safePadding(
          left: context.platform.isIos ? 16 : 0,
          right: context.platform.isIos ? 16 : 0,
        )
        .copyWith(
          top: context.appBarHeight,
        );

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AdaptiveAppBar(
        title: context.loc.interface,
        previousPageTitle: context.loc.settings,
      ),
      body: ListView(
        padding: bodyPadding,
        children: [
          SettingsParamsContainer(
            title: context.loc.colorTheme,
            padding: EdgeInsets.zero,
            cells: [
              const ChatPreview(),
              Container(
                width: double.infinity,
                height: 110,
                margin: const EdgeInsets.symmetric(
                  vertical: 8,
                ),
                child: ListView(
                  padding: const EdgeInsets.only(right: 16, left: 8),
                  scrollDirection: Axis.horizontal,
                  children: const [
                    ThemePreview(selected: true),
                    ThemePreview(selected: false),
                    ThemePreview(selected: false),
                    ThemePreview(selected: false),
                  ],
                ),
              ),
              const CellDivider(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: SimpleColorSelector(
                  colors: BaseTheme.accents,
                  selectedColor: settingsBloc.state.interfaceColorAccent,
                  onChange: (i) => settingsBloc.add(
                    SettingsEvent.setThemeAccent(i),
                  ),
                ),
              ),
            ],
          ),
          SettingsParamsContainer(
            title: context.loc.messageBubble,
            cells: [
              SettingsParamCell(
                title: context.loc.textSize,
                child: Row(
                  children: [
                    Expanded(
                      child: AdaptiveSlider(
                        value: 16,
                        max: 30,
                        min: 12,
                        onChanged: (double value) {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text("16")
                  ],
                ),
              ),
              const CellDivider(
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
              SettingsParamCell(
                title: context.loc.cornersRounding,
                child: Row(
                  children: [
                    Expanded(
                      child: AdaptiveSlider(
                        value: 12,
                        max: 17,
                        min: 1,
                        onChanged: (double value) {},
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text("12")
                  ],
                ),
              ),
            ],
          ),
          SettingsParamsContainer(
            cells: [
              SettingsParamCell(
                title: context.loc.blurEffect,
                afterTitle: AdaptiveSwitch(
                  value: settingsBloc.state.interfaceBlurEffect,
                  onChanged: (_) {
                    settingsBloc.add(
                      const SettingsEvent.toggleInterfaceBlur(),
                    );
                  },
                ),
              ),
              const CellDivider(
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
              SettingsParamCell(
                title: context.loc.darkMode,
                afterTitle: AdaptiveSwitch(
                  value: settingsBloc.state.interfaceForceDarkMode,
                  onChanged: (_) {
                    settingsBloc.add(
                      const SettingsEvent.toggleForceDarkMode(),
                    );
                  },
                ),
              ),
              const CellDivider(
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
              SettingsParamCell(
                title: context.loc.chatBackground,
                afterTitle: const Icon(
                  CupertinoIcons.right_chevron,
                  size: 18,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

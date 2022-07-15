import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../../../widgets/adaptive_app_bar.dart';
import '../../../../widgets/adaptive_switch.dart';
import '../../../../widgets/divider.dart';
import '../../../../widgets/extended_scroll_view.dart';
import '../../settings_bloc.dart';
import '../../widgets/settings_param_cell.dart';
import '../../widgets/settings_params_container.dart';

class SettingsConnectionPage extends StatelessWidget {
  const SettingsConnectionPage({Key? key}) : super(key: key);

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
        title: context.loc.connection,
        previousPageTitle: context.loc.settings,
      ),
      body: ExtendedScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: bodyPadding,
              child: SettingsParamsContainer(
                cells: [
                  SettingsParamCell(
                    title: context.loc.useSockets,
                    afterTitle: AdaptiveSwitch(
                      value: settingsBloc.state.connectionUseSockets,
                      onChanged: (_) {
                        settingsBloc.add(
                          const SettingsEvent.toggleUseSockets(),
                        );
                      },
                    ),
                    caption: context.loc.useSocketsDesc,
                  ),
                  const CellDivider(
                    padding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  SettingsParamCell(
                    title: context.loc.keepInBackground,
                    afterTitle: AdaptiveSwitch(
                      value: settingsBloc.state.connectionKeepInBackground,
                      onChanged: (value) {
                        settingsBloc.add(
                          const SettingsEvent.toggleKeepInBackground(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../../../widgets/adaptive_app_bar.dart';
import '../../../../widgets/adaptive_switch.dart';
import '../../../../widgets/divider.dart';
import '../../settings_bloc.dart';
import '../../widgets/settings_param_cell.dart';
import '../../widgets/settings_params_container.dart';

class SettingsProfilePage extends StatelessWidget {
  const SettingsProfilePage({Key? key}) : super(key: key);

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
        title: context.loc.profile,
        previousPageTitle: context.loc.settings,
      ),
      body: ListView(
        padding: bodyPadding,
        children: [
          SettingsParamsContainer(
            title: context.loc.privacy,
            cells: [
              SettingsParamCell(
                title: context.loc.showInPeopleNearby,
                afterTitle: AdaptiveSwitch(
                  value: settingsBloc.state.privacyShowInPeopleNearby,
                  onChanged: (_) {
                    settingsBloc.add(
                      const SettingsEvent.toggleShowInPeopleNearby(),
                    );
                  },
                ),
              ),
              const CellDivider(
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
              SettingsParamCell(
                title: context.loc.closedMessages,
                afterTitle: AdaptiveSwitch(
                  value: settingsBloc.state.privacyClosedMessages,
                  onChanged: (_) {
                    settingsBloc.add(
                      const SettingsEvent.toggleClosedMessages(),
                    );
                  },
                ),
                caption: context.loc.closedMessagesDesc,
              ),
            ],
          )
        ],
      ),
    );
  }
}

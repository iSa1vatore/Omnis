import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:omnis/bloc/auth_bloc.dart';
import 'package:omnis/extensions/build_context.dart';

import '../../../../bloc/settings_bloc.dart';
import '../../../../widgets/adaptive_app_bar.dart';
import '../../../../widgets/adaptive_switch.dart';
import '../../../../widgets/avatar.dart';
import '../../../../widgets/divider.dart';
import '../../widgets/settings_param_cell.dart';
import '../../widgets/settings_params_container.dart';

class SettingsProfilePage extends HookWidget {
  const SettingsProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsBloc = context.watch<SettingsBloc>();
    var authBloc = context.watch<AuthBloc>();

    var bodyPadding = context
        .safePadding(
          left: context.platform.isIos ? 16 : 0,
          right: context.platform.isIos ? 16 : 0,
        )
        .copyWith(
          top: context.appBarHeight,
        );

    var profile = authBloc.state.maybeWhen(
      authorized: (user) => user,
      orElse: () => null,
    );

    var nameTextController = useTextEditingController()..text = profile!.name;

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
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            cells: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => settingsBloc.add(
                      const SettingsEvent.changeAvatar(),
                    ),
                    child: Stack(
                      children: [
                        Avatar(
                          width: 75,
                          height: 75,
                          source: profile.photo,
                        ),
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              color: context.theme.scaffoldBackgroundColor
                                  .withOpacity(0.6),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(IconlyBold.upload),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: TextField(
                          controller: nameTextController,
                          decoration: InputDecoration(
                            hintText: context.loc.enterYourName,
                            fillColor: context.theme.scaffoldBackgroundColor,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          SettingsParamsContainer(
            title: context.loc.privacy,
            cells: [
              SettingsParamCell(
                title: context.loc.showInPeopleNearby,
                afterTitle: AdaptiveSwitch(
                  value: settingsBloc.state.privacyShowInPeopleNearby,
                  onChanged: (_) => settingsBloc.add(
                    const SettingsEvent.toggleShowInPeopleNearby(),
                  ),
                ),
              ),
              const CellDivider(
                padding: EdgeInsets.symmetric(vertical: 8),
              ),
              SettingsParamCell(
                title: context.loc.closedMessages,
                afterTitle: AdaptiveSwitch(
                  value: settingsBloc.state.privacyClosedMessages,
                  onChanged: (_) => settingsBloc.add(
                    const SettingsEvent.toggleClosedMessages(),
                  ),
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

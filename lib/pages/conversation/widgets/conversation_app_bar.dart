import 'package:auto_route/auto_route.dart';
import 'package:collection/collection.dart';
import 'package:domain/model/message_activity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/widgets/message_activity.dart';
import 'package:omnis/widgets/widgets_switcher.dart';

import '../../../bloc/conversation_bloc.dart';
import '../../../bloc/messages_bloc.dart';
import '../../../router/router.dart';
import '../../../widgets/adaptive_app_bar.dart';
import '../../../widgets/avatar.dart';
import '../../../widgets/tap_effect.dart';

class ConversationAppBar extends StatelessWidget with PreferredSizeWidget {
  const ConversationAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ConversationBloc, ConversationState>(
      buildWhen: (previousState, state) {
        return previousState.user != state.user;
      },
      builder: (context, state) {
        var user = state.user!;

        var avatar = Avatar(
          width: 38,
          height: 38,
          source: user.photo,
        );

        return AdaptiveAppBar(
          previousPageTitle: context.loc.back,
          trailing: context.platform.isIos ? avatar : null,
          child: TouchEffect(
            borderRadius: 8,
            onTap: () {
              context.router.push(const ConversationDetailsRoute());
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: context.platform.isIos
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (context.platform.isAndroid)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: avatar,
                    ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: context.platform.isIos
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: context.theme.textTheme.subtitle2,
                        softWrap: false,
                        overflow: TextOverflow.ellipsis,
                      ),
                      BlocBuilder<MessagesBloc, MessagesState>(
                        builder: (context, state) {
                          MessageActivity? activity =
                              state.messageActivities.firstWhereOrNull(
                            (activity) => activity.peerId == user.id,
                          );

                          var hasActivity = activity != null;

                          return WidgetsSwitcher(
                            selected: hasActivity ? 1 : 0,
                            children: [
                              Text(
                                "Online",
                                style: context.theme.textTheme.caption,
                              ),
                              hasActivity
                                  ? MessageUserActivity(activity)
                                  : const SizedBox(),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

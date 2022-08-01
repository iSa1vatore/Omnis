import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/bloc/contacts_bloc.dart';
import 'package:omnis/bloc/conversation_bloc.dart';
import 'package:omnis/extensions/build_context.dart';
import 'package:omnis/router/router.dart';
import 'package:omnis/widgets/adaptive_button.dart';
import 'package:omnis/widgets/avatar.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../../widgets/adaptive_app_bar.dart';
import '../../../widgets/alert_dialog/adaptive_alert_dialog_factory.dart';
import '../../../widgets/cell.dart';

class PeopleNearbyPage extends StatelessWidget {
  const PeopleNearbyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var bodyPadding = context.safePadding().copyWith(
          top: context.appBarHeight,
        );

    var contactsBloc = context.watch<ContactsBloc>();
    var conversationBloc = context.read<ConversationBloc>();

    return BlocSideEffectListener<ContactsBloc, ContactsSideEffect>(
      listener: (BuildContext context, ContactsSideEffect sideEffect) {
        sideEffect.when(
          openMessagesPage: (user) {
            conversationBloc.add(ConversationEvent.selectConversation(user));
            context.router.push(const ConversationRoute());
          },
          showError: (error) => AdaptiveAlertDialogFactory.showError(
            context,
            failure: error,
          ),
        );
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        extendBody: true,
        appBar: AdaptiveAppBar(
          title: context.loc.peopleNearby,
          previousPageTitle: context.loc.contacts,
        ),
        body: ListView.builder(
          padding: bodyPadding,
          itemBuilder: (BuildContext context, int index) {
            var userNearby = contactsBloc.state.usersNearby[index];
            var nowConnecting = contactsBloc.state.nowConnecting;

            Widget action;

            if (nowConnecting == userNearby.globalId) {
              action = const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(strokeWidth: 3),
              );
            } else {
              action = AdaptiveButton(
                title: userNearby.isClosed!
                    ? context.loc.request
                    : context.loc.message,
                onPressed: () =>
                    contactsBloc.add(ContactsEvent.sendMessage(userNearby)),
              );
            }

            return Cell(
              avatar: Avatar(
                height: 55,
                width: 55,
                source: userNearby.photo,
              ),
              title: userNearby.name,
              caption: "Meizu 16th",
              before: action,
            );
          },
          itemCount: contactsBloc.state.usersNearby.length,
        ),
      ),
    );
  }
}

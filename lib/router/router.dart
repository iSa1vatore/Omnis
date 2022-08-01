import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:omnis/pages/auth/auth.dart';
import 'package:omnis/pages/contacts/contacts.dart';
import 'package:omnis/pages/contacts/sections/people_nearby.dart';
import 'package:omnis/pages/conversation/conversation.dart';
import 'package:omnis/pages/main/main.dart';
import 'package:omnis/pages/messages/messages.dart';
import 'package:omnis/pages/settings/settings.dart';

import '../pages/conversation_details/conversation_details.dart';
import '../pages/settings/sections/about/about.dart';
import '../pages/settings/sections/connection/connection.dart';
import '../pages/settings/sections/interface/interface.dart';
import '../pages/settings/sections/profile/profile.dart';
import '../pages/settings/sections/storage/storage.dart';

part 'router.gr.dart';

Route<T> myCustomRouteBuilder<T>(
  BuildContext context,
  Widget child,
  CustomPage<T> page,
) =>
    MaterialWithModalsPageRoute(builder: (_) => child, settings: page);

@Singleton()
@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: [
    AutoRoute(page: AuthPage, initial: true),
    AutoRoute(page: ConversationPage),
    AutoRoute(page: ConversationDetailsPage),
    AutoRoute(
      page: MainPage,
      children: [
        AutoRoute(
          page: EmptyRouterPage,
          name: "ContactsRouter",
          children: [
            AutoRoute(path: '', page: ContactsPage),
            AutoRoute(page: PeopleNearbyPage),
          ],
        ),
        AutoRoute(page: MessagesPage),
        AutoRoute(
          page: EmptyRouterPage,
          name: "SettingsRouter",
          children: [
            AutoRoute(path: '', page: SettingsPage),
            AutoRoute(page: SettingsInterfacePage),
            AutoRoute(page: SettingsConnectionPage),
            AutoRoute(page: SettingsProfilePage),
            AutoRoute(page: SettingsAboutPage),
            AutoRoute(page: SettingsStoragePage),
          ],
        ),
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {}

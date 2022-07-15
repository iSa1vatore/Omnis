import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:omnis/pages/auth/auth_bloc.dart';
import 'package:omnis/pages/contacts/contacts_bloc.dart';
import 'package:omnis/pages/main/main_bloc.dart';
import 'package:omnis/pages/settings/settings_bloc.dart';
import 'package:omnis/router/router.dart';
import 'package:omnis/theme/base_theme.dart';
import 'package:omnis/theme/dark_theme.dart';
import 'package:omnis/theme/light_theme.dart';
import 'package:omnis/utils/should_rebuild.dart';

import 'di/di.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsBloc = context.watch<SettingsBloc>();

    var accent = BaseTheme.accents[settingsBloc.state.interfaceColorAccent];

    return ShouldRebuild<AppView>(
      shouldRebuild: (oldWidget, newWidget) =>
          oldWidget.themeAccent != newWidget.themeAccent,
      child: AppView(themeAccent: accent),
    );
  }
}

class AppView extends StatelessWidget {
  final MaterialColor themeAccent;

  const AppView({
    Key? key,
    required this.themeAccent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppRouter router = DI.resolve();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        final isLoggedIn = state.when(
          authorized: () => true,
          unauthorized: () => false,
          loading: () => false,
        );

        final isLoggingIn = router.current.name == AuthRoute.name;

        if (!isLoggedIn && !isLoggingIn) {
          router.replace(const AuthRoute());
        }

        if (isLoggedIn && isLoggingIn) {
          context.read<MainBloc>().add(const MainEvent.startServer());
          context.read<ContactsBloc>().add(const ContactsEvent.init());

          router.replace(const MainRoute());
        }
      },
      child: MaterialApp.router(
        title: 'Omnis',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: lightTheme.build(context, accentColor: themeAccent),
        darkTheme: darkTheme.build(context, accentColor: themeAccent),
        debugShowCheckedModeBanner: false,
        routerDelegate: router.delegate(),
        routeInformationParser: router.defaultRouteParser(),
      ),
    );
  }
}

import 'package:domain/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:omnis/bloc/auth_bloc.dart';
import 'package:omnis/bloc/contacts_bloc.dart';
import 'package:omnis/bloc/main_bloc.dart';
import 'package:omnis/bloc/settings_bloc.dart';
import 'package:omnis/router/router.dart';
import 'package:omnis/theme/base_theme.dart';
import 'package:omnis/theme/dark_theme.dart';
import 'package:omnis/theme/light_theme.dart';

import 'di/di.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    var mainBloc = context.read<MainBloc>();

    switch (state) {
      case AppLifecycleState.paused:
        mainBloc.add(const MainEvent.updateAppLivecycleState(
          isPaused: true,
        ));
        break;
      default:
        mainBloc.add(const MainEvent.updateAppLivecycleState(
          isPaused: false,
        ));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var mainBloc = context.read<MainBloc>();

    mainBloc.add(const MainEvent.updateAppLivecycleState(
      isPaused: false,
    ));

    return const AppView();
  }
}

class AppView extends StatelessWidget {
  const AppView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppRouter router = DI.resolve();

    FlutterNativeSplash.remove();

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        User? currentUser = state.when(
          authorized: (user) => user,
          unauthorized: () => null,
          loading: () => null,
        );

        final isLoggingIn = router.current.name == AuthRoute.name;

        if (currentUser == null && !isLoggingIn) {
          router.replace(const AuthRoute());
        }

        if (currentUser != null && isLoggingIn) {
          context
              .read<MainBloc>()
              .add(MainEvent.runBackgroundService(user: currentUser));

          context.read<ContactsBloc>().add(const ContactsEvent.init());

          router.replace(const MainRoute());
        }
      },
      child: BlocBuilder<SettingsBloc, SettingsState>(
        buildWhen: (prevState, state) =>
            prevState.interfaceColorAccent != state.interfaceColorAccent ||
            prevState.interfaceForceDarkMode != state.interfaceForceDarkMode,
        builder: (context, state) {
          var accent = BaseTheme.accents[state.interfaceColorAccent];
          var forceDarkMore = state.interfaceForceDarkMode;

          return MaterialApp.router(
            title: 'Omnis',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            theme: lightTheme.build(context, accentColor: accent),
            darkTheme: darkTheme.build(context, accentColor: accent),
            themeMode: forceDarkMore ? ThemeMode.dark : ThemeMode.system,
            debugShowCheckedModeBanner: false,
            routerDelegate: router.delegate(),
            routeInformationParser: router.defaultRouteParser(),
          );
        },
      ),
    );
  }
}

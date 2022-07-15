import 'dart:async';
import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omnis/app.dart';
import 'package:omnis/bloc/bloc_observer.dart';
import 'package:omnis/pages/auth/auth_bloc.dart';
import 'package:omnis/pages/contacts/contacts_bloc.dart';
import 'package:omnis/pages/conversation/conversation_bloc.dart';
import 'package:omnis/pages/main/main_bloc.dart';
import 'package:omnis/pages/messages/messages_bloc.dart';
import 'package:omnis/pages/settings/settings_bloc.dart';
import 'package:worker_manager/worker_manager.dart';

import 'di/di.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runZonedGuarded(
    () async {
      await Future.wait([
        DI.instance.setupInjection(),
        Executor().warmUp(log: false, isolatesCount: 1),
      ]);

      if (Platform.isAndroid) {
        SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          systemStatusBarContrastEnforced: false,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
          statusBarColor: Colors.transparent,
        ));

        SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.edgeToEdge,
          overlays: [SystemUiOverlay.top],
        );
      }

      BlocOverrides.runZoned(
        () => runApp(
          MultiBlocProvider(
            providers: [
              BlocProvider<MainBloc>(
                create: (context) => DI.resolve(),
              ),
              BlocProvider<AuthBloc>(
                create: (context) => DI.resolve()
                  ..add(
                    const AuthEvent.init(),
                  ),
              ),
              BlocProvider<SettingsBloc>(
                create: (context) => DI.resolve()
                  ..add(
                    const SettingsEvent.init(),
                  ),
              ),
              BlocProvider<ContactsBloc>(
                create: (context) => DI.resolve(),
              ),
              BlocProvider<ConversationBloc>(
                create: (context) => DI.resolve(),
              ),
              BlocProvider<MessagesBloc>(
                create: (context) => DI.resolve()
                  ..add(
                    const MessagesEvent.init(),
                  ),
              ),
            ],
            child: const App(),
          ),
        ),
        blocObserver: AppBlocObserver(),
      );
    },
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}

import 'package:data/di/di.dart';
import 'package:domain/di/di.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:server/di/di.dart';
import 'package:services/di/di.dart';

import 'di.config.dart';

@InjectableInit()
class DI {
  DI._();

  final GetIt _getIt = GetIt.I;

  static final DI instance = DI._();

  Future<void> setupInjection() async {
    $initGetIt(_getIt);

    await configureDataDependencies(_getIt);
    configureServicesDependencies(_getIt);
    configureDomainDependencies(_getIt);
    configureServerDependencies(_getIt);
  }

  static T resolve<T extends Object>() => instance._getIt.get();
}

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

@InjectableInit(initializerName: r'$initServerGetIt')
Future configureServerDependencies(GetIt getIt) async =>
    $initServerGetIt(getIt);

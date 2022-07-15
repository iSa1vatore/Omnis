import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

@InjectableInit(initializerName: r'$initDataGetIt')
Future configureDataDependencies(GetIt getIt) async => $initDataGetIt(getIt);

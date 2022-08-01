import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'di.config.dart';

@InjectableInit(initializerName: r'$initDomainGetIt')
Future configureDomainDependencies(GetIt getIt) async =>
    $initDomainGetIt(getIt);

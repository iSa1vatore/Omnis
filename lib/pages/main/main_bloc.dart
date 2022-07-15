import 'package:common/utils/network_utils.dart';
import 'package:data/sources/remote/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:server/server.dart';

import '../../di/di.dart';

part 'main_bloc.freezed.dart';

@injectable
class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainState()) {
    on<StartServer>((event, emit) async {
      Server server = DI.resolve();

      try {
        await server.start(
          address: await NetworkUtils.getWifiIP(),
          port: 14080,
        );
      } catch (e) {
        print(e);
      }

      ApiService apiService = DI.resolve();
      apiService.setSender(
        address: await NetworkUtils.getWifiIP(),
        port: 14080,
      );
    });
  }
}

@freezed
class MainEvent with _$MainEvent {
  const factory MainEvent.startServer() = StartServer;
}

@freezed
class MainState with _$MainState {
  const MainState._();

  const factory MainState({
    @Default(false) bool serverIsStarted,
  }) = Initial;
}

import 'package:common/utils/encryption_utils.dart';
import 'package:common/utils/random_utils.dart';
import 'package:domain/model/user.dart';
import 'package:domain/repository/private_keys_repository.dart';
import 'package:domain/repository/users_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'auth_bloc.freezed.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UsersRepository usersRepository;
  final PrivateKeysRepository privateKeysRepository;

  AuthBloc(
    this.usersRepository,
    this.privateKeysRepository,
  ) : super(const AuthState.unauthorized()) {
    on<AuthInitEvent>((event, emit) async {
      var fetchCurrentUser = await usersRepository.me();

      fetchCurrentUser.result(
        onSuccess: (user) {
          emit(const AuthState.authorized());
        },
        onError: (message) {
          print("error");
        },
      );
    });

    on<AuthAuthEvent>((event, emit) async {
      emit(const AuthState.loading());

      var newUser = await usersRepository.create(User(
        id: 0,
        globalId: RandomUtils.generateString(16),
        name: event.name,
        photo: event.avatar,
        lastOnline: 0,
      ));

      await newUser.result(
        onSuccess: (r) async {
          if (await privateKeysRepository.fetchEncryptionPrivateKey() == null) {
            var newRSAKeypair = EncryptionUtils.rsaCreateKeypair();

            await privateKeysRepository.storeEncryptionPrivateKey(
              newRSAKeypair.privateKey.toString(),
            );
          }

          emit(const AuthState.authorized());
        },
        onError: (e) {
          print('create user error');
        },
      );
    });
  }
}

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.init() = AuthInitEvent;

  const factory AuthEvent.auth({
    required String name,
    required String avatar,
  }) = AuthAuthEvent;
}

@freezed
class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState.authorized() = _AuthAuthorizedState;

  const factory AuthState.loading() = _AuthLoadingState;

  const factory AuthState.unauthorized() = _AuthUnauthorizedState;
}

import 'package:common/utils/random_utils.dart';
import 'package:domain/model/user.dart';
import 'package:domain/model/user_connection.dart';
import 'package:domain/model/user_nearby.dart';
import 'package:domain/repository/connections_repository.dart';
import 'package:domain/repository/conversations_repository.dart';
import 'package:domain/repository/private_keys_repository.dart';
import 'package:domain/repository/users_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

part 'contacts_bloc.freezed.dart';

@injectable
class ContactsBloc
    extends SideEffectBloc<ContactsEvent, ContactsState, ContactsSideEffect> {
  final UsersRepository usersRepository;
  final ConnectionsRepository connectionsRepository;
  final PrivateKeysRepository privateKeysRepository;
  final ConversationsRepository conversationsRepository;

  ContactsBloc(
    this.usersRepository,
    this.connectionsRepository,
    this.privateKeysRepository,
    this.conversationsRepository,
  ) : super(const ContactsState()) {
    on<InitEvent>((event, emit) async {
      usersRepository.discoverUsersNearby();

      await emit.forEach<List<UserNearby>>(
        usersRepository.observeUsersNearby(),
        onData: (users) => state.copyWith(usersNearby: users),
      );
    });

    on<SendMessage>((event, emit) async {
      emit(state.copyWith(nowConnecting: event.userNearby.globalId));

      var newUser = await usersRepository.create(User(
        globalId: event.userNearby.globalId,
        photo: event.userNearby.photo,
        name: event.userNearby.name,
        id: 0,
        lastOnline: 0,
      ));

      if (newUser.data == null) {
        print("create user error");
      }

      var newUseConnection = await connectionsRepository.createConnection(
        userConnection: UserConnection(
          address: event.userNearby.address,
          token: RandomUtils.generateString(32),
          encryptionPublicKey: event.userNearby.encryptionPublicKey,
        ),
        userId: newUser.data!.id,
      );

      var result = await connectionsRepository.connectToUser(
        userConnection: newUseConnection.data!,
      );

      await result.result(
        onSuccess: (r) {
          produceSideEffect(
            ContactsSideEffect.openMessagesPage(newUser.data!),
          );
        },
        onError: (e) => {},
      );

      emit(state.copyWith(nowConnecting: null));
    });
  }
}

@freezed
class ContactsEvent with _$ContactsEvent {
  const factory ContactsEvent.init() = InitEvent;

  const factory ContactsEvent.sendMessage(UserNearby userNearby) = SendMessage;
}

@freezed
class ContactsState with _$ContactsState {
  const ContactsState._();

  const factory ContactsState({
    @Default([]) List<UserNearby> usersNearby,
    String? nowConnecting,
    @Default([]) List<User> contacts,
  }) = Initial;
}

@freezed
class ContactsSideEffect with _$ContactsSideEffect {
  const ContactsSideEffect._();

  const factory ContactsSideEffect.openMessagesPage(User user) =
      OpenMessagesPage;
}

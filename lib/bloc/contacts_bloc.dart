import 'dart:async';

import 'package:common/utils/random_utils.dart';
import 'package:domain/exceptions/failure.dart';
import 'package:domain/model/connection.dart';
import 'package:domain/model/conversation.dart';
import 'package:domain/model/user.dart';
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

      Timer.periodic(
        const Duration(seconds: 5),
        (timer) => usersRepository.discoverUsersNearby(),
      );

      await emit.forEach<List<User>>(
        usersRepository.observeUsersNearby(),
        onData: (users) => state.copyWith(usersNearby: users),
      );
    });

    on<SendMessage>((event, emit) async {
      emit(state.copyWith(nowConnecting: event.userNearby.globalId));

      var user = await usersRepository
          .findByGlobalId(
            event.userNearby.globalId,
          )
          .then((findUser) => findUser.fold((error) => null, (user) => user));

      user ??= await usersRepository
          .create(User(
            id: 0,
            globalId: event.userNearby.globalId,
            photo: event.userNearby.photo,
            name: event.userNearby.name,
            lastOnline: 0,
          ))
          .then(
            (createUser) => createUser.fold((error) => null, (user) => user),
          );

      if (user == null) return;

      var needCreateConnection = true;

      var findConnection = await connectionsRepository.findByUserId(user.id);

      //Если соединение есть - обновляем данные, если нужно
      await findConnection.fold(
        (error) {
          //Todo: показать ошибку, если проблема с базой данных
        },
        (connection) async {
          needCreateConnection = false;

          if (connection.address != event.userNearby.address) {
            await connectionsRepository.update(
              connection.copyWith(address: event.userNearby.address),
            );
          }
        },
      );

      if (needCreateConnection) {
        var newConnection = Connection(
          userId: user.id,
          token: RandomUtils.generateString(32),
          address: event.userNearby.address!,
          encryptionPublicKey: event.userNearby.encryptionPublicKey!,
        );

        var connectToUserError = await connectionsRepository
            .connectToUser(
              newConnection,
            )
            .then(
              (connectToUser) => connectToUser.fold(
                (error) => error,
                (r) => null,
              ),
            );

        if (connectToUserError != null) {
          produceSideEffect(ContactsSideEffect.showError(connectToUserError));
          emit(state.copyWith(nowConnecting: null));
          return;
        }

        var createConnectionError = await connectionsRepository
            .create(
              newConnection,
            )
            .then(
              (newConnection) => newConnection.fold(
                (error) => error,
                (r) => null,
              ),
            );

        if (createConnectionError != null) {
          produceSideEffect(
            ContactsSideEffect.showError(createConnectionError),
          );
          emit(state.copyWith(nowConnecting: null));
          return;
        }

        var createConversationError = await conversationsRepository
            .create(Conversation(
              id: user.id,
              inRead: 0,
              outRead: 0,
              lastMessageId: 0,
            ))
            .then(
              (newConversation) => newConversation.fold(
                (error) => error,
                (r) => null,
              ),
            );

        if (createConversationError != null) {
          produceSideEffect(
            ContactsSideEffect.showError(createConversationError),
          );
          emit(state.copyWith(nowConnecting: null));
          return;
        }
      }

      produceSideEffect(
        ContactsSideEffect.openMessagesPage(user),
      );

      emit(state.copyWith(nowConnecting: null));
    });
  }
}

@freezed
class ContactsEvent with _$ContactsEvent {
  const factory ContactsEvent.init() = InitEvent;

  const factory ContactsEvent.sendMessage(User userNearby) = SendMessage;
}

@freezed
class ContactsState with _$ContactsState {
  const factory ContactsState({
    @Default([]) List<User> usersNearby,
    String? nowConnecting,
    @Default([]) List<User> contacts,
  }) = Initial;
}

@freezed
class ContactsSideEffect with _$ContactsSideEffect {
  const factory ContactsSideEffect.openMessagesPage(
    User user,
  ) = OpenMessagesPage;

  const factory ContactsSideEffect.showError(Failure error) = ShowError;
}

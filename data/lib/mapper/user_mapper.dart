import 'package:domain/model/network_address.dart';
import 'package:domain/model/user.dart';
import 'package:domain/model/user_nearby.dart';

import '../sources/local/db/entity/user_entity.dart';
import '../sources/remote/dto/user_dto.dart';

extension UserEntityToUser on UserEntity {
  User toUser() {
    return User(
      id: id!,
      globalId: globalId,
      name: name,
      photo: photo,
      lastOnline: lastOnline,
    );
  }
}

extension UserToUserEntity on User {
  UserEntity toUserEntity() {
    return UserEntity(
      globalId: globalId,
      name: name,
      photo: photo,
      lastOnline: lastOnline,
    );
  }
}

extension UserToUserDto on User {
  UserDto toUserDto(String encryptionPublicKey) {
    return UserDto(
      globalId: globalId,
      name: name,
      photo: photo,
      isClosed: false,
      encryptionPublicKey: encryptionPublicKey,
    );
  }
}

extension UserDtoToUserNearby on UserDto {
  UserNearby toUserNearby(NetworkAddress address) {
    return UserNearby(
      globalId: globalId,
      name: name,
      photo: photo,
      isClosed: isClosed,
      encryptionPublicKey: encryptionPublicKey,
      address: address,
    );
  }
}

extension UserDtoToUser on UserDto {
  User toUser() {
    return User(
      id: 0,
      globalId: globalId,
      name: name,
      photo: photo,
      lastOnline: 0,
    );
  }
}

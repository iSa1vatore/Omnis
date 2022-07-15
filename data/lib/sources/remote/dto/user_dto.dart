import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_dto.freezed.dart';
part 'user_dto.g.dart';

@freezed
class UserDto with _$UserDto {
  const factory UserDto({
    @JsonKey(name: 'global_id') required String globalId,
    required String name,
    required String photo,
    @JsonKey(name: 'encryption_public_key') required String encryptionPublicKey,
    @JsonKey(name: 'is_closed') required bool isClosed,
  }) = _UserDto;

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);
}

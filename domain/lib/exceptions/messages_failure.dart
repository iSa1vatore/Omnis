import 'package:domain/exceptions/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'messages_failure.freezed.dart';

@freezed
class MessagesFailure with _$MessagesFailure implements Failure {
  const factory MessagesFailure.dbError() = _DbError;

  const factory MessagesFailure.serverError() = _ServerError;

  const factory MessagesFailure.apiError() = _ApiError;

  const factory MessagesFailure.doesNotExist() = _DoesNotExist;
}

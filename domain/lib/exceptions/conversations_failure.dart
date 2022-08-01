import 'package:domain/exceptions/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'conversations_failure.freezed.dart';

@freezed
class ConversationsFailure with _$ConversationsFailure implements Failure {
  const factory ConversationsFailure.doesNotExist() = _DoesNotExist;

  const factory ConversationsFailure.updateError() = _UpdateError;

  const factory ConversationsFailure.createError() = _CreateError;

  const factory ConversationsFailure.dbError() = _DbError;
}

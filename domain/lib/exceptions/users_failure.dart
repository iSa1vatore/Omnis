import 'package:domain/exceptions/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'users_failure.freezed.dart';

@freezed
class UsersFailure with _$UsersFailure implements Failure {
  const factory UsersFailure.doesNotExist() = _DoesNotExist;

  const factory UsersFailure.updateError() = _UpdateError;

  const factory UsersFailure.createError() = _CreateError;

  const factory UsersFailure.apiError() = _ApiError;

  const factory UsersFailure.serverError() = _ServerError;

  const factory UsersFailure.dbError() = _DbError;
}

import 'package:freezed_annotation/freezed_annotation.dart';

import 'failure.dart';

part 'connection_failure.freezed.dart';

@freezed
class UserConnectionFailure with _$UserConnectionFailure implements Failure {
  const factory UserConnectionFailure.doesNotExist() = _DoesNotExist;

  const factory UserConnectionFailure.updateError() = _UpdateError;

  const factory UserConnectionFailure.createError() = _CreateError;

  const factory UserConnectionFailure.remoteUserDidNotCreateConnection() =
      _RemoteUserDidNotCreateConnection;

  const factory UserConnectionFailure.apiError() = _ApiError;

  const factory UserConnectionFailure.serverError() = _ServerError;

  const factory UserConnectionFailure.dbError() = _DbError;
}

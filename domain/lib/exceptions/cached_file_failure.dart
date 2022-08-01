import 'package:freezed_annotation/freezed_annotation.dart';

import 'failure.dart';

part 'cached_file_failure.freezed.dart';

@freezed
class CachedFileFailure with _$CachedFileFailure implements Failure {
  const factory CachedFileFailure.doesNotExist() = _DoesNotExist;

  const factory CachedFileFailure.updateError() = _UpdateError;

  const factory CachedFileFailure.createError() = _CreateError;

  const factory CachedFileFailure.deleteError() = _DeleteError;

  const factory CachedFileFailure.dbError() = _DbError;
}

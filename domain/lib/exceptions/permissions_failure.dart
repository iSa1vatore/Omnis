import 'package:domain/exceptions/failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'permissions_failure.freezed.dart';

@freezed
class PermissionsFailure with _$PermissionsFailure implements Failure {
  const factory PermissionsFailure.isDenied() = _IsDenied;

  const factory PermissionsFailure.isPermanentlyDenied() = _IsPermanentlyDenied;
}

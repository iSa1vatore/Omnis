import 'package:domain/exceptions/connection_failure.dart';
import 'package:domain/exceptions/failure.dart';
import 'package:flutter/material.dart';
import 'package:omnis/extensions/build_context.dart';

localizeFailure(BuildContext context, Failure failure) {
  var error = failure as UserConnectionFailure;

  return error.when(
    doesNotExist: () => context.loc.userConnectionFailureDoesNotExist,
    updateError: () => context.loc.userConnectionFailureUpdateError,
    createError: () => context.loc.userConnectionFailureCreateError,
    remoteUserDidNotCreateConnection: () =>
        context.loc.userConnectionFailureRemoteUserDidNotCreateConnection,
    apiError: () => context.loc.apiError,
    serverError: () => context.loc.serverError,
    dbError: () => context.loc.dbError,
  );
}

import 'package:domain/model/api_error.dart';

class ServerErrors {
  static APIError accessDenied = APIError(
    code: 1,
    message: "access denied",
  );
  static APIError connectionError = APIError(
    code: 2,
    message: "connection error",
  );
}

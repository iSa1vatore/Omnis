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
  static APIError serverError = APIError(
    code: 3,
    message: "server error",
  );
  static APIError badRequest = APIError(
    code: 4,
    message: "bad request",
  );
}

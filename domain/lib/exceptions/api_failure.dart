import 'failure.dart';

class ApiFailure implements Failure {
  int code;
  String message;

  ApiFailure({
    required this.code,
    required this.message,
  });
}

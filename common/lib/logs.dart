import 'package:logger/logger.dart';

class Log {
  static final logger = Logger(
    filter: null,
    printer: PrettyPrinter(
      lineLength: 80,
      methodCount: 0,
      printEmojis: true,
      printTime: false,
      colors: false,
      noBoxingByDefault: true,
    ),
    output: null,
  );

  static v(dynamic message) => logger.v(message);

  static d(dynamic message) => logger.d(message);

  static i(dynamic message) => logger.i(message);

  static w(dynamic message) => logger.w(message);

  static e(dynamic message) => logger.e(message);
}

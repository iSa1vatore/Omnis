import 'package:intl/intl.dart';

class DateTimeUtils {
  static int get currentTimestamp {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }

  static String format(int timestamp, {String format = "hh:mm a"}) {
    return DateFormat(format).format(
      DateTime.fromMillisecondsSinceEpoch(
        timestamp * 1000,
      ),
    );
  }

  static String getDuration(int duration) =>
      duration < 60 ? '00:0$duration' : '${duration ~/ 60}:${duration % 60}';
}

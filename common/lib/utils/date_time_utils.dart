class DateTimeUtils {
  static int get currentTimestamp {
    return DateTime.now().millisecondsSinceEpoch ~/ 1000;
  }
}

class AudioWaveFormUtils {
  static const double _normalizationFactor = 40;
  static const double _maxDbValue = 42;

  static double normalize(double db) {
    double newDb;

    if (db == 0.0) {
      newDb = 0;
    } else if (db + _normalizationFactor < 1) {
      newDb = 0;
    } else {
      newDb = db + _normalizationFactor;
    }

    return newDb;
  }

  static List<double> resizeBy(
    double maxHeight, {
    required List<double> waveList,
  }) {
    var percents = _maxDbValue / maxHeight;

    List<double> newList = [];
    for (var waveItemValue in waveList) {
      newList.add(waveItemValue / percents);
    }

    return newList;
  }

  static List<double> compress(
    List<double> waveList, {
    required int length,
  }) {
    return waveList;
  }

  static List<double> convertToLivePreview({
    required List<double> waveList,
    required double maxHeight,
    required int maxLength,
  }) {
    var percents = _maxDbValue / maxHeight;

    List<double> newValuesList = [];
    var lastValues = waveList.reversed.take(maxLength).toList();

    for (var waveItemValue in lastValues) {
      newValuesList.add(waveItemValue / percents);
    }

    var needAdd = maxLength - newValuesList.length;

    if (needAdd != 0) {
      return [
        ...List<double>.generate(needAdd, (i) => 0).toList(),
        ...newValuesList.reversed,
      ];
    }

    return newValuesList.reversed.toList();
  }
}

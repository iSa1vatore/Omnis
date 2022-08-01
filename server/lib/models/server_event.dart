class ServerEvent {
  int type;
  dynamic data;

  ServerEvent({
    required this.type,
    required this.data,
  });

  ServerEvent.fromMap(Map<String, dynamic> map)
      : type = map["type"],
        data = map["data"];

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'data': data.toMap(),
    };
  }
}

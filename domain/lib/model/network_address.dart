class NetworkAddress {
  final int port;
  final String ip;

  NetworkAddress(this.ip, this.port);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkAddress &&
          runtimeType == other.runtimeType &&
          port == other.port &&
          ip == other.ip;

  @override
  int get hashCode => port.hashCode ^ ip.hashCode;
}

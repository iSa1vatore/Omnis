import 'package:domain/model/network_address.dart';

class Sender {
  Sender({
    required this.address,
    required this.globalUserId,
  });

  final NetworkAddress address;
  final String globalUserId;
}

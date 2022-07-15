import 'package:data/sources/local/db/entity/connection_entity.dart';
import 'package:domain/model/connection.dart';
import 'package:domain/model/network_address.dart';

extension ConnectionEntityToConnection on ConnectionEntity {
  Connection toConnection() {
    return Connection(
      id: id!,
      userId: userId,
      token: token,
      address: NetworkAddress(address, port),
      encryptionPublicKey: encryptionPublicKey,
    );
  }
}

extension ConnectionToConnectionEntity on Connection {
  ConnectionEntity toConnectionEntity() {
    return ConnectionEntity(
      userId: userId,
      token: token,
      port: address.port,
      address: address.ip,
      encryptionPublicKey: encryptionPublicKey,
    );
  }
}

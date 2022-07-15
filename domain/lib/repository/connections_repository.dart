import 'package:domain/model/connection.dart';
import 'package:domain/model/user_connection.dart';
import 'package:domain/util/resource.dart';

abstract class ConnectionsRepository {
  Future<Resource<bool>> connectToUser({
    required UserConnection userConnection,
  });

  Future<Resource<UserConnection>> createConnection({
    required UserConnection userConnection,
    required int userId,
  });

  Future<Resource<Connection>> findByUserId(int userId);

  Future<Resource<Connection>> findByAddress({
    required String ip,
    required int port,
  });
}

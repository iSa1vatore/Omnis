import 'package:dartz/dartz.dart';
import 'package:domain/model/connection.dart';

import '../exceptions/connection_failure.dart';

abstract class ConnectionsRepository {
  Future<Either<UserConnectionFailure, Unit>> connectToUser(
      Connection connection);

  Future<Either<UserConnectionFailure, Unit>> create(Connection connection);

  Future<Either<UserConnectionFailure, Connection>> findByUserId(int userId);

  Future<Connection?> findByAddress({
    required String ip,
    required int port,
  });

  Future<Either<UserConnectionFailure, Connection>> findByToken(String token);

  Future<Either<UserConnectionFailure, Unit>> update(Connection connection);
}

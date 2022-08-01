import 'package:dartz/dartz.dart';
import 'package:data/mapper/connection_mapper.dart';
import 'package:dio/dio.dart';
import 'package:domain/exceptions/api_failure.dart';
import 'package:domain/exceptions/connection_failure.dart';
import 'package:domain/model/connection.dart';
import 'package:domain/repository/connections_repository.dart';
import 'package:injectable/injectable.dart';

import '../sources/local/db/app_database.dart';
import '../sources/local/db/dao/connection_dao.dart';
import '../sources/remote/api_service.dart';

@Singleton(as: ConnectionsRepository)
class ConnectionRepositoryImpl extends ConnectionsRepository {
  final ApiService apiService;
  final AppDatabase db;

  late ConnectionDao _dao;

  ConnectionRepositoryImpl(this.db, this.apiService) {
    _dao = db.connectionDao;
  }

  @override
  Future<Either<UserConnectionFailure, Unit>> connectToUser(
    Connection connection,
  ) async {
    try {
      var result = await apiService.connectToUser(connection);

      if (result == 1) return const Right(unit);

      return const Left(
        UserConnectionFailure.remoteUserDidNotCreateConnection(),
      );
    } on DioError catch (_) {
      return const Left(UserConnectionFailure.serverError());
    } on ApiFailure catch (_) {
      return const Left(UserConnectionFailure.apiError());
    }
  }

  @override
  Future<Either<UserConnectionFailure, Unit>> create(
    Connection connection,
  ) async {
    try {
      await _dao.insertConnection(
        connection.toConnectionEntity(),
      );

      return const Right(unit);
    } catch (_) {
      return const Left(UserConnectionFailure.createError());
    }
  }

  @override
  Future<Either<UserConnectionFailure, Connection>> findByUserId(
    int userId,
  ) async {
    try {
      var connection = await _dao.findConnectionByUserId(userId);

      if (connection != null) return Right(connection.toConnection());

      return const Left(UserConnectionFailure.doesNotExist());
    } catch (_) {
      return const Left(UserConnectionFailure.dbError());
    }
  }

  @override
  Future<Either<UserConnectionFailure, Connection>> findByToken(
    String token,
  ) async {
    try {
      var connection = await _dao.findConnectionByToken(token);

      if (connection != null) Right(connection.toConnection());

      return const Left(UserConnectionFailure.doesNotExist());
    } catch (_) {
      return const Left(UserConnectionFailure.dbError());
    }
  }

  @override
  Future<Connection?> findByAddress({
    required String ip,
    required int port,
  }) async {
    var connection = await _dao.findConnectionByAddress(ip, port);

    return connection?.toConnection();
  }

  @override
  Future<Either<UserConnectionFailure, Unit>> update(
    Connection connection,
  ) async {
    try {
      var update = await _dao.updateConnection(
        connection.toConnectionEntity(),
      );

      if (update >= 0) return const Right(unit);

      return const Left(UserConnectionFailure.updateError());
    } catch (_) {
      return const Left(UserConnectionFailure.dbError());
    }
  }
}

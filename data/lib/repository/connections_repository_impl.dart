import 'package:data/mapper/connection_mapper.dart';
import 'package:data/sources/local/db/entity/connection_entity.dart';
import 'package:domain/model/connection.dart';
import 'package:domain/model/network_address.dart';
import 'package:domain/model/user_connection.dart';
import 'package:domain/repository/connections_repository.dart';
import 'package:domain/util/resource.dart';
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
  Future<Resource<bool>> connectToUser({
    required UserConnection userConnection,
  }) async {
    var result = await apiService.connectToUser(userConnection);

    if (result == 1) {
      return Resource.success(true);
    }

    return Resource.error("connect error");
  }

  @override
  Future<Resource<UserConnection>> createConnection({
    required UserConnection userConnection,
    required int userId,
  }) async {
    var oldConnection = await _dao.findConnectionByUserId(userId);

    if (oldConnection != null) {
      print("Не создали соединение");
      return Resource.success(UserConnection(
        address: NetworkAddress(oldConnection.address, oldConnection.port),
        encryptionPublicKey: oldConnection.encryptionPublicKey,
        token: oldConnection.token,
      ));
    }

    var newConnectionId = await _dao.insertConnection(ConnectionEntity(
      userId: userId,
      address: userConnection.address.ip,
      port: userConnection.address.port,
      token: userConnection.token,
      encryptionPublicKey: userConnection.encryptionPublicKey,
    ));

    var newConnection = await _dao.findConnectionById(newConnectionId);

    if (newConnection != null) {
      return Resource.success(userConnection);
    }

    return Resource.error("create new connection error");
  }

  @override
  Future<Resource<Connection>> findByUserId(int userId) async {
    var connection = await _dao.findConnectionByUserId(userId);

    if (connection != null) {
      return Resource.success(connection.toConnection());
    }

    return Resource.error("get connection error");
  }

  @override
  Future<Resource<Connection>> findByAddress({
    required String ip,
    required int port,
  }) async {
    var connection = await _dao.findConnectionByAddress(ip, port);

    if (connection != null) {
      return Resource.success(connection.toConnection());
    }

    return Resource.error("get connection error");
  }
}

import 'dart:async';

import 'package:common/utils/network_utils.dart';
import 'package:dartz/dartz.dart';
import 'package:data/sources/remote/api_service.dart';
import 'package:dio/dio.dart';
import 'package:domain/exceptions/api_failure.dart';
import 'package:domain/exceptions/users_failure.dart';
import 'package:domain/model/connection.dart';
import 'package:domain/model/public_connection.dart';
import 'package:domain/model/user.dart';
import 'package:domain/repository/users_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:worker_manager/worker_manager.dart';

import '../mapper/user_mapper.dart';
import '../sources/local/db/app_database.dart';
import '../sources/local/db/dao/user_dao.dart';

@Singleton(as: UsersRepository)
class UsersRepositoryImpl extends UsersRepository {
  final ApiService apiService;
  final AppDatabase db;

  late UserDao _dao;

  UsersRepositoryImpl(this.db, this.apiService) {
    _dao = db.userDao;
  }

  final _usersNearbyStream = BehaviorSubject<List<User>>.seeded([]);

  @override
  Stream<List<User>> observeUsersNearby() =>
      _usersNearbyStream.asBroadcastStream();

  @override
  Future<Either<UsersFailure, User>> me() async {
    try {
      var user = await _dao.findUserById(1);

      if (user != null) return Right(user.toUser());

      return const Left(UsersFailure.doesNotExist());
    } catch (_) {
      return const Left(UsersFailure.dbError());
    }
  }

  @override
  Future<Either<UsersFailure, User>> create(User user) async {
    try {
      var newUserId = await _dao.insertUser(user.toUserEntity());

      var newUser = await _dao.findUserById(newUserId);

      if (newUser != null) return right(newUser.toUser());

      return left(const UsersFailure.createError());
    } catch (_) {
      return left(const UsersFailure.dbError());
    }
  }

  @override
  Future<User?> findByID(int id) async {
    var newUser = await _dao.findUserById(id);

    return newUser?.toUser();
  }

  @override
  Future<Either<UsersFailure, User>> findByGlobalId(String globalId) async {
    try {
      var user = await _dao.findUserByGlobalId(globalId);

      if (user != null) return right(user.toUser());

      return left(const UsersFailure.doesNotExist());
    } catch (_) {
      return left(const UsersFailure.dbError());
    }
  }

  @override
  Future<List<User>> findAll() async {
    var users = await _dao.findAll();

    return users.map((e) => e.toUser()).toList();
  }

  @override
  Future<Either<UsersFailure, User>> fetchFromRemote(
    Connection connection,
  ) async {
    try {
      var user = await apiService.fetchUser(connection);

      return right(user.toUser());
    } on DioError catch (_) {
      return left(const UsersFailure.serverError());
    } on ApiFailure catch (_) {
      return left(const UsersFailure.apiError());
    }
  }

  @override
  discoverUsersNearby() async {
    String ownerIp = await NetworkUtils.getWifiIP();

    Executor()
        .execute(
      arg1: ownerIp.substring(0, ownerIp.lastIndexOf('.')),
      arg2: 14080,
      fun2: NetworkUtils.fetchDevicesNearby,
    )
        .thenNext((value) async {
      var networks = value.where(
        (network) => network.ip != ownerIp,
      );

      var addresses = networks.map((e) => e.ip).toList();
      var usersNearby = _usersNearbyStream.value
          .where(
            (user) => addresses.contains(user.address!.ip),
          )
          .toList();

      var newUsers = [];
      for (var network in networks) {
        if (usersNearby.indexWhere((u) => u.address?.ip == network.ip) == -1) {
          try {
            var userInfo = await apiService.fetchUser(PublicConnection(
              address: network,
            ));

            var userNearby = userInfo.toUser(address: network);

            newUsers.add(userNearby);
          } catch (_) {}
        }
      }

      if (newUsers.isNotEmpty) {
        _usersNearbyStream.add([
          ...newUsers,
          ...usersNearby,
        ]);
      }
    });
  }
}

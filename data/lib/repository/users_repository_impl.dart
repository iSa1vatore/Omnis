import 'dart:async';

import 'package:common/utils/network_utils.dart';
import 'package:data/sources/remote/api_service.dart';
import 'package:domain/model/user.dart';
import 'package:domain/model/user_connection.dart';
import 'package:domain/model/user_nearby.dart';
import 'package:domain/repository/users_repository.dart';
import 'package:domain/util/resource.dart';
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

  final _usersNearbyStream = BehaviorSubject<List<UserNearby>>.seeded([]);

  @override
  Stream<List<UserNearby>> observeUsersNearby() =>
      _usersNearbyStream.asBroadcastStream();

  @override
  Future<Resource<User>> me() async {
    var user = await _dao.findUserById(1);

    if (user != null) {
      return Resource.success(user.toUser());
    }

    return Resource.error("lol");
  }

  @override
  Future<Resource<User>> create(User user) async {
    var oldUser = await _dao.findUserByGlobalId(user.globalId);

    if (oldUser != null) {
      print("Не создали юзера");
      return Resource.success(oldUser.toUser());
    }

    var newUserId = await _dao.insertUser(user.toUserEntity());

    var newUser = await _dao.findUserById(newUserId);

    if (newUser != null) {
      return Resource.success(newUser.toUser());
    }

    return Resource.error("create new user error");
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

      for (var network in networks) {
        var usersNearby = [..._usersNearbyStream.value];

        if (usersNearby.indexWhere((u) => u.address.ip == network.ip) == -1) {
          var userInfo = await apiService.fetchUser(UserConnection(
            address: network,
            token: "",
            encryptionPublicKey: "",
          ));

          var userNearby = userInfo.toUserNearby(network);

          _usersNearbyStream.add([
            ...[userNearby],
            ...usersNearby
          ]);
        }
      }
    });
  }

  @override
  Future<Resource<User>> findByID(int id) async {
    var newUser = await _dao.findUserById(id);

    if (newUser != null) {
      return Resource.success(newUser.toUser());
    }

    return Resource.error("create new user error");
  }

  @override
  Future<Resource<List<User>>> findAll() async {
    var users = await _dao.findAll();

    return Resource.success(users.map((e) => e.toUser()).toList());
  }
}

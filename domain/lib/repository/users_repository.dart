import 'package:dartz/dartz.dart';
import 'package:domain/exceptions/users_failure.dart';

import '../model/connection.dart';
import '../model/user.dart';

abstract class UsersRepository {
  Future<Either<UsersFailure, User>> me();

  Future<Either<UsersFailure, User>> create(User user);

  Future<User?> findByID(int id);

  Future<Either<UsersFailure, User>> findByGlobalId(String globalId);

  Future<List<User>> findAll();

  Future<Either<UsersFailure, User>> fetchFromRemote(Connection connection);

  Stream<List<User>> observeUsersNearby();

  void discoverUsersNearby();
}

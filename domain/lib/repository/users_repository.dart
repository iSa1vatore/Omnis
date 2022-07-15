import '../model/user.dart';
import '../model/user_nearby.dart';
import '../util/resource.dart';

abstract class UsersRepository {
  Future<Resource<User>> me();

  Future<Resource<User>> create(User user);

  Future<Resource<User>> findByID(int id);

  Future<Resource<List<User>>> findAll();

  Stream<List<UserNearby>> observeUsersNearby();

  void discoverUsersNearby();
}

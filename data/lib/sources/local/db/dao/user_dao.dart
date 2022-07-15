import 'package:floor/floor.dart';

import '../entity/user_entity.dart';

@dao
abstract class UserDao {
  @Query("SELECT * FROM Users WHERE id = :id")
  Future<UserEntity?> findUserById(int id);

  @Query("SELECT * FROM Users")
  Future<List<UserEntity>> findAll();

  @Query("SELECT * FROM Users WHERE globalId = :globalId")
  Future<UserEntity?> findUserByGlobalId(String globalId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertUser(UserEntity userEntity);
}

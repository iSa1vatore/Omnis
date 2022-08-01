import 'package:data/sources/local/db/entity/connection_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ConnectionDao {
  @Query("SELECT * FROM Connections WHERE token = :token")
  Future<ConnectionEntity?> findConnectionByToken(String token);

  @Query("SELECT * FROM Connections WHERE userId = :userId")
  Future<ConnectionEntity?> findConnectionByUserId(int userId);

  @Query("SELECT * FROM Connections WHERE address = :ip AND port = :port")
  Future<ConnectionEntity?> findConnectionByAddress(String ip, int port);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertConnection(ConnectionEntity connectionEntity);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateConnection(ConnectionEntity connectionEntity);
}

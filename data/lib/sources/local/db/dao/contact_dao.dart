import 'package:data/sources/local/db/entity/contact_entity.dart';
import 'package:floor/floor.dart';

@dao
abstract class ContactsDao {
  @Query("SELECT * FROM Contacts")
  Future<List<ContactEntity>> findAll();

  @Query("SELECT * FROM Contacts WHERE user_id = :id")
  Future<ContactEntity?> findById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertContact(ContactEntity contactEntity);

  @delete
  Future<int> deleteContact(ContactEntity contactEntity);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateContact(ContactEntity contactEntity);
}

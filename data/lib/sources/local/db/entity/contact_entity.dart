import 'package:floor/floor.dart';

@Entity(tableName: "Contacts")
class ContactEntity {
  @primaryKey
  @ColumnInfo(name: 'user_id')
  final int userId;
  final String name;

  ContactEntity({
    required this.userId,
    required this.name,
  });
}

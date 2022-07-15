import 'package:floor/floor.dart';

@Entity(tableName: "Users")
class UserEntity {
  @primaryKey
  final int? id;
  final String globalId;
  final String name;
  final String photo;
  final int lastOnline;

  UserEntity({
    this.id,
    required this.globalId,
    required this.name,
    required this.photo,
    required this.lastOnline,
  });
}

import 'package:data/sources/local/db/entity/contact_entity.dart';
import 'package:domain/model/contact.dart';

extension ContactEntityToContact on ContactEntity {
  Contact toContact() => Contact(userId: userId, name: name);
}

extension ContactToContactEntity on Contact {
  ContactEntity toContactEntity() => ContactEntity(userId: userId, name: name);
}

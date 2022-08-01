import '../model/contact.dart';

abstract class ContactsRepository {
  Future<Contact> add(Contact contact);

  Future<List<Contact>> findAll();

  Future<Contact?> findById(int id);

  Future<bool> delete(Contact contact);

  Future<bool> update(Contact contact);
}

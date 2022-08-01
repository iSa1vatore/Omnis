import 'package:data/mapper/contact_mapper.dart';
import 'package:data/sources/local/db/dao/contact_dao.dart';
import 'package:domain/model/contact.dart';
import 'package:domain/repository/contacts_repository.dart';
import 'package:injectable/injectable.dart';

import '../sources/local/db/app_database.dart';

@Singleton(as: ContactsRepository)
class ContactsRepositoryImpl extends ContactsRepository {
  final AppDatabase db;

  late ContactsDao _dao;

  ContactsRepositoryImpl(this.db) {
    _dao = db.contactsDao;
  }

  @override
  Future<bool> delete(Contact contact) async {
    var delete = await _dao.deleteContact(contact.toContactEntity());

    return delete == 1;
  }

  @override
  Future<List<Contact>> findAll() async {
    var contacts = await _dao.findAll();

    return contacts.map((c) => c.toContact()).toList();
  }

  @override
  Future<Contact?> findById(int id) async {
    var contact = await _dao.findById(id);

    return contact?.toContact();
  }

  @override
  Future<bool> update(Contact contact) async {
    var update = await _dao.updateContact(contact.toContactEntity());

    return update == 1;
  }

  @override
  Future<Contact> add(Contact contact) async {
    await _dao.insertContact(contact.toContactEntity());

    return contact;
  }
}

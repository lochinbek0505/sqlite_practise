import 'package:flutter/material.dart';

import 'DBHelper.dart';
import 'contact_model.dart';

class ContactProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();

  List<ContactModel> _contacts = []; // Kontaktlar ro‘yxati

  get contacts => _contacts;

  loadContacts() async {
    var con =
        await dbHelper
            .getContacts(); // SQLite'dan barcha kontaktlarni olib keladi
    _contacts = con.map((e) => ContactModel.fromMap(e)).toList();
    notifyListeners();
  }

  addContact(ContactModel contact) async {

    await dbHelper.insertContact(contact); // Kontakt qo‘shish
    await loadContacts();
    notifyListeners();
  }

  updateContact(ContactModel contact) async {
    await dbHelper.updateUser(contact); // Kontaktni tahrirlash
    await loadContacts();

    notifyListeners();
  }

  deleteContact(int id) async {
    await dbHelper.deleteUser(id); // Kontaktni o‘chirish
    await loadContacts();

    notifyListeners();
  }
}

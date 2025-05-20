import 'package:flutter/material.dart';
import 'package:sqlite/DBHelper.dart';
import 'contact_model.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  // Kontaktlar ro‘yxatini saqlovchi list
  List<ContactModel> contactsList = [];

  // SQLite DBHelper instansiyasi
  DBHelper dbHelper = DBHelper();

  // Ma'lumotlar bazasidan kontaktlarni olish funksiyasi
  Future<void> getContacts() async {
    var con = await dbHelper.getContacts(); // SQLite'dan barcha kontaktlarni olib keladi
    contactsList = con.map((e) => ContactModel.fromMap(e)).toList(); // Olingan ma'lumotlarni modelga aylantiradi
    setState(() {}); // UI yangilanadi
  }

  @override
  void initState() {
    super.initState();
    getContacts(); // Ilova yuklanganda kontaktlar bazadan olinadi
  }

  /// Kontakt qo‘shish yoki tahrirlash uchun dialog
  /// [check] - true bo‘lsa tahrirlash, false bo‘lsa qo‘shish
  /// [contact] - tahrir qilinayotgan kontakt
  /// [index] - kontakt indexi (hozircha ishlatilmayapti)
  void _showAddContactDialog(check, {ContactModel? contact, int? index}) {
    // TextField uchun controllerlar (tahrirlashda mavjud qiymat bilan to‘ldiriladi)
    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneController = TextEditingController(text: contact?.phone ?? '');

    // Dialog ochiladi
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        title: Text(!check ? 'Yangi kontakt' : 'Kontaktni tahrirlash'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ism kiritish maydoni
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Ism'),
            ),
            const SizedBox(height: 10),
            // Telefon raqami kiritish maydoni
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Telefon raqam'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          // Bekor qilish tugmasi
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Bekor qilish'),
          ),
          // Saqlash yoki Tahrirlash tugmasi
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();

              // Ikkala maydon ham to‘ldirilgan bo‘lsa
              if (name.isNotEmpty && phone.isNotEmpty) {
                var model = ContactModel(id: contact?.id, name: name, phone: phone);

                if (check) {
                  // Kontaktni yangilash
                  DBHelper.instance.updateUser(model);
                } else {
                  // Yangi kontakt qo‘shish
                  DBHelper.instance.insertContact(model);
                }

                getContacts(); // Kontaktlar ro‘yxatini yangilash
                setState(() {}); // UI yangilash
                Navigator.pop(context); // Dialogni yopish
              }
            },
            child: Text(check ? 'Tahrirlash' : 'Saqlash'),
          ),
        ],
      ),
    );
  }

  /// Kontaktni o‘chirish funksiyasi
  void _deleteContact(int index) {
    // Ma'lumotlar bazasidan kontaktni o‘chirish
    dbHelper.deleteUser(contactsList[index].id!);
    getContacts(); // Ro‘yxatni qaytadan yuklash
    setState(() {}); // UI yangilash
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontaktlar'),
        centerTitle: true,
      ),

      // Agar kontaktlar yo‘q bo‘lsa markazda matn ko‘rsatiladi
      body: contactsList.isEmpty
          ? const Center(child: Text('Kontaktlar yo‘q'))
          : ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: contactsList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, index) {
          final contact = contactsList[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.person)), // Kontakt ikonkasi
              title: Text(contact.name ?? ''), // Ism
              subtitle: Text(contact.phone ?? ''), // Telefon
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Tahrirlash tugmasi
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showAddContactDialog(
                      true,
                      contact: contact,
                      index: index,
                    ),
                  ),
                  // O‘chirish tugmasi
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteContact(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      // Yangi kontakt qo‘shish tugmasi
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactDialog(false),
        child: const Icon(Icons.add),
      ),
    );
  }
}

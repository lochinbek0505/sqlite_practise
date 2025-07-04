import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite/ContactProvider.dart';
import 'package:sqlite/DBHelper.dart';
import 'contact_model.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {



  @override
  void initState() {
    super.initState();
    Provider.of<ContactProvider>(context,listen: false).loadContacts();
  }

  void _showAddContactDialog(check, {ContactModel? contact, int? index}) {

    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneController = TextEditingController(text: contact?.phone ?? '');

    showDialog(
      context: context,
      builder: (_) => Consumer<ContactProvider>(
        builder: (context, provider,_) {
          return AlertDialog(
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
                TextField(
                  controller: phoneController,
                  decoration: const InputDecoration(labelText: 'Telefon raqam'),
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Bekor qilish'),
              ),
              ElevatedButton(
                onPressed: () {
                  final name = nameController.text.trim();
                  final phone = phoneController.text.trim();

                  if (name.isNotEmpty && phone.isNotEmpty) {
                    var model = ContactModel(id: contact?.id, name: name, phone: phone);

                    if (check) {
                      provider.updateContact(model);
                    } else {
                      provider.addContact(model);
                    }

                    setState(() {}); // UI yangilash
                    Navigator.pop(context); // Dialogni yopish
                  }
                },
                child: Text(check ? 'Tahrirlash' : 'Saqlash'),
              ),
            ],
          );
        }
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kontaktlar'),
        centerTitle: true,
      ),

      // Agar kontaktlar yo‘q bo‘lsa markazda matn ko‘rsatiladi
      body: Consumer<ContactProvider>(
        builder: (context, provider,_) {

            final contacts = provider.contacts??[];
            print(contacts);
            print(contacts.length);
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: contacts.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final contact = contacts[index];

                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    // Kontakt ikonkasi
                    title: Text(contact.name ?? ''),
                    // Ism
                    subtitle: Text(contact.phone ?? ''),
                    // Telefon
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Tahrirlash tugmasi
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _showAddContactDialog(
                                true,
                                contact: contact,
                                index: index,
                              ),
                        ),
                        // O‘chirish tugmasi
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => provider.deleteContact(contact.id ?? 0),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

      ),

      // Yangi kontakt qo‘shish tugmasi
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactDialog(false),
        child: const Icon(Icons.add),
      ),
    );
  }
}

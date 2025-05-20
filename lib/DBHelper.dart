import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'contact_model.dart';

class DBHelper {
  // Singleton instance yaratish
  static final DBHelper instance = DBHelper._internal();
  static Database? _db;

  // Ichki konstruktor (private constructor)
  DBHelper._internal();

  // Singleton uchun factory konstruktor
  factory DBHelper() => instance;

  // Ma'lumotlar bazasi obyektini olish (agar mavjud bo'lmasa, yaratadi)
  Future<Database> get db async {
    _db ??= await initDb();
    return _db!;
  }

  // Ma'lumotlar bazasini boshlang'ich holatda yaratish funksiyasi
  Future<Database> initDb() async {
    // Qurilmadagi ma'lumotlar bazasi saqlanadigan papkani olish
    String dbPath = await getDatabasesPath();
    print(dbPath);

    // To'liq path (yo'l) ni yaratish
    String path = join(dbPath, 'contacts.db');

    // Bazani ochish va agar mavjud bo'lmasa, yaratish
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  // Ma'lumotlar bazasida jadvalni yaratish funksiyasi
  Future _createDb(Database db, int version) async {
    await db.execute(
      "CREATE TABLE contacts(id INTEGER PRIMARY KEY, name TEXT, phone TEXT)",
    );
  }

  // Yangi kontaktni bazaga qo'shish funksiyasi
  Future<int> insertContact(ContactModel contact) async {
    final db = await this.db;
    return await db.insert("contacts", contact.toMap());
  }

  // Barcha kontaktlarni olish funksiyasi
  Future<List<Map<String, dynamic>>> getContacts() async {
    final db = await this.db;
    return await db.query("contacts");
  }

  // Mavjud kontaktni yangilash funksiyasi
  Future<int> updateUser(ContactModel user) async {
    final db = await this.db;
    return await db.update(
      'contacts',
      user.toMap(),
      where: 'id = ?', // Qaysi kontaktni yangilash kerakligini aniqlash
      whereArgs: [user.id],
    );
  }

  // Kontaktni o'chirish funksiyasi
  Future<int> deleteUser(int id) async {
    final db = await this.db;
    return await db.delete(
      'contacts',
      where: 'id = ?', // Qaysi ID asosida o'chirish kerakligini ko'rsatish
      whereArgs: [id],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sqlite/DBHelper.dart'; // Ma'lumotlar bazasi bilan ishlovchi klassni import qilamiz
import 'ContactsPage.dart'; // Kontaktlar sahifasini import qilamiz

// Ilovani ishga tushurishdan oldin async funksiyani chaqirish
void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Flutter ilovasining barcha bindinglarini ishga tushurish (asosan async ishlovlar uchun kerak)
  await DBHelper.instance.initDb(); // Ma'lumotlar bazasini boshlang‘ich holatga keltirish
  runApp(const MyApp()); // Ilovani ishga tushurish
}

// Ilovaning asosiy (root) widgeti
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo', // Ilova sarlavhasi (Android task managerda ko‘rinadi)
      theme: ThemeData(
        // Ilovaning umumiy mavzusi (Theme)
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), // Rangi sxemasi (asosiy rang sifatida deepPurple)
      ),
      home: ContactsPage(), // Ilovani ochganda birinchi ochiladigan sahifa
    );
  }
}

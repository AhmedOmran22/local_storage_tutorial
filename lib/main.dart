import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'databases/prefs_service.dart';
import 'databases/secure_storage_service.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await PrefsService.init();
  SecureStorageService.initSecureStorage();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "Local Database tutorial",
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

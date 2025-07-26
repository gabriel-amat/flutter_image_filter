import 'package:flutter/material.dart';
import 'package:flutter_image_filter/core/dataBase/local_db_objectbox.dart';
import 'package:flutter_image_filter/core/setup_dependencies.dart';
import 'presentation/pages/home_page.dart';

late LocalDataBaseObjectBox localDataBase;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  localDataBase = await LocalDataBaseObjectBox.create();

  setupDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

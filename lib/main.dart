import 'package:api_542_task/data/database_repository.dart';
import 'package:api_542_task/data/shared_preferences_repository.dart';
import 'package:api_542_task/my_app.dart';
import 'package:flutter/material.dart';

void main() {
  final DatabaseRepository localDB = SharedPreferencesRepository();

  runApp(MainApp(localDB));
}

class MainApp extends StatelessWidget {
  final DatabaseRepository localDB;

  const MainApp(
    this.localDB, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MyApp(localDB);
  }
}

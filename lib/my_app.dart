import 'package:api_542_task/data/database_repository.dart';
import 'package:api_542_task/home_screen.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  final DatabaseRepository localDB;

  const MyApp(
    this.localDB, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark().copyWith(
        primaryColor: Colors.lightGreen,
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 40, 69, 6),
          foregroundColor: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.black,
      ),
      themeMode: ThemeData.dark().brightness == Brightness.dark
          ? ThemeMode.dark
          : ThemeMode.light,
      debugShowCheckedModeBanner: false,
      home: HomeScreen(localDB),
    );
  }
}

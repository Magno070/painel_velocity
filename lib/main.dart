import 'package:flutter/material.dart';
import 'package:velocity_admin_painel/screens/login_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[850],
        cardColor: Colors.grey[800],
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Color.fromARGB(255, 217, 205, 205)),
        ),
      ),
      home: LoginPage(),
    );
  }
}

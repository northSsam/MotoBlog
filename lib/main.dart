import 'package:flutter/material.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const MotoBlogApp());
}

class MotoBlogApp extends StatelessWidget {
  const MotoBlogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MotoBlog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
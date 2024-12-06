import 'package:flutter/material.dart';
import 'login.dart';
import 'mylib.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.myTheme,
      title: "Stronger",
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),);
  }
}

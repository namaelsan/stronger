import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/workouts.dart';
import 'login.dart';
import 'mylib.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => WorkoutProvider(), // Provide the WorkoutProvider
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.myTheme,
      title: "Stronger",
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}


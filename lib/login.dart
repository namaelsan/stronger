import 'package:flutter/material.dart';
import 'mylib.dart';

class LoginPage extends StatefulWidget{
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    var screenSize = ReusableWidgets.screensize(context);

    return MaterialApp(
      title: "Stronger",
      color: AppTheme.colorLight1,
      theme: ,
    );

  }

}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme{
  static var colorDark1 = const Color(0xFF000B58);
  static var colorDark2 = const Color(0xFF003161);
  static var colorLight2 = const Color(0xFF006A67);
  static var colorLight1 = const Color(0xFFFFF4B7);

  final ThemeData myTheme = ThemeData(
    colorScheme: ,
    primarySwatch: Colors.blue,
    backgroundColor: Colors.white,
    accentColor: Colors.green,
    buttonColor: Colors.blue,
    textTheme: TextTheme(
      headline6: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      bodyText2: TextStyle(fontSize: 16.0),
    ),
  );
}

class ReusableWidgets {

  static screensize(BuildContext context){
    return MediaQuery.of(context).size;
  }

  static AppBar myAppBar({String? title}){
    return AppBar(
      title: Text(title ?? ""),
      centerTitle: true,
      backgroundColor: AppTheme.colorDark1,
    );
  }

  static ElevatedButton myElevatedButton(String text,{VoidCallback? onPressed}){
    return ElevatedButton(
      onPressed: onPressed ?? (){},
      style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.colorLight2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          )
      ),
      child: Text(text,textAlign: TextAlign.center,style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),);
  }

  static TextInputFormatter customNumberAndCommaLimiter() {
    return TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text;

      // Allow only numbers and a single comma
      if (RegExp(r'^[0-9]*.?[0-9]*$').hasMatch(text)) {
        // Ensure only one comma is present
        if (text.split('.').length <= 2) {
          return newValue;
        }
      }

      return oldValue; // Reject the new input if it doesn't match
    });
  }
}
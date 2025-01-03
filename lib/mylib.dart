import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stronger/Programs/programs.dart';

class AppTheme{
  AppTheme._();

  static var colorDark1 = const Color(0xFF001F3F);
  static var colorDark2 = const Color(0xFF3A6D8C);
  static var colorLight2 = const Color(0xFF6A9AB0);
  static var colorLight1 = const Color(0xFFEAD8B1);

  static final ThemeData myTheme = ThemeData(
    useMaterial3: true,
    primaryColor: colorDark1,
    brightness: Brightness.light,
    scaffoldBackgroundColor: colorDark2,
    textTheme: _TextTheme.myTextTheme,
    appBarTheme: _AppBarTheme.myAppBarTheme,
    elevatedButtonTheme: _ElevatedButtonThemeData.myElevatedButtonTheme,
    inputDecorationTheme: _InputDecorationTheme.myInputDecorationTheme,
    bottomNavigationBarTheme: _BottomNavigationBarThemeData.myBottomNavigationBarThemeData,
    cardTheme: _CardTheme.myCardTheme,
    floatingActionButtonTheme: _FloatingActionButtonTheme.myFloatingActionButtonThemeData,
  );
}

class AppGlobals {
  static List<Program> pastWorkouts = []; // Global list to store past workouts
}

class ReusableWidgets {

  ReusableWidgets._();

  static screensize(BuildContext context){
    return MediaQuery.of(context).size;
  }

  static AppBar myAppBar({String? title}){
    return AppBar(
      title: Text(title ?? ""),
      centerTitle: true,
      backgroundColor: AppTheme.colorLight1,
    );
  }

  static ElevatedButton myElevatedButton(String text,{VoidCallback? onPressed}){
    return ElevatedButton(
      onPressed: onPressed ?? (){},
      style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.colorDark1,
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

  static Container myBackgroundGradient(Widget child){
    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.colorDark2.withOpacity(0.4), AppTheme.colorLight2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: child
    );
  }
}



class _AppBarTheme{
  static AppBarTheme myAppBarTheme = AppBarTheme(
    centerTitle: true,
    backgroundColor: AppTheme.colorDark1,
    iconTheme: IconThemeData(
      color: Colors.white
    ),
  );
}

class _ElevatedButtonThemeData{
  static ElevatedButtonThemeData myElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppTheme.colorDark1,
      disabledBackgroundColor: Colors.grey,
      disabledForegroundColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),
    )
  ));
}


class _TextTheme{
  _TextTheme._();

  static TextTheme myTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize:  32, fontWeight: FontWeight.bold, color: Colors.white.withOpacity(0.9)),
    headlineMedium: const TextStyle().copyWith(fontSize:  24, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9)),
    headlineSmall: const TextStyle().copyWith(fontSize:  18, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9)),

    titleLarge: const TextStyle().copyWith(fontSize:  16, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9)),
    titleMedium: const TextStyle().copyWith(fontSize:  16, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.9)),
    titleSmall: const TextStyle().copyWith(fontSize:  16, fontWeight: FontWeight.w400, color: Colors.white.withOpacity(0.9)),

    bodyLarge: const TextStyle().copyWith(fontSize:  14, fontWeight: FontWeight.w500, color: Colors.black,),
    bodyMedium: const TextStyle().copyWith(fontSize:  14, fontWeight: FontWeight.normal, color: Colors.black),
    bodySmall: const TextStyle().copyWith(fontSize:  14, fontWeight: FontWeight.w500, color: Colors.black),

    labelLarge: const TextStyle().copyWith(fontSize:  12, fontWeight: FontWeight.normal, color: Colors.white.withOpacity(0.9)),
    labelMedium: const TextStyle().copyWith(fontSize:  12, fontWeight: FontWeight.normal, color: Colors.white.withOpacity(0.9)),
    labelSmall: const TextStyle().copyWith(fontSize:  12, fontWeight: FontWeight.normal, color: Colors.white.withOpacity(0.9)),
  );
}

class _InputDecorationTheme{
  _InputDecorationTheme._();

  static InputDecorationTheme myInputDecorationTheme = InputDecorationTheme(
      border: OutlineInputBorder());
}

class _BottomNavigationBarThemeData{
  _BottomNavigationBarThemeData._();

  static BottomNavigationBarThemeData myBottomNavigationBarThemeData = BottomNavigationBarThemeData(
    backgroundColor: AppTheme.colorDark1,
    selectedItemColor: Colors.white.withOpacity(0.9), // Set your desired selected item color
    unselectedItemColor: Colors.grey,
  );
}

class _CardTheme{
  _CardTheme._();

  static CardTheme myCardTheme = CardTheme(
    color: AppTheme.colorLight2
  );
}

class _FloatingActionButtonTheme{
  _FloatingActionButtonTheme._();

  static FloatingActionButtonThemeData myFloatingActionButtonThemeData = FloatingActionButtonThemeData(
    backgroundColor: AppTheme.colorDark1,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  );
}
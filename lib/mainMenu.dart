import 'package:flutter/material.dart';
import 'mylib.dart';
import 'stats.dart';
import 'programs.dart';
import 'settings.dart';

class MainMenu extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MainMenuState();
  }
}

class _MainMenuState extends State<MainMenu>{

  int _currentIndex = 0;

  final List<Widget> _pages = [
    ProgramsPage(),
    StatsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("Stronger",style: Theme.of(context).textTheme.headlineMedium,)),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index){
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "Programs"),
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "Graphs"),
            BottomNavigationBarItem(icon: Icon(Icons.home),label: "Settings"),

          ],
      ),
    );
  }

}
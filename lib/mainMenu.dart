import 'package:flutter/material.dart';
import 'stats.dart';
import 'Programs/programs.dart';
import 'settings.dart';
import 'workouts.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MainMenuState();
  }
}

class _MainMenuState extends State<MainMenu> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ProgramsPage(),
    WorkoutsPage(),
    // StatsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stronger",style: Theme.of(context).textTheme.headlineMedium,)),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.fitness_center), label: "Programs"),
          BottomNavigationBarItem(icon: Icon(Icons.access_time), label: "Workouts"),
          // BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Graphs"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}
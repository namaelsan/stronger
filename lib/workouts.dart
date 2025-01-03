import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:stronger/Programs/programs.dart';
import 'mylib.dart';

class WorkoutsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: ReusableWidgets.myBackgroundGradient(
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: screenSize.height * 0.035),
              // Page Title
              Center(
                child: Stack(
                  children: [
                    Text(
                      "Past Workouts",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 7
                          ..color = AppTheme.colorDark1,
                      ),
                    ),
                    Text(
                      "Past Workouts",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Add some spacing
              // Use Expanded to allow ListView to take up remaining space
              Expanded(
                child: ListView.builder(
                  itemCount: workoutProvider.pastWorkouts.length,
                  itemBuilder: (context, index) {
                    final workout = workoutProvider.pastWorkouts[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(workout.title),
                        subtitle: Text(
                          "${workout.getExerciseAmount()} Movements · ${workout.getSetAmount()} Sets · ${_formatTimer(workout.time ?? 0)} Seconds",
                        ),
                        onTap: () {
                          // Navigate to a detailed view of the workout if needed
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WorkoutProvider with ChangeNotifier {
  List<Program> _pastWorkouts = [];
  String? _currentUser;

  List<Program> get pastWorkouts => _pastWorkouts;

  WorkoutProvider() {
    _loadCurrentUser();
  }

  // Load the current user from SharedPreferences
  Future<void> _loadCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentUser = prefs.getString('currentUser');
    if (_currentUser != null) {
      await _loadPastWorkouts(); // Load past workouts for the current user
    }
  }

  // Load past workouts from a JSON file
  Future<void> _loadPastWorkouts() async {
    if (_currentUser == null) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${_currentUser}/pastWorkouts.json');

      if (await file.exists()) {
        final contents = await file.readAsString();
        List<dynamic> workoutsList = jsonDecode(contents);
        _pastWorkouts = workoutsList
            .map((workout) => Program.fromJson(workout))
            .toList();
        notifyListeners();
        print("Loaded past workouts for user: $_currentUser");
      } else {
        print("No past workouts file found for user: $_currentUser");
      }
    } catch (e) {
      print("Error loading past workouts: $e");
    }
  }

  // Save past workouts to a JSON file
  Future<void> _savePastWorkouts() async {
    if (_currentUser == null) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${_currentUser}/pastWorkouts.json');

      String workoutsJson = jsonEncode(_pastWorkouts.map((w) => w.toJson()).toList());
      await file.writeAsString(workoutsJson);
      print("Saved past workouts for user: $_currentUser");
    } catch (e) {
      print("Error saving past workouts: $e");
    }
  }

  // Add a workout to the past workouts list
  void addWorkout(Program workout) {
    _pastWorkouts.add(workout);
    notifyListeners(); // Notify listeners to rebuild dependent widgets
    _savePastWorkouts(); // Save the updated list
  }
}

// Format the timer (HH:MM:SS)
String _formatTimer(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int secs = seconds % 60;
  return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
}
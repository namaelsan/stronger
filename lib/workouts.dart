import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stronger/Programs/programs.dart';
import 'mylib.dart';

class WorkoutsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final workoutProvider = Provider.of<WorkoutProvider>(context);
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                        "${workout.getExerciseAmount()} Movements · ${workout.getSetAmount()} Sets",
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
    );
  }
}

class WorkoutProvider with ChangeNotifier {
  List<Program> _pastWorkouts = [];

  List<Program> get pastWorkouts => _pastWorkouts;

  void addWorkout(Program workout) {
    _pastWorkouts.add(workout);
    notifyListeners(); // Notify listeners to rebuild dependent widgets
  }
}
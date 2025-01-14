import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stronger/Programs/startWorkout.dart';
import '../mylib.dart';
import 'createPrograms.dart';

class ProgramsPage extends StatefulWidget {
  const ProgramsPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ProgramsPageState();
  }
}

class _ProgramsPageState extends State<ProgramsPage> {
  List<Program> userPrograms = [];
  List<Program> templatePrograms = [
    Program("Beginner program",
        description: "Start your fitness journey",
        exercises: [
          Exercise("Chest Press", sets: [
            Set(15, "Warmup"),
            Set(5, "Drop"),
          ]),
        ]),
    Program("Strength Focus",
        description: "Build power and strength",
        exercises: [
          Exercise("Chest Press", sets: [
            Set(15, "Warmup"),
            Set(5, "Drop"),
          ]),
        ]),
    Program("Hypertrophy Program",
        description: "For muscle growth",
        exercises: [
          Exercise("Squat", sets: [Set(15, "Warmup")])
        ])
  ];

  String? _currentUser; // Track the current user

  @override
  void initState() {
    super.initState();
    _loadCurrentUser(); // Load the current user and their programs
  }

  // Load the current user from SharedPreferences
  Future<void> _loadCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currentUser = prefs.getString('currentUser'); // Get the current user
    });
    if (_currentUser != null) {
      await _loadUserPrograms(); // Load programs for the current user
    }
  }

  // Load user programs from a JSON file
  Future<void> _loadUserPrograms() async {
    if (_currentUser == null) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/$_currentUser/userPrograms.json');

      if (await file.exists()) {
        final contents = await file.readAsString();
        List<dynamic> programsList = jsonDecode(contents);
        setState(() {
          userPrograms =
              programsList.map((program) => Program.fromJson(program)).toList();
        });
      }
    } catch (e) {
      print("Error loading user programs: $e");
    }
  }

  // Save user programs to a JSON file
  Future<void> _saveUserPrograms() async {
    if (_currentUser == null) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      Directory('${directory.path}/$_currentUser')
          .create(); // create parent folder
      final file = File('${directory.path}/$_currentUser/userPrograms.json');

      String programsJson =
          jsonEncode(userPrograms.map((p) => p.toJson()).toList());
      await file.writeAsString(programsJson);
    } catch (e) {}
  }

  void navigateToCreateProgram(List<Program> programs, int index,
      {required bool isNew}) async {
    var updatedProgram = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateProgramsPage(
          programs: programs,
          index: index,
          isNew: isNew,
        ),
      ),
    );

    if (updatedProgram == null) {
      return;
    }
    setState(() {
      if (isNew) {
        userPrograms.add(updatedProgram.copy());
      } else {
        userPrograms[index] = updatedProgram; // Update the program list
      }
      _saveUserPrograms(); // Save the updated list
    });
  }

  void navigateToStartWorkout(
    List<Program> programs,
    int index,
  ) async {
    var updatedProgram = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StartWorkout(
          program: programs[index],
        ),
      ),
    );

    if (updatedProgram == null) {
      return;
    }
    setState(() {
      programs[index] = updatedProgram.copy(); // Update the program list
      _saveUserPrograms(); // Save the updated list
    });
  }

  void _showDeleteDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Program",
              style: AppTheme.myTheme.textTheme.headlineSmall
                  ?.copyWith(color: Colors.black)),
          content: Text(
              "Are you sure you want to remove this program from your list?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text("Remove"),
              onPressed: () {
                setState(() {
                  userPrograms.removeAt(index); // Remove the program
                  _saveUserPrograms(); // Save the updated list
                });
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToCreateProgram(userPrograms, -1, isNew: true);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ReusableWidgets.myBackgroundGradient(
        ListView(
          padding: EdgeInsets.all(16),
          children: [
            SizedBox(height: screenSize.height * 0.035),
            // Page Title
            Center(
              child: Stack(
                children: [
                  Text(
                    "Your Programs",
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 7
                            ..color = AppTheme.colorDark1,
                        ),
                  ),
                  Text(
                    "Your Programs",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Template Programs Section
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(7, 2, 7, 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Templates",
                          style: AppTheme.myTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'YourCustomFont',
                            color: AppTheme.colorDark1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
            SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: templatePrograms.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      navigateToCreateProgram(templatePrograms, index,
                          isNew: true);
                    },
                    child: Card(
                      elevation: 10,
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(
                        width: screenSize.width * 0.38,
                        padding: EdgeInsets.all(16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              templatePrograms[index].title,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              templatePrograms[index].description ??
                                  "Description here",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                      color: Colors.black.withOpacity(0.6)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // User Programs Section
            Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              Container(
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(7, 2, 7, 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Programs",
                          style: AppTheme.myTheme.textTheme.headlineSmall
                              ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'YourCustomFont',
                            color: AppTheme.colorDark1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ]),
            // User Programs List
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: userPrograms.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 10,
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(userPrograms[index].title),
                    subtitle: Text(
                      "${userPrograms[index].getExerciseAmount()} Movements · ${userPrograms[index].getSetAmount()} Sets",
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.edit, color: AppTheme.colorDark1),
                      tooltip: 'Edit Program',
                      onPressed: () {
                        navigateToCreateProgram(userPrograms, index,
                            isNew: false);
                      },
                    ),
                    onTap: () {
                      navigateToStartWorkout(userPrograms, index);
                    },
                    onLongPress: () {
                      _showDeleteDialog(index); // Show the delete dialog
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Class representing a Set
class Set {
  int reps;
  int prevWorkoutRep = 0;
  String type;
  int? weight;

  Set(this.reps, this.type, {this.weight});

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'reps': reps,
      'type': type,
      'weight': weight,
    };
  }

  // Create from JSON
  factory Set.fromJson(Map<String, dynamic> json) {
    return Set(
      json['reps'],
      json['type'],
      weight: json['weight'],
    );
  }

  // Deep copy
  Set copy() {
    return Set(reps, type, weight: weight);
  }
}

// Class representing an Exercise
class Exercise {
  List<Set>? sets;
  String title;

  Exercise(this.title, {this.sets});

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'sets': sets?.map((set) => set.toJson()).toList(),
    };
  }

  // Create from JSON
  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      json['title'],
      sets: (json['sets'] as List<dynamic>?)
          ?.map((set) => Set.fromJson(set as Map<String, dynamic>))
          .toList(),
    );
  }

  // Deep copy
  Exercise copy() {
    return Exercise(
      title,
      sets: sets?.map((set) => set.copy()).toList(),
    );
  }
}

// Class representing a Program
class Program {
  List<Exercise>? exercises;
  String? description;
  String title;
  int? time;

  Program(this.title, {this.exercises, this.description, this.time});

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'exercises': exercises?.map((exercise) => exercise.toJson()).toList(),
    };
  }

  // Create from JSON
  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      json['title'],
      description: json['description'],
      exercises: (json['exercises'] as List<dynamic>?)
          ?.map(
              (exercise) => Exercise.fromJson(exercise as Map<String, dynamic>))
          .toList(),
    );
  }

  // Deep copy
  Program copy() {
    return Program(
      title,
      description: description,
      exercises: exercises?.map((exercise) => exercise.copy()).toList(),
      time: time,
    );
  }

  // Get total set amount
  int getSetAmount() {
    int setAmount = 0;
    if (exercises != null) {
      for (var exercise in exercises!) {
        setAmount += exercise.sets?.length ?? 0; // Safely handle null sets
      }
    }
    return setAmount;
  }

  // Get total exercise amount
  int getExerciseAmount() {
    return exercises?.length ?? 0;
  }
}

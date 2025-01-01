import 'package:flutter/material.dart';
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
  // // Dummy data for template programs and user programs
  // final List<Map<String, String>> templates = [
  //   {"title": "Beginner Program", "description": "Start your fitness journey"},
  //   {"title": "Strength Focus", "description": "Build power and strength"},
  //   {"title": "Hypertrophy Plan", "description": "For muscle growth"},
  // ];

  // final List<Map<String, dynamic>> userPrograms = [
  //   {"title": "Custom Plan A", "movements": 12, "sets": 40},
  //   {"title": "Leg Day Special", "movements": 8, "sets": 25},
  //   {"title": "Upper Body Blitz", "movements": 10, "sets": 30},
  // ];

  List<Program> userPrograms = [
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
    Program("Strength Focustemp",
        description: "Build power and strength",
        exercises: [
          Exercise("Chest Press", sets: [
            Set(15, "Warmup"),
            Set(5, "Drop"),
          ]),
        ]),
  ];

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
    Program("Strength Focustemp",
        description: "Build power and strength",
        exercises: [
          Exercise("Chest Press", sets: [
            Set(15, "Warmup"),
            Set(5, "Drop"),
          ]),
        ]),
    Program("Strength Focustemp2",
        description: "Build power and strength",
        exercises: [
          Exercise("Chest Press", sets: [
            Set(15, "Warmup"),
            Set(5, "Drop"),
          ]),
        ]),
    Program("Strength Focustemp3",
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

  void navigateToCreateProgram(List<Program> programs, int index,bool isNew) async {
    Program updatedProgram = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateProgramsPage(
          programs: programs,
          index: index,
          isNew: isNew,
        ),
      ),
    );

      setState(() {
        if (isNew) {
          userPrograms.add(updatedProgram.copy());
        }else{
          userPrograms[index] = updatedProgram; // Update the program list
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToCreateProgram(userPrograms, -1, true);
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenSize.height * 0.035),
              // Page Title
              Center(
                child: Stack(
                  children: [
                    Text(
                      "Your Programs",
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
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
              Text(
                "Templates",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: templatePrograms.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        navigateToCreateProgram(templatePrograms, index, true);
                      },
                      child: Card(
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
              Text(
                "Your Programs",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              // TODO: CHANGE THIS BUILDER FROM TEMPLATE TO ACTUAL PROGRAMS
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: userPrograms.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(userPrograms[index].title),
                      subtitle: Text(
                          "${userPrograms[index].getExerciseAmount()} Movements · ${userPrograms[index].getSetAmount()} Sets"),
                      onTap: () {
                        navigateToCreateProgram(userPrograms, index, false);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Class representing a Set
class Set {
  int reps;
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

  Program(this.title, {this.exercises, this.description});

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
          ?.map((exercise) => Exercise.fromJson(exercise as Map<String, dynamic>))
          .toList(),
    );
  }

  // Deep copy
  Program copy() {
    return Program(
      title,
      description: description,
      exercises: exercises?.map((exercise) => exercise.copy()).toList(),
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


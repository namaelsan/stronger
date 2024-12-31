import 'package:flutter/material.dart';
import 'mylib.dart';

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

  final List<Map<String, dynamic>> userPrograms = [
    {"title": "Custom Plan A", "movements": 12, "sets": 40},
    {"title": "Leg Day Special", "movements": 8, "sets": 25},
    {"title": "Upper Body Blitz", "movements": 10, "sets": 30},
  ];


  var templatePrograms = [
    Program(
      title: "Beginner program",
      description: "Start your fitness journey",
      exercises: [
        Exercise(title: "Chest Press", sets: [
          Set(reps: 15, type: "Warmup"),
          Set(reps: 5,type: "Drop"),
      ]),]
    ),
    Program(
      title: "Strength Focus",
      description: "Build power and strength",
      exercises: [
        Exercise(title: "Chest Press", sets: [
          Set(reps: 15, type: "Warmup"),
          Set(reps: 5,type: "Drop"),
        ]),]
    ),
    Program(
      title: "Hypertrophy Program",
      description: "For muscle growth",
      exercises: [
        Exercise(title: "Squat", sets: [
          Set(reps: 15, type: "Warmup")
        ])]
    )
  ];

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
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
                    Text("Your Programs",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 7
                          ..color = AppTheme.colorDark1,
                      ),
                    ),
                    Text("Your Programs", style: Theme.of(context).textTheme.headlineLarge,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Template Programs Section
              Text("Templates", style: Theme.of(context).textTheme.headlineSmall, ),
              SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: templatePrograms.length,
                  itemBuilder: (context, index) {
                    return Card(
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
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black),
                            ),
                            SizedBox(height: 10),
                            Text(
                              templatePrograms[index].description ?? "Description here",
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              // User Programs Section
              Text("Your Programs", style: Theme.of(context).textTheme.headlineSmall,),
              // TODO: CHANGE THIS BUILDER FROM TEMPLATE TO ACTUAL PROGRAMS
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: templatePrograms.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(templatePrograms[index].title),
                      subtitle: Text(
                          "${templatePrograms[index].getExerciseAmount()} Movements · ${templatePrograms[index].getSetAmount()} Sets"),
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

  Set({required this.reps, required this.type,this.weight});
}

// Class representing an Exercise
class Exercise {
  List<Set>? sets;
  String title;

  Exercise({required this.title,this.sets});
}

// Class representing a Program
class Program {
  List<Exercise>? exercises;
  String? description;
  String title;

  Program({required this.title,this.exercises,this.description});

  int getSetAmount() {
    int setAmount = 0;
    if (exercises != null) {
      for (var exercise in exercises!) {
        setAmount += exercise.sets?.length ?? 0; // Safely handle null sets
      }
    }
    return setAmount;
  }


  int? getExerciseAmount(){
    return exercises?.length;
  }
}

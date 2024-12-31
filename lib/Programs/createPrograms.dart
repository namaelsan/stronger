import 'package:flutter/material.dart';
import 'programs.dart';
import 'package:stronger/mylib.dart';

class CreateProgramsPage extends StatefulWidget {
  Program? program;

  CreateProgramsPage({this.program});

  @override
  State<StatefulWidget> createState() {
    return _CreateProgramsPageState(program);
  }
}

class _CreateProgramsPageState extends State<CreateProgramsPage> {
  late Program? program;
  final Map<int, TextEditingController> _exerciseControllers = {};
  final Map<int, Map<int, TextEditingController>> _setControllers = {};

  _CreateProgramsPageState(this.program);

  @override
  void initState() {
    super.initState();

    // If no program exists, initialize with a default one
    program = widget.program ??
        Program(
          "New Program",
          description: "A default program",
          exercises: [
            Exercise(
              "Default Exercise",
              sets: [Set(10, "Regular")],
            )
          ],
        );

    _initializeControllers();
  }

  // Initialize controllers for exercises and sets
  void _initializeControllers() {
    for (var i = 0; i < (program?.exercises?.length ?? 0); i++) {
      _exerciseControllers[i] = TextEditingController(
        text: program?.exercises![i].title,
      );

      _setControllers[i] = {};
      for (var j = 0; j < (program?.exercises![i].sets?.length ?? 0); j++) {
        _setControllers[i]![j] = TextEditingController(
          text: program?.exercises![i].sets![j].reps.toString(),
        );
      }
    }
  }

  // Add an exercise
  void addExercise() {
    setState(() {
      final newExercise = Exercise(
        "New Exercise",
        sets: [Set(10, "Regular")],
      );
      program?.exercises?.add(newExercise);
      final index = (program?.exercises?.length ?? 1) - 1;

      _exerciseControllers[index] = TextEditingController(
        text: newExercise.title,
      );
      _setControllers[index] = {
        0: TextEditingController(text: "10"),
      };
    });
  }

  // Add a set
  void addSet(int exerciseIndex) {
    setState(() {
      final newSet = Set(10, "Regular");
      program?.exercises?[exerciseIndex].sets?.add(newSet);
      final setIndex = (program?.exercises?[exerciseIndex].sets?.length ?? 1) - 1;

      _setControllers[exerciseIndex]?[setIndex] = TextEditingController(
        text: "10",
      );
    });
  }

  // Remove an exercise
  void removeExercise(int index) {
    setState(() {
      program?.exercises?.removeAt(index);
      _exerciseControllers.remove(index);
      _setControllers.remove(index);
    });
  }

  // Remove a set
  void removeSet(int exerciseIndex, int setIndex) {
    setState(() {
      program?.exercises?[exerciseIndex].sets?.removeAt(setIndex);
      _setControllers[exerciseIndex]?.remove(setIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Stronger",style: Theme.of(context).textTheme.headlineMedium,)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Program Title
              TextField(
                decoration: InputDecoration(labelText: "Program Title"),
                controller: TextEditingController(text: program?.title,)
                  ..selection = TextSelection.collapsed(
                      offset: program!.title.length), // Keep caret position
                onChanged: (value) {
                  setState(() {
                    program?.title = value;
                  });
                },
              ),
              SizedBox(height: 20),

              // Exercises and Sets
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: program?.exercises?.length ?? 0,
                itemBuilder: (context, exerciseIndex) {
                  final exercise = program?.exercises![exerciseIndex];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Exercise Title
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                      labelText: "Exercise Title"),
                                  controller: _exerciseControllers[exerciseIndex],
                                  onChanged: (value) {
                                    setState(() {
                                      exercise?.title = value;
                                    });
                                  },
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => removeExercise(exerciseIndex),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),

                          // Sets List
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: exercise?.sets?.length ?? 0,
                            itemBuilder: (context, setIndex) {
                              final set = exercise?.sets![setIndex];
                              return Row(
                                children: [
                                  // Reps
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(labelText: "Reps"),
                                      controller: _setControllers[exerciseIndex]
                                      ?[setIndex],
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          set?.reps =
                                              int.tryParse(value) ?? set.reps;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),

                                  // Set Type
                                  Expanded(
                                    child: TextField(
                                      decoration: InputDecoration(labelText: "Set Type",),
                                      controller: TextEditingController(
                                          text: set?.type)
                                        ..selection = TextSelection.collapsed(
                                            offset: set!.type.length),
                                      onChanged: (value) {
                                        setState(() {
                                          set.type = value;
                                        });
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () =>
                                        removeSet(exerciseIndex, setIndex),
                                  ),
                                  SizedBox(height: 60),
                                ],
                              );
                            },
                          ),

                          SizedBox(height: 10),
                          // Add Set Button
                          TextButton.icon(
                            onPressed: () => addSet(exerciseIndex),
                            icon: Icon(Icons.add),
                            label: Text("Add Set",style: TextStyle(color: AppTheme.colorDark1),),
                            style: ButtonStyle(iconColor: WidgetStatePropertyAll(AppTheme.colorDark1.withOpacity(0.5))),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // Add Exercise Button
              SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: addExercise,
                  icon: Icon(Icons.add),
                  label: Text("Add Exercise"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

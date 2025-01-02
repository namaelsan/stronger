import 'package:flutter/material.dart';
import 'programs.dart';
import 'package:stronger/mylib.dart';

class StartWorkout extends StatefulWidget {
  final Program program;

  StartWorkout({required this.program});

  @override
  State<StatefulWidget> createState() {
    return _StartWorkoutState(program);
  }
}

class _StartWorkoutState extends State<StartWorkout> {
  late Program program;
  Program programExt;

  final Map<int, TextEditingController> _exerciseControllers = {};
  final Map<int, Map<int, TextEditingController>> _setControllers = {};

  _StartWorkoutState(this.programExt);

  @override
  void initState() {
    super.initState();

    program = programExt.copy();

    _initializeControllers();
  }

  // Initialize controllers for exercises and sets
  void _initializeControllers() {
    for (var i = 0; i < (program.exercises?.length ?? 0); i++) {
      _exerciseControllers[i] = TextEditingController(
        text: program.exercises![i].title,
      );

      _setControllers[i] = {};
      for (var j = 0; j < (program.exercises![i].sets?.length ?? 0); j++) {
        _setControllers[i]![j] = TextEditingController(
          text: program.exercises![i].sets![j].reps.toString(),
        );
      }
    }
  }

  // Save the program
  void _saveProgram() {
    // Pass the updated program back
    Navigator.pop(context, program);
  }

  // Add an exercise
  void addExercise() {
    setState(() {
      final newExercise = Exercise(
        "New Exercise",
        sets: [Set(10, "Regular")],
      );
      program.exercises?.add(newExercise);
      final index = (program.exercises?.length ?? 1) - 1;

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
      program.exercises?[exerciseIndex].sets?.add(newSet);
      final setIndex =
          (program.exercises?[exerciseIndex].sets?.length ?? 1) - 1;

      _setControllers[exerciseIndex]?[setIndex] = TextEditingController(
        text: "10",
      );
    });
  }

  // Remove an exercise
  void removeExercise(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Exercise",style: AppTheme.myTheme.textTheme.headlineSmall?.copyWith(color: Colors.black),),
          content: Text("Are you sure you want to remove this exercise?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  program.exercises?.removeAt(index);
                  _exerciseControllers.remove(index);
                  _setControllers.remove(index);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Remove"),
            ),
          ],
        );
      },
    );
  }


  // Remove a set
  void removeSet(int exerciseIndex, int setIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Remove Set",style: AppTheme.myTheme.textTheme.headlineSmall?.copyWith(color: Colors.black),),
          content: Text("Are you sure you want to remove this set?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  program.exercises?[exerciseIndex].sets?.removeAt(setIndex);
                  _setControllers[exerciseIndex]?.remove(setIndex);
                });
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text("Remove"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Stronger",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save Program',
            onPressed: _saveProgram,
          ),
          SizedBox(
            width: 7,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              // Program Title
              Stack(
                children: [
                  Text(
                    program.title,
                    style:
                    Theme.of(context).textTheme.headlineMedium?.copyWith(
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 7
                        ..color = AppTheme.colorDark1,
                    ),
                  ),
                  Text(
                    program.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Exercises and Sets
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: program.exercises?.length ?? 0,
                itemBuilder: (context, exerciseIndex) {
                  final exercise = program.exercises![exerciseIndex];
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
                                  controller:
                                  _exerciseControllers[exerciseIndex],
                                  onChanged: (value) {
                                    setState(() {
                                      exercise.title = value;
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
                            itemCount: exercise.sets?.length ?? 0,
                            itemBuilder: (context, setIndex) {
                              final set = exercise.sets![setIndex];
                              return Row(
                                children: [
                                  // Reps
                                  Expanded(
                                    child: TextField(
                                      decoration:
                                      InputDecoration(labelText: "Reps"),
                                      controller: _setControllers[exerciseIndex]
                                      ?[setIndex],
                                      keyboardType: TextInputType.number,
                                      onChanged: (value) {
                                        setState(() {
                                          set.reps =
                                              int.tryParse(value) ?? set.reps;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),

                                  // Set Type Dropdown
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: set.type,
                                      onChanged: (newValue) {
                                        setState(() {
                                          set.type = newValue!;
                                        });
                                      },
                                      decoration: InputDecoration(
                                        labelText: "Set Type",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8.0), // Rounded corners
                                          borderSide: BorderSide(
                                            color: Colors.grey, // Border color
                                            width: 1.0, // Border width
                                          ),
                                        ),
                                      ),
                                      items: [
                                        DropdownMenuItem<String>(
                                          value: "Warmup",
                                          child: Text("Warmup",style: AppTheme.myTheme.textTheme.bodyMedium,),
                                        ),
                                        DropdownMenuItem<String>(
                                          value: "Drop",
                                          child: Text("Drop",style: AppTheme.myTheme.textTheme.bodyMedium,),
                                        ),
                                        DropdownMenuItem<String>(
                                          value: "Regular",
                                          child: Text("Regular",style: AppTheme.myTheme.textTheme.bodyMedium,),
                                        ),
                                      ],
                                      hint: Text("Select Type"),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () =>
                                        removeSet(exerciseIndex, setIndex),
                                  ),
                                  SizedBox(
                                    height: 60,
                                  )
                                ],
                              );
                            },
                          ),

                          SizedBox(height: 10),
                          // Add Set Button
                          TextButton.icon(
                            onPressed: () => addSet(exerciseIndex),
                            icon: Icon(Icons.add),
                            label: Text(
                              "Add Set",
                              style: TextStyle(
                                color: AppTheme.colorDark1,
                              ),
                            ),
                            style: ButtonStyle(
                              iconColor: WidgetStateProperty.all(
                                AppTheme.colorDark1.withOpacity(0.5),
                              ),
                            ),
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

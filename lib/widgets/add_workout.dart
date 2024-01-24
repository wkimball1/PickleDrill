import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../resources/firestore_methods.dart';
import '../models/user.dart' as model;
import '../models/workouts.dart';
import '../utils.dart';
import '../colors.dart';
import '../providers/user_provider.dart';
import '../providers/workout_provider.dart';
import 'package:provider/provider.dart';
import '../screens/add_drill_screen.dart';
import 'dart:developer';
import '../providers/drill_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../home.dart';
import '../widgets/text_field_input.dart';
import 'package:flutter/rendering.dart';

class AddWorkout extends StatefulWidget {
  const AddWorkout({super.key});

  @override
  State<AddWorkout> createState() => _AddWorkoutState();
}

class _AddWorkoutState extends State<AddWorkout> {
  bool isLoading = false;
  bool isReady = true;
  int dateOfWorkout = DateTime.now().millisecondsSinceEpoch;
  DateTime workoutStart = DateTime.now();
  DateTime workoutEnd = DateTime.now();
  List<Map<String, dynamic>> drills = [];
  Workouts? workout;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _focusOfWorkoutController =
      TextEditingController();
  List<TextEditingController> _timeController = [];
  final TextEditingController _defaultTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    addDrills();
    createWorkout();
  }

  addDrills() async {
    DrillProvider drillProvider =
        Provider.of<DrillProvider>(context, listen: false);
    await drillProvider.addAllDrills();
  }

  updateDrillsTime(i) {
    if (workout != null && workout!.drills.isNotEmpty) {
      workout!.drills[i]["drillTime"] = _timeController[i].text;
      var drill = workout!.drills[i];
      inspect(workout!.drills[i]);
    }
  }

  updateDrills() {
    if (workout != null && workout!.drills.isNotEmpty) {
      for (int i = 0; i < workout!.drills.length; i++) {
        Provider.of<WorkoutProvider>(context, listen: false)
            .editDrills(i, workout!.drills[i]);
      }
    }
  }

  createWorkout() async {
    setState(() {
      isLoading = true;
    });
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    await userProvider.refreshUser();
    if (mounted) {
      final model.User? user =
          Provider.of<UserProvider>(context, listen: false).getUser;
      int lengthOfWorkout = workoutEnd.difference(workoutStart).inSeconds;

//check if workout already exists
      workout = Provider.of<WorkoutProvider>(context, listen: false).getWorkout;
      if (workout != null) {
        print('Workout already exists ${inspect(workout)}');
      } else {
        // start the loading
        workout = Provider.of<WorkoutProvider>(context, listen: false)
            .setWorkout(
                _nameController.text,
                user?.uid,
                _focusOfWorkoutController.text,
                drills,
                dateOfWorkout,
                lengthOfWorkout);
        print('created new workout: ${inspect(workout)}');
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  void uploadWorkout(Workouts workout) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      // upload to storage and db
      String res = await FireStoreMethods().uploadWorkout(workout);
      if (res == "success" && context.mounted) {
        Provider.of<WorkoutProvider>(context, listen: false)
            .deleteWorkout(workout.workoutId);

        if (context.mounted) {
          showSnackBar(
            context,
            'Created!',
          );
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false);
        }
      } else {
        if (context.mounted) {
          showSnackBar(context, res);
        }
      }
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  void cancelWorkout(Workouts workout) async {
    setState(() {
      isLoading = true;
    });
    // start the loading
    try {
      Provider.of<WorkoutProvider>(context, listen: false)
          .deleteWorkout(workout.workoutId);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (route) => false);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  editWorkout() {
    // start the loading
    if (workout != null) {
      workout!.focusOfWorkout = _focusOfWorkoutController.text;
      Provider.of<WorkoutProvider>(context, listen: false)
          .updateWorkout(workout!.workoutId, workout!);
    }
  }

  void updateControllers() {
    // setState(() {
    _timeController = [];
    if (workout != null && workout!.drills.isNotEmpty) {
      for (int i = 0; i < workout!.drills.length; i++) {
        _timeController
            .add(TextEditingController(text: workout!.drills[i]["drillTime"]));
      }
    }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    _nameController.dispose();
    _focusOfWorkoutController.dispose();
    _defaultTimeController.dispose();
    for (int i = 0; i < _timeController.length; i++) {
      _timeController[i].dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final WorkoutProvider workoutProvider =
        Provider.of<WorkoutProvider>(context, listen: true);
    workout = workoutProvider.getWorkout;
    updateControllers();
    _focusOfWorkoutController.text = workout?.focusOfWorkout ?? "";
    return (isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              // leading: IconButton(
              //   icon: const Icon(Icons.arrow_back),
              //   onPressed: minimizeWorkout,
              // ),
              leadingWidth: 100,
              title: const Text(
                'Create Workout',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
              leading: IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.arrow_back),
              ),
              centerTitle: true,
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide.none),
                    ),
                    onPressed: workout != null && workout!.drills.isNotEmpty
                        ? () => uploadWorkout(workout!)
                        : () => showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                actionsAlignment: MainAxisAlignment.center,
                                titlePadding: EdgeInsets.fromLTRB(0, 15, 0, 10),
                                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                actionsPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                title: const Text("Add a drill",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    )),
                                // content: const Divider(
                                //   height: 5,
                                //   thickness: .1,
                                //   color: Colors.black,
                                // ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(ctx).pop();
                                    },
                                    child: const Text(
                                      "Ok",
                                      style: TextStyle(
                                          color: Colors.blue, fontSize: 16),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    child: const Text(
                      "Finish",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0,
                      ),
                    ),
                  ),
                )
              ],
            ),
            // POST FORM
            body: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 16),
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "What are you trying to improve?",
                            border: OutlineInputBorder(
                                borderSide: Divider.createBorderSide(context)),
                          ),
                          keyboardType: TextInputType.text,
                          controller: _focusOfWorkoutController,
                          onSubmitted: (value) => editWorkout(),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Drill Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline)),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text("Time",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline)),
                            ),
                          ]),
                    ),
                    Container(
                      child: ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: listView(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ));
  }

  // Widget createSlidable(var i) {
  //   final WorkoutProvider workoutProvider =
  //       Provider.of<WorkoutProvider>(context);

  //   return Slidable(
  //     // Specify a key if the Slidable is dismissible.
  //     key: const ValueKey(0),

  //     // The end action pane is the one at the right or the bottom side.
  //     endActionPane: ActionPane(
  //       motion: ScrollMotion(),
  //       extentRatio: .25,
  //       children: [
  //         SlidableAction(
  //           // An action can be bigger than the others.
  //           // flex: 1,
  //           onPressed: (BuildContext context) async {
  //             await Provider.of<WorkoutProvider>(context, listen: false)
  //                 .removeDrills(i);
  //           },

  //           backgroundColor: Color(0xFFFE4A49),
  //           foregroundColor: Colors.white,
  //           icon: Icons.delete,
  //           label: 'Delete',
  //         ),
  //       ],
  //     ),

  //     // The child of the Slidable is what the user sees when the
  //     // component is not dragged.
  //     child: ListTile(title: Center(child: Text('${i['name']}'))),
  //   );
  // }

  List<Widget> listView() {
    List<Widget> topPart = [];
    if (workout != null && workout!.drills.isNotEmpty) {
      for (int i = 0; i < workout!.drills.length; i++) {
        topPart.add(Dismissible(
            direction: DismissDirection.endToStart,
            resizeDuration: Duration(milliseconds: 200),
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(()
                  // TODO: implement your delete function and check direction if needed
                  {
                Provider.of<WorkoutProvider>(context, listen: false)
                    .removeDrills(i);
              });
            },
            background: Container(
              padding: EdgeInsets.only(left: 28.0),
              alignment: AlignmentDirectional.centerStart,
              color: Colors.red,
              child: Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
            ),
            // secondaryBackground: ...,
            child: Container(
              color: Colors.white,
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: ListTile(
                      title: Text(workout!.drills[i]['name']),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: TextField(
                          decoration: InputDecoration(hintText: '10'),
                          keyboardType: TextInputType.number,
                          controller: _timeController[i],
                          onChanged: (value) => updateDrillsTime(i),
                          onSubmitted: updateDrills()),
                    ),
                  ),
                ],
              ),
            )));
      }
    } else {
      topPart.add(
          SizedBox(height: 200, child: Center(child: Text('Empty Workout'))));
    }
    topPart.add(Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.all(5),
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddDrills(),
            ),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.blue),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide.none))),
          child: const Text(
            "Add Drill",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
          ),
        ),
      ),
    ));
    topPart.add(Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: const EdgeInsets.all(5),
        // width: double.infinity,
        child: ElevatedButton(
          onPressed: () => cancelWorkout(workout!),
          child: const Text(
            "Cancel Workout",
            style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 12.0),
          ),
        ),
      ),
    ));

    return topPart;
  }
}

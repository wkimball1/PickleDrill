import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pickledrill/providers/saved_workouts_provider.dart';
import '../resources/firestore_methods.dart';
import '../models/user.dart' as model;
import '../models/workouts.dart';
import '../utils.dart';
import '../colors.dart';
import '../providers/user_provider.dart';
import '../providers/workout_provider.dart';
import '../providers/screen_index_provider.dart';
import 'package:provider/provider.dart';
import '../screens/add_drill_screen.dart';
import 'dart:developer';
import '../providers/drill_provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../home.dart';
import '../widgets/text_field_input.dart';
import '../widgets/drill_card.dart';

class CreateWorkoutScreen extends StatefulWidget {
  const CreateWorkoutScreen({super.key});

  @override
  State<CreateWorkoutScreen> createState() => _CreateWorkoutScreenState();
}

class _CreateWorkoutScreenState extends State<CreateWorkoutScreen> {
  bool isLoading = false;
  bool isReady = true;
  double? sizeBetween = 12;
  List savedWorkouts = [];

  deleteSavedWorkout(String workoutId) async {
    try {
      await FireStoreMethods().deleteSavedWorkout(workoutId);
    } catch (err) {
      if (!mounted) return;
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final SavedWorkoutProvider savedWorkoutsProvider =
        Provider.of<SavedWorkoutProvider>(context);
    savedWorkouts = savedWorkoutsProvider.getWorkouts;
    final _screenProvider =
        Provider.of<screenIndexProvider>(context, listen: true);

    return (isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            // POST FORM
            body: SingleChildScrollView(
              physics: ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Quick Start",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: sizeBetween),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  side: BorderSide.none),
                              side: BorderSide(color: Colors.black26)),
                          onPressed: () => {
                                setState(() {
                                  _screenProvider.updateScreenIndex(3);
                                })
                              },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                size: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: const Text(
                                  "Start playing now",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: sizeBetween),
                      const Text(
                        "Create Sessions",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      SizedBox(height: sizeBetween),
                      OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0.0),
                                  side: BorderSide.none),
                              side: BorderSide(color: Colors.black26)),
                          onPressed: () => {
                                setState(() {
                                  _screenProvider.updateScreenIndex(4);
                                })
                              },
                          child: Row(
                            children: [
                              Icon(
                                Icons.add,
                                size: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                                child: const Text(
                                  "Create new saved session",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black87),
                                ),
                              ),
                            ],
                          )),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(8, 16, 4, 8),
                        child: const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("My Saved Sessions",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                            ]),
                      ),
                      Container(
                        child: ListView(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            Column(
                                children: savedWorkouts
                                    .map<Widget>((workout) =>
                                        SavedWorkoutCard(workout, user))
                                    .toList()),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
  }

  Widget SavedWorkoutCard(workout, user) {
    return Card(
      shadowColor: Colors.blue,
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8),
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    workout["name"],
                    style: const TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      // color: Colors.lightGreen[300],
                    ),
                  ),
                  const Spacer(),
                  workout['uid'].toString() == user.uid
                      ? Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                useRootNavigator: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actionsAlignment: MainAxisAlignment.center,
                                    titlePadding:
                                        EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    contentPadding:
                                        EdgeInsets.fromLTRB(0, 15, 0, 0),
                                    actionsPadding:
                                        EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    content:
                                        const Text("Delete this saved session?",
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
                                          setState(() {
                                            String res = deleteSavedWorkout(
                                                    workout['workoutId'])
                                                .toString();
                                            inspect(res);
                                            Navigator.of(context).pop();
                                            Provider.of<SavedWorkoutProvider>(
                                                    context)
                                                .getSavedWorkouts();
                                            // _screenProvider
                                            //     .updateScreenIndex(holdIndex);
                                          });
                                        },
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 16),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: const Icon(Icons.more_horiz),
                          ),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  const Text(
                    "Drill Name",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      // color: Colors.lightGreen[300]
                    ),
                  ),
                  Spacer(),
                  const Text(
                    "Time",
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      // color: Colors.lightGreen[300]
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (workout["drills"].isNotEmpty)
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: workout["drills"].length,
                          itemBuilder: (context, index) =>
                              DrillCard(snap: workout["drills"][index]))
                      : const Text(
                          'no drills found',
                          style: TextStyle(
                            fontSize: 18.0,
                            // color: Colors.lightGreen[300]
                          ),
                        )
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () => setState(() {
                            Workouts? existingWorkout =
                                Provider.of<WorkoutProvider>(context,
                                        listen: false)
                                    .getWorkout;
                            bool deleteExistingWorkout = true;
                            if (existingWorkout != null) {
                              showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  actionsAlignment: MainAxisAlignment.center,
                                  titlePadding:
                                      EdgeInsets.fromLTRB(0, 15, 0, 10),
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  actionsPadding:
                                      EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  title: const Text("Cancel ongoing workout",
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
                                      onPressed: () async {
                                        deleteExistingWorkout = true;
                                        Navigator.of(ctx).pop();

                                        Workouts myWorkout =
                                            await Provider.of<WorkoutProvider>(
                                                    context,
                                                    listen: false)
                                                .setWorkout(
                                                    workout["name"],
                                                    workout["uid"],
                                                    workout["focusOfWorkout"],
                                                    workout["drills"],
                                                    workout["dateOfWorkout"],
                                                    0);

                                        Provider.of<screenIndexProvider>(
                                                context,
                                                listen: false)
                                            .updateScreenIndex(3);
                                      },
                                      child: const Text(
                                        "Yes",
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 16),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        deleteExistingWorkout = false;
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text(
                                        "No",
                                        style: TextStyle(
                                            color: Colors.blue, fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              Workouts myWorkout = Provider.of<WorkoutProvider>(
                                      context,
                                      listen: false)
                                  .setWorkout(
                                      workout["name"],
                                      workout["uid"],
                                      workout["focusOfWorkout"],
                                      workout["drills"],
                                      workout["dateOfWorkout"],
                                      0);

                              Provider.of<screenIndexProvider>(context,
                                      listen: false)
                                  .updateScreenIndex(3);
                            }
                          }),
                      child: Text("Start Session"))
                ],
              )
            ],
          ),
        );
      }),
    );
  }
}

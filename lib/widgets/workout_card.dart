import 'package:flutter/material.dart';
import 'drill_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../resources/firestore_methods.dart';
import '../models/user.dart' as model;
import '../utils.dart';
import '../providers/user_provider.dart';
import '../providers/workout_provider.dart';
import 'package:provider/provider.dart';
import '../providers/screen_index_provider.dart';

import 'dart:developer';

class WorkoutCard extends StatefulWidget {
  final snap;
  const WorkoutCard({super.key, required this.snap});

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  int drillLen = 0;
  List drills = [];

  @override
  void initState() {
    super.initState();
    fetchDrills();
  }

  fetchDrills() async {
    try {
      drillLen = widget.snap['drills'].length;
      drills = widget.snap['drills'];
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
    setState(() {});
  }

  deleteWorkout(String workoutId) async {
    try {
      await FireStoreMethods().deleteWorkout(workoutId);
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final model.User user = Provider.of<UserProvider>(context).getUser;
    final _screenProvider =
        Provider.of<screenIndexProvider>(context, listen: true);
    final int holdIndex = _screenProvider.fetchCurrentScreenIndex;
    final workoutProvider = Provider.of<WorkoutProvider>(context, listen: true);
    Size size = MediaQuery.of(context).size;

    return Card(
      shadowColor: Colors.blue,
      color: Colors.white,
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.username,
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                          // color: Colors.lightGreen[300],
                        ),
                      ),
                      Text(
                        elapsedDate(widget.snap.data()['dateOfWorkout']),
                        style: const TextStyle(
                          fontSize: 10.0,
                          // color: Colors.lightGreen[300]
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  widget.snap['uid'].toString() == user.uid
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
                                    content: const Text("Delete this workout?",
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
                                            String res = deleteWorkout(
                                                    widget.snap['workoutId'])
                                                .toString();
                                            inspect(res);
                                            Navigator.of(context).pop();
                                            workoutProvider.getWorkoutsDB();
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
              const SizedBox(height: 4.0),
              Row(children: [
                const Text(
                  "Focus of Workout",
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                    // color: Colors.lightGreen[300]
                  ),
                ),
              ]),
              Row(
                children: [
                  Text(widget.snap.data()['focusOfWorkout'],
                      style: TextStyle(
                        fontSize: 12.0,
                      )),
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
                  (drills.isNotEmpty)
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: drills.length,
                          itemBuilder: (context, index) =>
                              DrillCard(snap: drills[index]))
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
            ],
          ),
        );
      }),
    );
  }

  String elapsedDate(dateTime) {
    if (dateTime != null) {
      DateTime date = DateTime.fromMillisecondsSinceEpoch(dateTime);
      final Duration myDuration = date.difference(DateTime.now());
      if (myDuration.inDays < 0) {
        if (myDuration.inDays.abs() == 1) {
          return '${myDuration.inDays.abs().toString()} day ago';
        } else {
          return '${myDuration.inDays.abs().toString()} days ago';
        }
      } else {
        if (myDuration.inDays > 0) {
          if (myDuration.inDays == 1) {
            return '${myDuration.inDays.abs().toString()} day from now';
          } else {
            return '${myDuration.inDays.abs().toString()} days from now';
          }
        } else {
          if (myDuration.inDays == 0) {
            if (myDuration.inSeconds < 0) {
              return '${myDuration.inHours.abs().toString()} hours ago';
            }
            if (myDuration.inSeconds > 0) {
              return '${myDuration.inHours.abs().toString()} hours from now';
            }
          }
        }
      }
    }
    return "error";
  }
}

import 'package:flutter/material.dart';
import 'drill_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../resources/firestore_methods.dart';
import '../models/user.dart' as model;
import '../utils.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';

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
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('workouts')
          .doc(widget.snap['workoutId'])
          .collection('srills')
          .get();
      drillLen = snap.docs.length;
      drills = snap.docs;
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
    return Scaffold(
      body: Card(
        margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
        child: Builder(builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.snap.data()['name'],
                    style: const TextStyle(
                      fontSize: 18.0,

                      // color: Colors.lightGreen[300],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4.0),
              Text(
                elapsedDate(widget.snap.data()['dateOfWorkout']),
                style: const TextStyle(
                  fontSize: 12.0,
                  // color: Colors.lightGreen[300]
                ),
              ),
              const SizedBox(height: 4.0),
              const Text(
                "Time",
                style: TextStyle(
                  fontSize: 12.0,
                  // color: Colors.lightGreen[300]
                ),
              ),
              const SizedBox(height: 4.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (drills.isNotEmpty)
                      ? ListView.builder(
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
              const SizedBox(height: 30.0),
              widget.snap['uid'].toString() == user.uid
                  ? IconButton(
                      onPressed: () {
                        showDialog(
                          useRootNavigator: false,
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: [
                                    'Delete',
                                  ]
                                      .map(
                                        (e) => InkWell(
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 16),
                                              child: Text(e),
                                            ),
                                            onTap: () {
                                              deleteWorkout(
                                                widget.snap['workoutId']
                                                    .toString(),
                                              );
                                              // remove the dialog box
                                              Navigator.of(context).pop();
                                            }),
                                      )
                                      .toList()),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.more_vert),
                    )
                  : Container(),
            ],
          );
        }),
      ),
    );
  }

  String elapsedDate(dateTime) {
    if (dateTime != null) {
      final Duration myDuration = dateTime.difference(DateTime.now());
      if (myDuration.inDays < 0) {
        return '${myDuration.inDays.abs().toString()} days ago';
      } else {
        if (myDuration.inDays > 0) {
          return '${myDuration.inDays.abs().toString()} days from now';
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
    return " ";
  }
}

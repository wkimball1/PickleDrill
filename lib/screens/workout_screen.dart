import 'package:flutter/material.dart';
import 'package:pickledrill/widgets/workout_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils.dart';
import 'package:pickledrill/widgets/add_workout.dart';
import 'dart:developer';

class WorkoutScreen extends StatefulWidget {
  ScrollPhysics? physics;

  WorkoutScreen({super.key, this.physics});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  List workoutData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      // get workouts
      var workoutSnap = await FirebaseFirestore.instance
          .collection('workouts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      for (int i = 0; i < workoutSnap.docs.length; i++) {
        workoutData.add(workoutSnap.docs[i]);
      }
      inspect(workoutData);
      setState(() {});
    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: workoutData.isEmpty
                ? ElevatedButton(
                    child: const Text("Create a workout now"),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AddWorkout())))
                : ListView(
                    shrinkWrap: true,
                    physics: widget.physics,
                    // Column is also a layout widget. It takes a list of children and
                    // arranges them vertically. By default, it sizes itself to fit its
                    // children horizontally, and tries to be as tall as its parent.
                    //
                    // Column has various properties to control how it sizes itself and
                    // how it positions its children. Here we use mainAxisAlignment to
                    // center the children vertically; the main axis here is the vertical
                    // axis because Columns are vertical (the cross axis would be
                    // horizontal).
                    //
                    // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
                    // action in the IDE, or press "p" in the console), to see the
                    // wireframe for each widget.
                    children: [
                      Column(
                          children: workoutData
                              .map<Widget>(
                                  (workout) => WorkoutCard(snap: workout))
                              .toList()),
                    ],
                  ),
          );
  }
}

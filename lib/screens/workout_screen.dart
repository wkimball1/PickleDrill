import 'package:flutter/material.dart';
import '../drill.dart';
import 'package:flutter/material.dart';
import '../drill.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils.dart';
import '../resources/auth_methods.dart';
import '../resources/firestore_methods.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

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

      workoutData = workoutSnap.docs;

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

  Widget drillTemplate(drill) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            drill.name,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              // color: Colors.lightGreen[300]
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            drill.description,
            style: const TextStyle(
              fontSize: 12.0,
              // color: Colors.lightGreen[300]
            ),
          ),
        ],
      ),
    );
  }

  Widget workoutTemplate(workout) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                workout.name,
                style: const TextStyle(
                  fontSize: 18.0,

                  // color: Colors.lightGreen[300],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          Text(
            elapsedDate(workout.dateTime),
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
            children: (workout.drills != null)
                ? workout.drills
                    .map<Widget>((drill) => drillTemplate(drill))
                    .toList()
                : [
                    const Text(
                      'no drills found',
                      style: TextStyle(
                        fontSize: 18.0,
                        // color: Colors.lightGreen[300]
                      ),
                    )
                  ],
          ),
          const SizedBox(height: 30.0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: ListView(
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
          Row(
            children: [Text('New Workout')],
          ),
          Column(
              children: workoutData
                  .map<Widget>((workout) => workoutTemplate(workout))
                  .toList()),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pickledrill/widgets/workout_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = false;
  List workoutData = [];

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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: [
          Column(
            children: (workoutData.isNotEmpty)
                ? workoutData
                    .map((workout) => WorkoutCard(snap: workout))
                    .toList()
                : [const Text("no workouts, add one now")],
          ),
        ],
      ),
    );
  }
}

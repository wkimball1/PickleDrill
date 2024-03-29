import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pickledrill/screens/create_workout_screen.dart';
import 'package:pickledrill/screens/workout_screen.dart';
import 'package:pickledrill/widgets/add_workout.dart';
import 'package:pickledrill/widgets/add_session.dart';
import 'screens/home_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/create_workout_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  WorkoutScreen(physics: AlwaysScrollableScrollPhysics()),
  CreateWorkoutScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
  AddWorkout(),
  const AddSession(),
];

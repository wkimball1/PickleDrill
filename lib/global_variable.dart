import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import './screens/workout_screen.dart';
import 'screens/profile_screen.dart';

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const Text('notifications'),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];

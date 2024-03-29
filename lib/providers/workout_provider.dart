import 'package:flutter/widgets.dart';
import '../models/workouts.dart';
import 'package:uuid/uuid.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils.dart';

class WorkoutProvider with ChangeNotifier {
  Workouts? _workout;

  List _workouts = [];

  Workouts? get getWorkout => _workout;

  List get getWorkouts => _workouts;

  Workouts setWorkout(
      name, uid, focusOfWorkout, drills, dateOfWorkout, lengthOfWorkout) {
    _workout = Workouts(
        workoutId: const Uuid().v1(), // creates unique id based on time
        name: name,
        uid: uid,
        focusOfWorkout: focusOfWorkout,
        drills: drills,
        dateOfWorkout: dateOfWorkout,
        lengthOfWorkout: lengthOfWorkout);

    notifyListeners();
    return _workout!;
  }

  void addDrills(drill) {
    _workout?.drills.add(drill);
    notifyListeners();
  }

  void editDrills(i, drill) {
    _workout?.drills[i] = drill;
  }

  dynamic removeDrills(drill) {
    var removed = _workout!.drills.removeAt(drill);
    print(drill);
    inspect(_workout!.drills);
    notifyListeners();
    return removed;
  }

  void deleteWorkout(workoutId) {
    if (_workout?.workoutId == workoutId) {
      _workout = null;
      notifyListeners();
    }
  }

  void updateWorkout(workoutId, workout) {
    if (_workout?.workoutId == workoutId) {
      _workout = workout;
      notifyListeners();
    }
  }

  Future<List> getWorkoutsDB() async {
    _workouts = [];
    try {
      // get workouts
      var workoutSnap = await FirebaseFirestore.instance
          .collection('workouts')
          .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .orderBy("dateOfWorkout", descending: true)
          .get();

      for (int i = 0; i < workoutSnap.docs.length; i++) {
        _workouts.add(workoutSnap.docs[i]);
      }
      print("read db");
    } catch (e) {
      log(e.toString());
    }
    notifyListeners();
    return _workouts;
  }
}

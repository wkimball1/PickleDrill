import 'package:cloud_firestore/cloud_firestore.dart';

class Workouts {
  final String name;
  final String uid;
  final String focusOfWorkout;
  List drills = [];
  final int dateOfWorkout;
  final int? lengthOfWorkout;
  final String? description;
  final String workoutId;

  Workouts(
      {required this.uid,
      required this.name,
      required this.focusOfWorkout,
      required this.drills,
      required this.dateOfWorkout,
      required this.lengthOfWorkout,
      this.description,
      required this.workoutId});

  static Workouts fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Workouts(
      uid: snapshot["uid"],
      name: snapshot["name"],
      focusOfWorkout: snapshot["focusOfWorkout"],
      drills: snapshot["drills"],
      dateOfWorkout: snapshot["dateOfWorkout"],
      lengthOfWorkout: snapshot["lengthOfWorkout"],
      description: snapshot["description"],
      workoutId: snapshot["workoutId"],
    );
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "focusOfWorkout": focusOfWorkout,
        "drills": drills,
        "dateOfWorkout": dateOfWorkout,
        "lengthOfWorkout": lengthOfWorkout,
        "description": description,
        "workoutId": workoutId,
      };
}

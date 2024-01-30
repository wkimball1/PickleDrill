import 'package:cloud_firestore/cloud_firestore.dart';

class SavedWorkouts {
  String name;
  final String uid;
  String focusOfWorkout;
  List drills = [];
  String? description;
  final String workoutId;
  int dateOfWorkout;
  List likedBy = [];

  SavedWorkouts(
      {required this.uid,
      required this.name,
      required this.focusOfWorkout,
      required this.drills,
      this.description,
      required this.workoutId,
      required this.dateOfWorkout,
      required this.likedBy});

  static SavedWorkouts fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return SavedWorkouts(
        uid: snapshot["uid"],
        name: snapshot["name"],
        focusOfWorkout: snapshot["focusOfWorkout"],
        drills: snapshot["drills"],
        description: snapshot["description"],
        workoutId: snapshot["workoutId"],
        dateOfWorkout: snapshot["dateOfWorkout"],
        likedBy: snapshot["likedBy"]);
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "name": name,
        "focusOfWorkout": focusOfWorkout,
        "drills": drills,
        "description": description,
        "workoutId": workoutId,
        "dateOfWorkout": dateOfWorkout,
        "likedBy": likedBy
      };
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Drills {
  final String name;
  final String drillId;
  final String description;
  final String url;
  final String level;
  final List focus;

  const Drills(
      {required this.name,
      required this.drillId,
      required this.description,
      this.url = "",
      this.level = "",
      required this.focus});

  static Drills fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Drills(
      name: snapshot["name"],
      drillId: snapshot["drillId"],
      description: snapshot["description"],
      url: snapshot["url"],
      level: snapshot["level"],
      focus: snapshot["focus"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "drillId": drillId,
        "description": description,
        "url": url,
        "level": level,
        "focus": focus,
      };
}

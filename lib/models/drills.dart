import 'package:cloud_firestore/cloud_firestore.dart';

class Drills {
  final String name;
  final String uid;
  final String description;
  final String url;
  final String type;

  const Drills(
      {required this.name,
      required this.uid,
      required this.description,
      this.url = "",
      required this.type});

  static Drills fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Drills(
      name: snapshot["name"],
      uid: snapshot["uid"],
      description: snapshot["description"],
      url: snapshot["url"],
      type: snapshot["type"],
    );
  }

  Map<String, dynamic> toJson() => {
        "name": name,
        "uid": uid,
        "description": description,
        "url": url,
        "type": type,
      };
}

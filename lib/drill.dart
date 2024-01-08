class Drill {
  String name;
  String description;

  Drill({this.name = "", this.description = ""});

  static List<Drill> getDrills() {
    List<Drill> drills = [];
    drills.add(Drill(
        name: 'fast hands',
        description:
            'stand at the kitchen line facing your partner on hit volleys back and forth'));
    drills.add(Drill(
        name: 'face on dinks',
        description:
            'stand at the kitchen line facing your partner on hit dinks back and forth'));
    drills.add(Drill(
        name: '3rd shot drops',
        description: 'one person stands at the kitchen line and the '
            'other stands at the baseline and the baseline person tries to hit drops into the kitchen'));
    return drills;
  }
}

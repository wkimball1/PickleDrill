import 'package:flutter/material.dart';

class DrillCard extends StatelessWidget {
  final snap;
  const DrillCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              snap.data()['name'],
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                // color: Colors.lightGreen[300]
              ),
            ),
            const SizedBox(height: 2.0),
            Text(
              snap.data()['description'],
              style: const TextStyle(
                fontSize: 12.0,
                // color: Colors.lightGreen[300]
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:developer';

class DrillCard extends StatelessWidget {
  final snap;
  const DrillCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            snap['name'],
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
              // color: Colors.lightGreen[300]
            ),
          ),
          const SizedBox(height: 2.0),
          Text(
            snap['description'],
            style: const TextStyle(
              fontSize: 12.0,
              // color: Colors.lightGreen[300]
            ),
          ),
        ],
      ),
    );
  }
}

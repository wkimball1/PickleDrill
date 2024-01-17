import 'package:flutter/material.dart';
import 'dart:developer';

class DrillCard extends StatelessWidget {
  final snap;
  const DrillCard({super.key, required this.snap});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 2.0),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    snap['name'],
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      // color: Colors.lightGreen[300]
                    ),
                  ),
                  // const SizedBox(height: 2.0),
                  // Text(
                  //   snap['description'],
                  //   style: const TextStyle(
                  //     fontSize: 12.0,
                  //     // color: Colors.lightGreen[300]
                  //   ),
                  // ),
                ],
              ),
              Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      snap['name'],
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        // color: Colors.lightGreen[300]
                      ),
                    ),
                  ),
                  // const SizedBox(height: 2.0),
                  // Text(
                  //   snap['description'],
                  //   style: const TextStyle(
                  //     fontSize: 12.0,
                  //     // color: Colors.lightGreen[300]
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

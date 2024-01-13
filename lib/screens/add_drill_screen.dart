import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../resources/firestore_methods.dart';
import '../models/user.dart' as model;
import '../models/workouts.dart';
import '../utils.dart';
import '../colors.dart';
import '../providers/user_provider.dart';
import '../providers/workout_provider.dart';
import 'package:provider/provider.dart';
import 'package:pickledrill/widgets/add_workout.dart';
import 'dart:developer';

class AddDrills extends StatefulWidget {
  const AddDrills({super.key});

  @override
  State<AddDrills> createState() => _AddDrillsState();
}

class _AddDrillsState extends State<AddDrills> {
  bool isLoading = false;
  List drills = [];
  List<int> _selectedDrills = [];

  @override
  void initState() {
    super.initState();
    fetchAllDrills();
  }

  fetchAllDrills() async {
    setState(() {
      isLoading = true;
    });
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('drills').get();

      // Get data from docs and convert map to List
      drills = querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (err) {
      if (context.mounted) {
        showSnackBar(
          context,
          err.toString(),
        );
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Add drills"),
            ),
            body: ListView.builder(
              itemCount: drills.length,
              itemBuilder: (BuildContext ctxt, int index) =>
                  _buildListTile(index),
            ),
            floatingActionButton: FloatingActionButton.extended(
                isExtended: true,
                label: Text("Add ${_selectedDrills.length} drills"),
                onPressed: () => {
                      if (_selectedDrills.isNotEmpty)
                        {
                          for (int i = 0; i < _selectedDrills.length; i++)
                            {
                              Provider.of<WorkoutProvider>(context,
                                      listen: false)
                                  .addDrills(drills[_selectedDrills[i]])
                            },
                          inspect(_selectedDrills),
                          Navigator.of(context).pop((context, drills))
                        }
                      else
                        {
                          showSnackBar(
                            context,
                            "select at least 1 drill",
                          )
                        }
                    }));
  }

  void toggleSelectedListTile(int index) {
    if (_selectedDrills.contains(index))
      setState(() => _selectedDrills.remove(index));
    else
      setState(() => _selectedDrills.add(index));
  }

  Widget _buildListTile(int index) {
    return ListTile(
      selected: _selectedDrills.contains(index),
      selectedTileColor: Colors.red,
      title: Text('${drills[index]['name']}'),
      onTap: () {
        toggleSelectedListTile(index);
      },
    );
  }
}

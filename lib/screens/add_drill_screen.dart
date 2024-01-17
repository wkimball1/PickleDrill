import 'dart:collection';

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
  List drillSubset = [];
  List<int> _selectedDrills = [];
  final _controller = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    _controller.addListener(
      () {
        setState(() {
          _searchText = _controller.text;
        });
      },
    );
    super.initState();
    fetchAllDrills();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  fetchAllDrills() async {
    drills = [];
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

  void changeSearchString(String searchString) {
    setState(() {
      _searchText = searchString;
    });
    print(_searchText);
  }

  UnmodifiableListView getDrill() {
    inspect(drills);
    setState(() {
      drillSubset = [];
      if (_searchText.isEmpty) {
        drillSubset = drills;
      } else {
        drillSubset.addAll(drills.where((drill) =>
            drill["name"].toLowerCase().contains(_searchText.toLowerCase())));
        for (int i = 0; i < drills.length; i++) {
          for (var focus in drills[i]["focus"]) {
            if (focus.toLowerCase().contains(_searchText.toLowerCase()) &&
                !drillSubset.contains(drills[i])) {
              drillSubset.add(drills[i]);
            }
          }
        }
      }
    });
    return UnmodifiableListView(drillSubset);
  }

  @override
  Widget build(BuildContext context) {
    getDrill();
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Add drills"),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    changeSearchString(value);
                  },
                ),
                Expanded(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: drillSubset.length,
                      itemBuilder: (context, index) => Card(
                            elevation: 3,
                            child: ListTile(
                              title: Text(drillSubset[index]['name']),
                              trailing:
                                  Text(drillSubset[index]['focus'].toString()),
                              onTap: () {
                                toggleSelectedListTile(index);
                              },
                              selected: _selectedDrills.contains(index),
                              selectedTileColor: Colors.lightBlue,
                            ),
                          )),
                ),
              ],
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

  //  @override
  // Widget build(BuildContext context) {
  //   return isLoading
  //       ? const Center(
  //           child: CircularProgressIndicator(),
  //         )
  //       : Scaffold(
  //           appBar: AppBar(
  //             title: Text("Add drills"),
  //           ),
  //           body: ListView.builder(
  //             itemCount: drills.length,
  //             itemBuilder: (BuildContext ctxt, int index) =>
  //                 _buildListTile(index),
  //           ),
  //           floatingActionButton: FloatingActionButton.extended(
  //               isExtended: true,
  //               label: Text("Add ${_selectedDrills.length} drills"),
  //               onPressed: () => {
  //                     if (_selectedDrills.isNotEmpty)
  //                       {
  //                         for (int i = 0; i < _selectedDrills.length; i++)
  //                           {
  //                             Provider.of<WorkoutProvider>(context,
  //                                     listen: false)
  //                                 .addDrills(drills[_selectedDrills[i]])
  //                           },
  //                         inspect(_selectedDrills),
  //                         Navigator.of(context).pop((context, drills))
  //                       }
  //                     else
  //                       {
  //                         showSnackBar(
  //                           context,
  //                           "select at least 1 drill",
  //                         )
  //                       }
  //                   }));

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

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

class AnimalScreen extends StatefulWidget {
  final String animalId;
  AnimalScreen(this.animalId);

  @override
  _AnimeScreenState createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimalScreen> {
  @override
  Widget build(BuildContext context) {
    String lol = widget.animalId;


    // DatabaseReference starCountRef =
    //         FirebaseDatabase.instance.reference().child('animals/${lol}');
    // starCountRef.onValue.listen((DatabaseEvent event) {
    //     final data = event.snapshot.value;
    //     updateStarCount(data);
    // });


    return Scaffold(
      body: Center(
        child:
          Column(
            children: [
                Row(
                  children: [
                    Text("Name:"),
                    Text(lol)
                  ],)              
            ],)
         ),
    )
}
}

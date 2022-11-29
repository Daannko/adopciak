import 'package:firebase_database/firebase_database.dart';
import 'package:expandable_text/expandable_text.dart';

import 'package:flutter/material.dart';
import 'package:adopciak/animal_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:adopciak/custom_snackbar';

class AnimalScreen extends StatefulWidget {
  final String animalId;
  AnimalScreen(this.animalId);

  @override
  _AnimeScreenState createState() => _AnimeScreenState();
}

class _AnimeScreenState extends State<AnimalScreen> {
  void updateAnimal(data) {}

  void initState() {
    super.initState();
  }

  //   getMarker() async {

  //   FirebaseDatabase firebaseDatabase = f
  //   const snapshot = await firebase.firestore().collection('events').get()
  //   return snapshot.docs.map(doc => doc.data());
  // }

  @override
  Widget build(BuildContext context) {
    CollectionReference animals =
        FirebaseFirestore.instance.collection('animals');

    bool expandedText = false;

    return Scaffold(
      body: Center(
          child: FutureBuilder<DocumentSnapshot>(
        future: animals.doc(widget.animalId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                leading: null,
                actions: <Widget>[],
                title: Text(data["Name"]),
                backgroundColor: Color.fromARGB(255, 112, 157, 179),
              ),
              body: Container(
                  color: Color.fromARGB(255, 189, 210, 217),
                  child: SingleChildScrollView(
                    child: Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        //// MOŻNA TO TUTAJ ZMIENĆ DLA WYGLĄDU
                        // color: Color.fromARGB(255, 86, 129, 143)
                      ),
                      child: Column(children: [
                        Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image(
                              image: AssetImage("images/dog.png"),
                            ),
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromARGB(255, 86, 129, 143)),
                          child: Text(
                            "Name: ${data["Name"]}",
                            style: TextStyle(fontSize: 20),
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromARGB(255, 86, 129, 143)),
                          child: Text(
                            "Breed: ${data["Breed"]}",
                            style: TextStyle(fontSize: 20),
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromARGB(255, 86, 129, 143)),
                          child: Text(
                            "Location: ${data["Location"]}",
                            style: TextStyle(fontSize: 20),
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromARGB(255, 86, 129, 143)),
                          child: Text(
                            "Owner: ${data["Owner"]}",
                            style: TextStyle(fontSize: 20),
                            maxLines: 2,
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          padding: EdgeInsets.all(7),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color.fromARGB(255, 86, 129, 143)),
                          child: Text(
                            "Info: ${data["Info"]}",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ]),
                    ),
                  )),
            );
          }
          return CircularProgressIndicator();
        },
      )),
    );
  }
}

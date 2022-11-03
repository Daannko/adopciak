import 'package:flutter/material.dart';
import 'my_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:adopciak/custom_snackbar';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("animals");
  late Stream<QuerySnapshot> animalStream;

  void initState() {
    super.initState();
    animalStream = collectionReference.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _auth.signOut();
                  Navigator.pop(context);

                  //Implement logout functionality
                }),
          ],
          title: Text('Home Page'),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: Container(
          color: Color.fromRGBO(38, 70, 83, 1),
          child: Center(
            child: StreamBuilder<QuerySnapshot>(
              stream: animalStream,
              builder: (BuildContextcontext, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                }
                if (snapshot.connectionState == ConnectionState.active) {
                  QuerySnapshot querySnapshot = snapshot.data;
                  List<QueryDocumentSnapshot> documents = querySnapshot.docs;

                  List<Map> items = documents
                      .map((e) => {
                            'age': e['Age'],
                            'name': e['Name'],
                            'breed': e['Breed'],
                            'owner': e['Owner']
                          })
                      .toList();

                  return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        Map thisItem = items[index];
                        return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          margin: EdgeInsets.fromLTRB(15, 20, 15, 0),
                          child: Column(
                            children: [
                              Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 3,
                                              color: Color.fromARGB(
                                                  255, 95, 181, 215)))),
                                  child: Container(
                                    margin: EdgeInsets.all(5),
                                    child: Text(
                                      thisItem['owner'],
                                      textAlign: TextAlign.center,
                                    ),
                                  )),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                width: double.infinity,
                                child: Text(
                                  thisItem['name'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 30,
                                  ),
                                ),
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  width: double.infinity,
                                  child: Image(
                                    image: AssetImage("images/dog.png"),
                                  )),
                              Container(
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: (() => {
                                              showSnackBar(
                                                  context,
                                                  "To jest ${thisItem['name']}!",
                                                  "Login")
                                            }),
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 20, 10),
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 48, 220, 217),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Text(
                                            "Wspomóż",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: (() => {
                                              showSnackBar(
                                                  context,
                                                  "To jest ${thisItem['name']}!",
                                                  "Login")
                                            }),
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 20, 10),
                                          decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 255, 160, 7),
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          child: Text(
                                            "Adoptiuj",
                                            style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black),
                                          ),
                                        ),
                                      )
                                    ]),
                              )
                            ],
                          ),
                        );
                      });
                } else
                  return Center(
                    child: CircularProgressIndicator(),
                  );
              },
            ),
          ),
        ));
  }
}

import 'package:adopciak/animal_screen.dart';
import 'package:adopciak/controllers/animal_image_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'my_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:adopciak/custom_snackbar';

import 'services/firebase_storage_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _auth = FirebaseAuth.instance;
  final FirebaseStorageService firebaseStorageSerivce =
      Get.put(FirebaseStorageService());
  final AnimalImageController animalImageController =
      Get.put(AnimalImageController());
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("animals");
  late Stream<QuerySnapshot> animalStream;

  void initState() {
    super.initState();
    animalStream = collectionReference.snapshots();
  }

  final borderSize = 1.5;

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
          backgroundColor: Color.fromARGB(255, 112, 157, 179),
        ),
        body: Container(
          color: Color.fromARGB(255, 189, 210, 217),
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
                            'id': e.id,
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
                        return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      AnimalScreen(thisItem['id'])));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Colors.black, width: borderSize),
                                  borderRadius: BorderRadius.circular(35)),
                              margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                              child: Column(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: borderSize,
                                                  color: Colors.black))),
                                      child: Container(
                                        margin: EdgeInsets.all(10),
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
                                  FutureBuilder(
                                      future: firebaseStorageSerivce
                                          .getImage("dog.png"),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<String?> snapshot) {
                                        if (snapshot.connectionState ==
                                                ConnectionState.done &&
                                            snapshot.hasData) {
                                          return Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  20, 10, 20, 10),
                                              width: double.infinity,
                                              child: Image.network(
                                                  snapshot.data!));
                                        }
                                        if (snapshot.connectionState ==
                                                ConnectionState.waiting ||
                                            !snapshot.hasData) {
                                          return CircularProgressIndicator();
                                        }
                                        return Container();
                                      }),
                                  Container(
                                    child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
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
                                                      BorderRadius.circular(
                                                          30)),
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
                                                      BorderRadius.circular(
                                                          30)),
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
                            ));
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

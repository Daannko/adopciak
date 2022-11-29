import 'package:adopciak/animal_screen.dart';
import 'package:adopciak/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'model/colors.dart';
import 'model/styles.dart';
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
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("animals");
  late Stream<QuerySnapshot> animalStream;
  final myController = TextEditingController();

  List<String?> imagePath = [];
  List<Image> images = [];
  bool displayList = false;

  void initState() {
    super.initState();
    animalStream = collectionReference.snapshots();
    myController.addListener(changeData);

    final db = FirebaseFirestore.instance;
    db.collection("animals").get().then(((value) async {
      for (int i = 0; i < value.size; i++) {
        imagePath.add(await firebaseStorageSerivce
            .getImage(value.docs[i].data()["imageName"].toString()));
      }
      for (int i = 0; i < imagePath.length; i++) {
        images.add(Image.network(imagePath[i]!));
      }
      setState(() {
        displayList = true;
      });
    }));
  }

  void changeData() {
    setState(() {});
  }

  final borderSize = 1.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      color: CustomColors.homePageBackgroundColor,
      child: Center(
        child: Column(
          children: [
            Flexible(
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

                    return displayList
                        ? ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              Map thisItem = items[index];
                              return
                                  // thisItem["name"]
                                  //         .toString()
                                  //         .toLowerCase()
                                  //         .contains(myController.text.toLowerCase())
                                  //     ?
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AnimalScreen(
                                                        thisItem['id'])));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color: Colors.black,
                                                width: borderSize),
                                            borderRadius: CustomStyles
                                                .radiusAnimalScreen),
                                        margin: CustomStyles.marigin20,
                                        child: Column(
                                          children: [
                                            Container(
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        bottom: BorderSide(
                                                            width: borderSize,
                                                            color:
                                                                Colors.black))),
                                                child: Container(
                                                  margin:
                                                      CustomStyles.paddingAll10,
                                                  child: Text(
                                                    thisItem['owner'],
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )),
                                            Container(
                                              padding: CustomStyles
                                                  .listViewPaddingName,
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
                                                padding: CustomStyles
                                                    .listViewPadding,
                                                width: double.infinity,
                                                child: images[index]),
                                            Container(
                                              child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    TextButton(
                                                      onPressed: (() => {
                                                            showSnackBar(
                                                                context,
                                                                "To jest ${thisItem['name']}!",
                                                                "Login")
                                                          }),
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                20, 10, 20, 10),
                                                        decoration: BoxDecoration(
                                                            color: Colors.amber,
                                                            borderRadius:
                                                                CustomStyles
                                                                    .radius30),
                                                        child: Text(
                                                          "Wspomóż",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
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
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                20, 10, 20, 10),
                                                        decoration: BoxDecoration(
                                                            color: CustomColors
                                                                .adoptBtnColor,
                                                            borderRadius:
                                                                CustomStyles
                                                                    .radius30),
                                                        child: Text(
                                                          "Adoptiuj",
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              color:
                                                                  Colors.black),
                                                        ),
                                                      ),
                                                    )
                                                  ]),
                                            )
                                          ],
                                        ),
                                      ));
                              //: Container();
                            })
                        : Center(child: CircularProgressIndicator());
                  } else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

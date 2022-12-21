import 'dart:core';

import 'package:adopciak/animal_screen.dart';
import 'package:adopciak/widgets/search_bar.dart';
import 'package:adopciak/widgets/support_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'add_animal_screen.dart';
import 'model/animal.dart';
import 'model/colors.dart';
import 'model/styles.dart';
import 'my_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import 'services/firebase_storage_service.dart';

class SupportScreen extends StatefulWidget {
  Function refresh = () => {};
  final Function(int) setToRefresh;
  SupportScreen({Key? key, required this.setToRefresh}) : super(key: key);

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  final _auth = FirebaseAuth.instance;
  final FirebaseStorageService firebaseStorageSerivce =
      Get.put(FirebaseStorageService());
  CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("animals");
  late Stream<QuerySnapshot> animalStream;
  final myController = TextEditingController();
  List<Animal> animals = [];
  List<String?> imagePath = [];
  List<Image> images = [];
  bool displayList = false;

  void initState() {
    super.initState();
    widget.refresh = getDatabaseData;
    myController.addListener(changeData);
    getDatabaseData();
  }

  void getDatabaseData() {
    setState(() {
      displayList = false;
      animals = [];
      images = [];
    });

    final db = FirebaseFirestore.instance;
    db
        .collection("animals")
        .where("SupportedBy", arrayContains: _auth.currentUser!.uid)
        .get()
        .then(((value) async {
      for (int i = 0; i < value.size; i++) {
        final data = value.docs[i].data();

        animals.add(Animal(
            data["Id"],
            data["Age"],
            data["Breed"],
            data["Name"],
            data["Info"],
            data["Location"],
            data["Owner"],
            data["OwnerId"],
            data["Type"],
            data["ImageName"],
            data["OffertType"],
            data["DateStart"],
            data["DateEnd"],
            data["Visible"]));
        // print(data["Type"]);
        // print(filterNames.contains(data["Type"]));

        String? path =
            await firebaseStorageSerivce.getImage(data["ImageName"].toString());
        images.add(Image.network(path!));
      }
      setState(() {
        displayList = true;
      });
    }));
  }

  void changeData() {
    setState(() {});
  }

  void modifySupport(int amount, String userUid, String animalUid) {
    final db = FirebaseFirestore.instance;
    db
        .collection("supports")
        .where("AnimalUid", isEqualTo: animalUid)
        .where("UserUid", isEqualTo: userUid)
        .get()
        .then((value) => {
              db
                  .collection("supports")
                  .doc(value.docs[0].id)
                  .update({"Amount": amount})
            });
  }

  void endSupport(String userUid, String animalUid) {
    final db = FirebaseFirestore.instance;
    db
        .collection("supports")
        .where("AnimalUid", isEqualTo: animalUid)
        .where("UserUid", isEqualTo: userUid)
        .get()
        .then((value) =>
            {db.collection("supports").doc(value.docs[0].id).delete()});

    FirebaseFirestore.instance.collection("users").doc(userUid).update({
      "Supports": FieldValue.arrayRemove([animalUid])
    });
    FirebaseFirestore.instance.collection("animals").doc(animalUid).update({
      "SupportedBy": FieldValue.arrayRemove([userUid])
    });
    getDatabaseData();
    widget.setToRefresh(0);
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
                child: displayList
                    ? ListView.builder(
                        itemCount: animals.length,
                        itemBuilder: (BuildContext context, int index) {
                          Animal thisItem = animals[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      AnimalScreen(thisItem.uId)));
                            },
                            child: Container(
                              //Cały ten śmieszny box
                              decoration: BoxDecoration(
                                  color: CustomColors.homeScreenAnimalBoxColor,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                    ),
                                  ],
                                  borderRadius:
                                      CustomStyles.radiusAnimalScreen),
                              margin: CustomStyles.marginAnimal,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: ClipRRect(
                                            borderRadius:
                                                CustomStyles.radiusAnimalPhoto,

                                            // margin: CustomStyles
                                            //     .marginAnimalPhoto,
                                            child: images[index]),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          children: [
                                            Text(
                                              thisItem.owner,
                                            ),
                                            Text(
                                              thisItem.name,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: SupportDialogButton(
                                          onSupportAccept: (value) {
                                            modifySupport(
                                                value,
                                                _auth.currentUser!.uid,
                                                thisItem.uId);
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                            height: 40,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: CustomColors.thirdColor,
                                              borderRadius:
                                                  CustomStyles.radiusAdoptuj,
                                            ),
                                            child: TextButton(
                                              onPressed: () => endSupport(
                                                  _auth.currentUser!.uid,
                                                  thisItem.uId),
                                              child: Text("Stop supporting",
                                                  style: TextStyle(
                                                      fontSize: CustomStyles
                                                          .fontListView,
                                                      color: Colors.black)),
                                            )),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        })
                    : Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    ));
  }
}

import 'dart:core';

import 'package:adopciak/animal_screen.dart';
import 'package:adopciak/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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

class MyAnimals extends StatefulWidget {
  Function refresh = () => {};
  final Function(int) setToRefresh;
  MyAnimals({Key? key, required this.setToRefresh}) : super(key: key);
  @override
  _MyAnimalsState createState() => _MyAnimalsState();
}

class _MyAnimalsState extends State<MyAnimals> {
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
  final List<String> filterNames = ["cat", "dog", "other"];
  List<bool> filterValues = [true, true, true];

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
    db.collection("animals").get().then(((value) async {
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
            data["OfferType"],
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

  Future<void> updateVisibility(Animal animal) async {
    animal.visible = !animal.visible;

    var collection = FirebaseFirestore.instance.collection('animals');
    collection
        .doc(animal.uId) // <-- Doc ID where data should be updated.
        .update(animal.returnMap())
        .then((value) => {changeData()});
    widget.setToRefresh(0);
    widget.setToRefresh(1);
  }

  void changeData() {
    setState(() {});
  }

  final borderSize = 1.5;

  String searchText = "";

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
                          return thisItem.ownerUId
                                  .contains(_auth.currentUser!.uid.toString())
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AnimalScreen(thisItem.uId)));
                                  },
                                  child: Container(
                                    //Ca??y ten ??mieszny box
                                    decoration: BoxDecoration(
                                        color: CustomColors
                                            .homeScreenAnimalBoxColor,
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
                                                  borderRadius: CustomStyles
                                                      .radiusAnimalPhoto,

                                                  // margin: CustomStyles
                                                  //     .marginAnimalPhoto,
                                                  child: images[index]),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            thisItem.name,
                                                            style: TextStyle(
                                                                fontSize: 17,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle:
                                                                    FontStyle
                                                                        .italic),
                                                            maxLines: CustomStyles
                                                                .animalScreenMaxLines,
                                                          ),
                                                        ),
                                                      ),
                                                      Icon(Icons.person,
                                                          color: CustomColors
                                                              .fourthColor),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        flex: 1,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Text(
                                                            thisItem.visible
                                                                ? "Visible"
                                                                : "Hidden",
                                                            style: TextStyle(
                                                                fontSize: 15),
                                                            maxLines: CustomStyles
                                                                .animalScreenMaxLines,
                                                          ),
                                                        ),
                                                      ),
                                                      Icon(
                                                          Icons
                                                              .remove_red_eye_outlined,
                                                          color: CustomColors
                                                              .fourthColor),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 40,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: CustomColors.fourthColor,
                                            borderRadius:
                                                CustomStyles.radiusAdoptuj,
                                          ),
                                          child: TextButton(
                                            onPressed: () => updateVisibility(
                                                animals[index]),
                                            child: Text(
                                              animals[index].visible
                                                  ? "Hide"
                                                  : "Show",
                                              style: TextStyle(
                                                  fontSize:
                                                      CustomStyles.fontListView,
                                                  color: animals[index].visible
                                                      ? Colors.black
                                                      : Colors.black),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Container();
                        })
                    : Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    ));
  }
}

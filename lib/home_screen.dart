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
  List<Animal> animals = [];
  List<String?> imagePath = [];
  List<Image> images = [];
  bool displayList = false;
  final List<String> filterNames = ["cat", "dog", "other"];
  List<bool> filterValues = [true, true, true];

  void initState() {
    super.initState();
    myController.addListener(changeData);

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
            SearchBar(
              filterNames: filterNames,
              filterValues: filterValues,
              onSelectedFiltersAnimalsChanged: (value) {
                setState(() {
                  filterValues = value;
                });
              },
              onTextChanged: (value) {
                searchText = value;
                setState(() {});
              },
            ),
            Flexible(
                child: displayList
                    ? ListView.builder(
                        itemCount: animals.length,
                        itemBuilder: (BuildContext context, int index) {
                          Animal thisItem = animals[index];
                          return thisItem.name
                                      .toLowerCase()
                                      .contains(searchText.toLowerCase()) &&
                                  filterValues[filterNames.indexOf(
                                      thisItem.type.toString().toLowerCase())]
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AnimalScreen(thisItem.uId)));
                                  },
                                  child: Container(
                                    //Cały ten śmieszny box
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
                                        Container(
                                          height: 40,
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: CustomColors.fourthColor,
                                            borderRadius:
                                                CustomStyles.radiusAdoptuj,
                                          ),
                                          child: TextButton(
                                            onPressed: (() => {}),
                                            child: Text(
                                              "Wspomóż",
                                              style: TextStyle(
                                                  fontSize:
                                                      CustomStyles.fontListView,
                                                  color: Colors.black),
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

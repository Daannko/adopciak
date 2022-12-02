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
  List<Animal> animals = [];
  List<String?> imagePath = [];
  List<Image> images = [];
  bool displayList = false;

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
            data["imageName"]));

        String? path =
            await firebaseStorageSerivce.getImage(data["imageName"].toString());
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

  String text = "";
  final List<String> filterNames = ["kot", "h", "pies"];
  List<bool> filterValues = [true, true, true];

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
                text = value;
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
                                      .contains(text.toLowerCase()) &&
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
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 2,
                                            blurRadius: 4,
                                            offset: Offset(0,
                                                3), // changes position of shadow
                                          ),
                                        ],
                                        borderRadius:
                                            CustomStyles.radiusAnimalScreen),
                                    margin: CustomStyles.mariginAnimal,
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
                                              margin: CustomStyles.paddingAll10,
                                              child: Text(
                                                thisItem.owner,
                                                textAlign: TextAlign.center,
                                              ),
                                            )),
                                        Container(
                                          padding:
                                              CustomStyles.listViewPaddingName,
                                          width: double.infinity,
                                          child: Text(
                                            thisItem.name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize:
                                                  CustomStyles.fontListViewName,
                                            ),
                                          ),
                                        ),
                                        Container(
                                            padding:
                                                CustomStyles.listViewPadding,
                                            width: double.infinity,
                                            child: images[index]),
                                        Container(
                                          child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                TextButton(
                                                  onPressed: (() => {}),
                                                  child: Container(
                                                    padding: CustomStyles
                                                        .listViewPadding,
                                                    decoration: BoxDecoration(
                                                        color: CustomColors
                                                            .thirdColor,
                                                        borderRadius:
                                                            CustomStyles
                                                                .radius30),
                                                    child: Text(
                                                      "Wspomóż",
                                                      style: TextStyle(
                                                          fontSize: CustomStyles
                                                              .fontListView,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: (() =>
                                                      showDialog<String>(
                                                        context: context,
                                                        builder: (BuildContext
                                                                context) =>
                                                            AlertDialog(
                                                          title: Text(
                                                              'Czy na pewno chcesz adoptować ${thisItem.name}'),
                                                          content: const Text(
                                                              'AlertDialog description'),
                                                          actions: <Widget>[
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      'Cancel'),
                                                              child: const Text(
                                                                  'nie'),
                                                            ),
                                                            TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context,
                                                                      'OK'),
                                                              child: const Text(
                                                                  'tak'),
                                                            ),
                                                          ],
                                                        ),
                                                      )),
                                                  child: Container(
                                                    padding: CustomStyles
                                                        .listViewPadding,
                                                    decoration: BoxDecoration(
                                                        color: CustomColors
                                                            .adoptBtnColor,
                                                        borderRadius:
                                                            CustomStyles
                                                                .radius30),
                                                    child: Text(
                                                      "Adoptiuj",
                                                      style: TextStyle(
                                                          fontSize: CustomStyles
                                                              .fontListView,
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                )
                                              ]),
                                        )
                                      ],
                                    ),
                                  ))
                              : Container();
                        })
                    : Center(child: CircularProgressIndicator())),
          ],
        ),
      ),
    ));
  }
}

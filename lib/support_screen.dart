import 'dart:core';

import 'package:adopciak/animal_screen.dart';
import 'package:adopciak/widgets/search_bar.dart';
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
import 'package:adopciak/custom_snackbar';

import 'services/firebase_storage_service.dart';

class SupportScreen extends StatefulWidget {
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
    myController.addListener(changeData);

    final db = FirebaseFirestore.instance;

    final User? user = _auth.currentUser;
    final uid = user!.uid;

    db
        .collection("animals")
        .where('SupportedBy', arrayContains: uid)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddAnimalScreen()));
          },
          child: const Icon(Icons.add),
        ),
        body: Container(
          color: CustomColors.homePageBackgroundColor,
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: myController,
                ),
                Flexible(
                    child: displayList
                        ? ListView.builder(
                            itemCount: animals.length,
                            itemBuilder: (BuildContext context, int index) {
                              Animal thisItem = animals[index];
                              return thisItem.name
                                      .toString()
                                      .toLowerCase()
                                      .contains(myController.text.toLowerCase())
                                  ? GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    AnimalScreen(
                                                        thisItem.uId)));
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
                                                    thisItem.owner,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )),
                                            Container(
                                              padding: CustomStyles
                                                  .listViewPaddingName,
                                              width: double.infinity,
                                              child: Text(
                                                thisItem.name,
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: CustomStyles
                                                      .fontListViewName,
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
                                                      onPressed: (() => {}),
                                                      child: Container(
                                                        padding: CustomStyles
                                                            .listViewPadding,
                                                        decoration: BoxDecoration(
                                                            color: Colors.amber,
                                                            borderRadius:
                                                                CustomStyles
                                                                    .radius30),
                                                        child: Text(
                                                          "Wspomóż",
                                                          style: TextStyle(
                                                              fontSize: CustomStyles
                                                                  .fontListView,
                                                              color:
                                                                  Colors.black),
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
                                                                  child:
                                                                      const Text(
                                                                          'nie'),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () =>
                                                                      Navigator.pop(
                                                                          context,
                                                                          'OK'),
                                                                  child:
                                                                      const Text(
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
                                                              color:
                                                                  Colors.black),
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

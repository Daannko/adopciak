import 'dart:core';

import 'package:adopciak/animal_screen.dart';
import 'package:adopciak/widgets/plain_dialog.dart';
import 'package:adopciak/model/support.dart';
import 'package:adopciak/widgets/search_bar.dart';
import 'package:adopciak/widgets/support_dialog.dart';
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
  Function refresh = () => {};
  final Function(int) setToRefresh;
  HomeScreen({Key? key, required this.setToRefresh}) : super(key: key);
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
    List supportedList = [];
    db.collection("users").doc(_auth.currentUser!.uid).get().then((value) {
      final data = value.data();
      supportedList = data!["Supports"];
    });

    db.collection("animals").get().then(((value) async {
      for (int i = 0; i < value.size; i++) {
        final data = value.docs[i].data();

        if (supportedList.contains(data["Id"])) continue;
        if (data["Visible"] == true) {
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

          String? path = await firebaseStorageSerivce
              .getImage(data["ImageName"].toString());
          images.add(Image.network(path!));
        }
      }

      setState(() {
        displayList = true;
      });
    }));
  }

  void changeData() {
    setState(() {});
  }

  void supportAnimal(int amount, String userUid, String animalUid) {
    Support support = Support(amount, userUid, animalUid);
    FirebaseFirestore.instance.collection("supports").add(support.returnMap());
    FirebaseFirestore.instance.collection("users").doc(userUid).update({
      "Supports": FieldValue.arrayUnion([animalUid])
    });
    FirebaseFirestore.instance.collection("animals").doc(animalUid).update({
      "SupportedBy": FieldValue.arrayUnion([userUid])
    });
    widget.setToRefresh(1);
    getDatabaseData();
  }

  final borderSize = 1.5;

  String searchText = "";

  Future<void> adopt(BuildContext context, Animal anml) async {
    final usr = await FirebaseFirestore.instance
        .collection('users')
        .doc(anml.ownerUId)
        .get();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adopt a pet'),
          content: Container(
            alignment: Alignment.centerLeft,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("To adopt a pet please contact: "),
                Text("Name: ${anml.owner}"),
                Text("Tel: ${usr.id}")
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> adoptForAPeriod(BuildContext context, Animal anml) async {
    final usr = await FirebaseFirestore.instance
        .collection('users')
        .doc(anml.ownerUId)
        .get();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adopt a pet'),
          content: Container(
            alignment: Alignment.centerLeft,
            height: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("To adopt a pet please contact: "),
                Text("Name: ${anml.owner}"),
                Text("Tel: ${usr.id}"),
                Text("Adoption time: ${anml.dateStart} - ${anml.dateEnd}")
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void support(Animal anml) {
    print("Support");
  }

  void takeAction(Animal anml) {
    String type = anml.offerType;
    switch (type) {
      case 'Adopt':
        adopt(context, anml);
        break;
      case 'Adopt for period of time':
        adoptForAPeriod(context, anml);
        break;
      case 'Support':
        support(anml);
        break;
      default:
        print("NIGGERR takeAction in home_screen");
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    animals.forEach((element) {
      print(element.offerType);
    });
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
                                            onPressed: () {
                                              takeAction(thisItem);
                                            },
                                            child: thisItem.offerType
                                                    .toString()
                                                    .contains("Support")
                                                ? SupportDialogButton(
                                                    onSupportAccept: (value) {
                                                      supportAnimal(
                                                          value,
                                                          _auth
                                                              .currentUser!.uid,
                                                          thisItem.uId);
                                                    },
                                                  )
                                                : Text(
                                                    thisItem.offerType
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: CustomStyles
                                                            .fontListView,
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

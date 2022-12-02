// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:adopciak/services/firebase_upload_image_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adopciak/custom_snackbar';
import 'package:uuid/uuid.dart';

import 'model/animal.dart';
import 'model/colors.dart';
import 'model/styles.dart';

import 'model/styles.dart';

class AddAnimalScreen extends StatefulWidget {
  @override
  _AddAnimalScreenStatus createState() => _AddAnimalScreenStatus();
}

class _AddAnimalScreenStatus extends State<AddAnimalScreen> {
  final _auth = FirebaseAuth.instance;
  String name = "";
  int age = 0;
  String type = "";
  String breed = "";
  String owner = "";
  String location = "";
  String info = "";
  String errorMessage = "";
  bool showSpinner = false;
  bool displaySet1 = true;
  bool displaySet2 = false;
  bool displayImageUpload = false;
  var uuid = Uuid();
  late String animalUId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animalUId = uuid.v4();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("Dodaj informacje o zwierzaku:",
                      style: TextStyle(
                          fontSize: CustomStyles.enterToRegisterSize)),
                  SizedBox(height: CustomStyles.enterToRegisterSize),
                  displaySet1
                      ? TextField(
                          keyboardType: TextInputType.name,
                          textAlign: TextAlign.center,
                          controller: name.isNotEmpty
                              ? TextEditingController(text: name)
                              : TextEditingController(text: ""),
                          onChanged: (value) {
                            name = value;
                            //Do something with the user input.
                          },
                          decoration: InputDecoration(
                              hintText: 'Name',
                              contentPadding: CustomStyles.marginsAll20,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.inputTextBorderColor,
                                      width: CustomStyles.width)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors
                                          .selectedInputTextBorderColor,
                                      width: CustomStyles.width))),
                        )
                      : new Container(),
                  SizedBox(
                    height: CustomStyles.smallBoxHeight,
                  ),
                  displaySet1
                      ? TextField(
                          keyboardType: TextInputType.emailAddress,
                          textAlign: TextAlign.center,
                          controller: type.isNotEmpty
                              ? TextEditingController(text: type)
                              : TextEditingController(text: ""),
                          onChanged: (value) {
                            type = value;
                            //Do something with the user input.
                          },
                          decoration: InputDecoration(
                              hintText: 'Type',
                              contentPadding: CustomStyles.marginsAll20,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.inputTextBorderColor,
                                      width: CustomStyles.width)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors
                                          .selectedInputTextBorderColor,
                                      width: CustomStyles.width))),
                        )
                      : new Container(),
                  SizedBox(
                    height: CustomStyles.smallBoxHeight,
                  ),
                  displaySet1
                      ? TextField(
                          textAlign: TextAlign.center,
                          controller: breed.isNotEmpty
                              ? TextEditingController(text: breed)
                              : TextEditingController(text: ""),
                          onChanged: (value) {
                            breed = value;
                            //Do something with the user input.
                          },
                          decoration: InputDecoration(
                              hintText: 'Breed',
                              contentPadding: CustomStyles.marginsAll20,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.inputTextBorderColor,
                                      width: CustomStyles.width)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors
                                          .selectedInputTextBorderColor,
                                      width: CustomStyles.width))),
                        )
                      : new Container(),
                  SizedBox(
                    height: CustomStyles.smallBoxHeight,
                  ),
                  displaySet1
                      ? TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: CustomColors.addAnimalColor),
                          child: Text('Następna strona',
                              style:
                                  TextStyle(fontSize: CustomStyles.fontSize40)),
                          onPressed: () async {
                            if (name.isNotEmpty &&
                                breed.isNotEmpty &&
                                type.isNotEmpty) {
                              setState(() {
                                displaySet1 = false;
                                displaySet2 = true;
                              });
                            }
                          },
                        )
                      : new Container(),
                  displaySet2
                      ? TextField(
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          controller: age.toString().isNotEmpty
                              ? TextEditingController(text: age.toString())
                              : TextEditingController(text: ""),
                          onChanged: (value) {
                            age = int.parse(value);
                            //Do something with the user input.
                          },
                          decoration: InputDecoration(
                              hintText: 'Age',
                              contentPadding: CustomStyles.marginsAll20,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.inputTextBorderColor,
                                      width: CustomStyles.width)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors
                                          .selectedInputTextBorderColor,
                                      width: CustomStyles.width))),
                        )
                      : new Container(),
                  SizedBox(
                    height: CustomStyles.smallBoxHeight,
                  ),
                  displaySet2
                      ? TextField(
                          textAlign: TextAlign.center,
                          controller: owner.isNotEmpty
                              ? TextEditingController(text: owner)
                              : TextEditingController(text: ""),
                          onChanged: (value) {
                            owner = value;
                            //Do something with the user input.
                          },
                          decoration: InputDecoration(
                              hintText: 'Owner',
                              contentPadding: CustomStyles.marginsAll20,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.inputTextBorderColor,
                                      width: CustomStyles.width)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors
                                          .selectedInputTextBorderColor,
                                      width: CustomStyles.width))),
                        )
                      : new Container(),
                  SizedBox(
                    height: CustomStyles.smallBoxHeight,
                  ),
                  displaySet2
                      ? TextField(
                          textAlign: TextAlign.center,
                          controller: location.isNotEmpty
                              ? TextEditingController(text: location)
                              : TextEditingController(text: ""),
                          onChanged: (value) {
                            location = value;
                            //Do something with the user input.
                          },
                          decoration: InputDecoration(
                              hintText: 'Location',
                              contentPadding: CustomStyles.marginsAll20,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.inputTextBorderColor,
                                      width: CustomStyles.width)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors
                                          .selectedInputTextBorderColor,
                                      width: CustomStyles.width))),
                        )
                      : new Container(),
                  SizedBox(
                    height: CustomStyles.smallBoxHeight,
                  ),
                  displaySet2
                      ? TextField(
                          textAlign: TextAlign.center,
                          controller: info.isNotEmpty
                              ? TextEditingController(text: info)
                              : TextEditingController(text: ""),
                          onChanged: (value) {
                            info = value;
                            //Do something with the user input.
                          },
                          decoration: InputDecoration(
                              hintText: 'Info',
                              contentPadding: CustomStyles.marginsAll20,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors.inputTextBorderColor,
                                      width: CustomStyles.width)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: CustomColors
                                          .selectedInputTextBorderColor,
                                      width: CustomStyles.width))),
                        )
                      : new Container(),
                  SizedBox(
                    height: CustomStyles.bigBoxHeight,
                  ),
                  displaySet2
                      ? TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: CustomColors.addAnimalColor),
                          child: Text('Następna strona',
                              style: TextStyle(
                                fontSize: CustomStyles.fontSize40,
                              )),
                          onPressed: () async {
                            if (age.toString().isNotEmpty &&
                                owner.isNotEmpty &&
                                location.isNotEmpty &&
                                info.isNotEmpty) {
                              setState(() {
                                displaySet2 = false;
                                displayImageUpload = true;
                              });
                            }
                          },
                        )
                      : new Container(),
                  displaySet2
                      ? TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: CustomColors.addAnimalColor),
                          child: Text('Poprzednia strona',
                              style:
                                  TextStyle(fontSize: CustomStyles.fontSize40)),
                          onPressed: () async {
                            setState(() {
                              displaySet1 = true;
                              displaySet2 = false;
                            });
                          },
                        )
                      : new Container(),
                  SizedBox(
                    height: CustomStyles.smallBoxHeight,
                  ),
                  displayImageUpload
                      ? Container(
                          color: CustomColors.appBarColor,
                          child: ImageUploads(path: animalUId))
                      : new Container(),
                  displayImageUpload
                      ? TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: CustomColors.addAnimalColor),
                          child: Text('Dodaj zwierzaka ',
                              style:
                                  TextStyle(fontSize: CustomStyles.fontSize40)),
                          onPressed: () async {
                            setState(() {
                              showSpinner = true;
                            });

                            FocusManager.instance.primaryFocus?.unfocus();

                            String? userUId = FirebaseAuth
                                .instance.currentUser?.uid
                                .toString();

                            Animal animal = Animal(
                                animalUId,
                                age,
                                breed,
                                name,
                                info,
                                location,
                                owner,
                                userUId!,
                                type,
                                animalUId);

                            FirebaseFirestore.instance
                                .collection("animals")
                                .doc(animalUId)
                                .set(animal.returnMap());

                            Navigator.pushNamed(context, 'navbar_screen');

                            if (errorMessage.isNotEmpty) errorMessage = "";
                            setState(() {
                              showSpinner = false;
                            });
                          },
                        )
                      : new Container(),
                  displayImageUpload
                      ? TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: CustomColors.addAnimalColor),
                          child: Text('Poprzednia strona',
                              style:
                                  TextStyle(fontSize: CustomStyles.fontSize40)),
                          onPressed: () async {
                            setState(() {
                              displaySet2 = true;
                              displayImageUpload = false;
                            });
                          },
                        )
                      : new Container()
                ]),
          ),
        ),
      ),
    );
  }
}

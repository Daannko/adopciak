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
  String offertType = "";
  String dateStart = "";
  String dateEnd = "";
  bool showSpinner = false;
  bool displaySet1 = true;
  bool displaySet2 = false;
  bool displayImageUpload = false;
  var uuid = Uuid();
  late String animalUId;
  final List<String> list = <String>['One', 'Two', 'Three', 'Four'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animalUId = uuid.v4();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height - // total height
                  kToolbarHeight - // top AppBar height
                  MediaQuery.of(context).padding.top - // top padding
                  kBottomNavigationBarHeight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(CustomStyles.addAnimalTitle,
                      style: TextStyle(
                          fontSize: CustomStyles.enterToRegisterSize)),
                  displaySet1
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                              SizedBox(
                                  height: CustomStyles.enterToRegisterSize),
                              TextField(
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
                                            color: CustomColors
                                                .inputTextBorderColor,
                                            width: CustomStyles.width)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors
                                                .selectedInputTextBorderColor,
                                            width: CustomStyles.width))),
                              ),
                              SizedBox(
                                height: CustomStyles.smallBoxHeight,
                              ),
                              TextField(
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
                                            color: CustomColors
                                                .inputTextBorderColor,
                                            width: CustomStyles.width)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors
                                                .selectedInputTextBorderColor,
                                            width: CustomStyles.width))),
                              ),
                              SizedBox(
                                height: CustomStyles.smallBoxHeight,
                              ),
                              TextField(
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
                                            color: CustomColors
                                                .inputTextBorderColor,
                                            width: CustomStyles.width)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors
                                                .selectedInputTextBorderColor,
                                            width: CustomStyles.width))),
                              ),
                              SizedBox(
                                height: CustomStyles.smallBoxHeight,
                              ),
                              TextField(
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                controller: age.toString().isNotEmpty
                                    ? TextEditingController(
                                        text: age.toString())
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
                                            color: CustomColors
                                                .inputTextBorderColor,
                                            width: CustomStyles.width)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: CustomColors
                                                .selectedInputTextBorderColor,
                                            width: CustomStyles.width))),
                              )
                            ])
                      : displaySet2
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  SizedBox(
                                      height: CustomStyles.enterToRegisterSize),
                                  TextField(
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
                                        contentPadding:
                                            CustomStyles.marginsAll20,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .inputTextBorderColor,
                                                width: CustomStyles.width)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .selectedInputTextBorderColor,
                                                width: CustomStyles.width))),
                                  ),
                                  SizedBox(
                                    height: CustomStyles.smallBoxHeight,
                                  ),
                                  TextField(
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
                                        contentPadding:
                                            CustomStyles.marginsAll20,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .inputTextBorderColor,
                                                width: CustomStyles.width)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .selectedInputTextBorderColor,
                                                width: CustomStyles.width))),
                                  ),
                                  SizedBox(
                                    height: CustomStyles.smallBoxHeight,
                                  ),
                                  TextField(
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
                                        contentPadding:
                                            CustomStyles.marginsAll20,
                                        enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .inputTextBorderColor,
                                                width: CustomStyles.width)),
                                        focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: CustomColors
                                                    .selectedInputTextBorderColor,
                                                width: CustomStyles.width))),
                                  )
                                ])
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                  SizedBox(
                                      height: CustomStyles.enterToRegisterSize),
                                  Container(
                                      color: CustomColors.appBarColor,
                                      child: ImageUploads(path: animalUId)),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            CustomColors.secondColor),
                                    child: Text(CustomStyles.addAnimal,
                                        style: TextStyle(
                                            fontSize: CustomStyles.fontSize40)),
                                    onPressed: () async {
                                      setState(() {
                                        showSpinner = true;
                                      });

                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

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
                                          animalUId,
                                          offertType,
                                          dateStart,
                                          dateEnd);

                                      FirebaseFirestore.instance
                                          .collection("animals")
                                          .doc(animalUId)
                                          .set(animal.returnMap());

                                      Navigator.pushNamed(
                                          context, 'navbar_screen');

                                      if (errorMessage.isNotEmpty)
                                        errorMessage = "";
                                      setState(() {
                                        showSpinner = false;
                                      });
                                    },
                                  ),
                                ]),
                  Row(children: [
                    SizedBox(
                      height: CustomStyles.bigBoxHeight,
                    ),
                  ]),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: CustomColors.secondColor),
                          child: Text(CustomStyles.previousPage,
                              style:
                                  TextStyle(fontSize: CustomStyles.fontSize40)),
                          onPressed: displaySet1 ? null : previousButton),
                      TextButton(
                          style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: CustomColors.secondColor),
                          child: Text(CustomStyles.nextPage,
                              style:
                                  TextStyle(fontSize: CustomStyles.fontSize40)),
                          onPressed: displayImageUpload ? null : nextButton)
                    ],
                  )
                  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void nextButton() async {
    if (age.toString().isNotEmpty &&
        name.isNotEmpty &&
        breed.isNotEmpty &&
        type.isNotEmpty &&
        displaySet1 == true) {
      setState(() {
        displaySet1 = false;
        displaySet2 = true;
      });
    } else if (owner.isNotEmpty &&
        location.isNotEmpty &&
        info.isNotEmpty &&
        displaySet1 == false) {
      setState(() {
        displaySet2 = false;
        displayImageUpload = true;
      });
    }
  }

  void previousButton() async {
    if (displaySet1 == false &&
        displaySet2 == true &&
        displayImageUpload == false) {
      displaySet2 = false;
      displaySet1 = true;
    }
    if (displayImageUpload == true && displaySet2 == false) {
      displayImageUpload = false;
      displaySet2 = true;
    }
    setState(() {});
  }
}

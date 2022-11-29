// ignore_for_file: non_constant_identifier_names

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adopciak/custom_snackbar';

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
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text("Enter information to add animal:",
                    style:
                        TextStyle(fontSize: CustomStyles.enterToRegisterSize)),
                SizedBox(height: CustomStyles.enterToRegisterSize),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    name = value;
                    //Do something with the user input.
                  },
                  decoration: InputDecoration(
                      hintText: 'Name',
                      contentPadding: CustomStyles.mariginsAll20,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.inputTextBorderColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.selectedInputTextBorderColor,
                              width: CustomStyles.width))),
                ),
                SizedBox(
                  height: CustomStyles.smallBoxHeight,
                ),
                TextField(
                  keyboardType: TextInputType.name,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    age = int.parse(value);
                    //Do something with the user input.
                  },
                  decoration: InputDecoration(
                      hintText: 'Age',
                      contentPadding: CustomStyles.mariginsAll20,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.inputTextBorderColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.selectedInputTextBorderColor,
                              width: CustomStyles.width))),
                ),
                SizedBox(
                  height: CustomStyles.smallBoxHeight,
                ),
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    type = value;
                    //Do something with the user input.
                  },
                  decoration: InputDecoration(
                      hintText: 'Type',
                      contentPadding: CustomStyles.mariginsAll20,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.inputTextBorderColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.selectedInputTextBorderColor,
                              width: CustomStyles.width))),
                ),
                SizedBox(
                  height: CustomStyles.smallBoxHeight,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    breed = value;
                    //Do something with the user input.
                  },
                  decoration: InputDecoration(
                      hintText: 'Breed',
                      contentPadding: CustomStyles.mariginsAll20,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.inputTextBorderColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.selectedInputTextBorderColor,
                              width: CustomStyles.width))),
                ),
                SizedBox(
                  height: CustomStyles.smallBoxHeight,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    owner = value;
                    //Do something with the user input.
                  },
                  decoration: InputDecoration(
                      hintText: 'Owner',
                      contentPadding: CustomStyles.mariginsAll20,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.inputTextBorderColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.selectedInputTextBorderColor,
                              width: CustomStyles.width))),
                ),
                SizedBox(
                  height: CustomStyles.smallBoxHeight,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    location = value;
                    //Do something with the user input.
                  },
                  decoration: InputDecoration(
                      hintText: 'Location',
                      contentPadding: CustomStyles.mariginsAll20,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.inputTextBorderColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.selectedInputTextBorderColor,
                              width: CustomStyles.width))),
                ),
                SizedBox(
                  height: CustomStyles.smallBoxHeight,
                ),
                TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    info = value;
                    //Do something with the user input.
                  },
                  decoration: InputDecoration(
                      hintText: 'Info',
                      contentPadding: CustomStyles.mariginsAll20,
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.inputTextBorderColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.selectedInputTextBorderColor,
                              width: CustomStyles.width))),
                ),
                SizedBox(
                  height: CustomStyles.bigBoxHeight,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: const Color.fromRGBO(38, 70, 83, 1)),
                  child: Text('Dodaj pieska ',
                      style: TextStyle(fontSize: CustomStyles.fontSize40)),
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    FocusManager.instance.primaryFocus?.unfocus();

                    final data = {
                      "Name": name,
                      "Age": age,
                      "Type": type,
                      "Breed": breed,
                      "Owner": owner,
                      "Location": location,
                      "Info": info,
                      "Supports": [],
                      "Needs": []
                      //TODO: ta tabela pewnie bedzie wypierdalać
                    };

                    FirebaseFirestore.instance
                        .collection("animals")
                        .doc()
                        .set(data);

                    showSnackBar(context, "Added new animal", "Login");
                    Navigator.pushNamed(context, 'home_screen');

                    if (errorMessage.isNotEmpty)
                      showSnackBar(context, errorMessage, "Error");

                    errorMessage = "";
                    setState(() {
                      showSpinner = false;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

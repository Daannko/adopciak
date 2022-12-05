// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:adopciak/model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'model/colors.dart';
import 'model/register_info.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  RegisterInfo registerInfo = RegisterInfo();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text("Enter to register:", style: TextStyle(fontSize: 30)),
              SizedBox(
                height: 30,
              ),
              TextField(
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  registerInfo.name = value;
                  //Do something with the user input.
                },
                decoration: InputDecoration(
                    hintText: 'Name',
                    contentPadding: EdgeInsets.all(20.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.inputTextBorderColor,
                            width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.selectedInputTextBorderColor,
                            width: 2))),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  registerInfo.surname = value;
                  //Do something with the user input.
                },
                decoration: InputDecoration(
                    hintText: 'Surname',
                    contentPadding: EdgeInsets.all(20.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.inputTextBorderColor,
                            width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.selectedInputTextBorderColor,
                            width: 2))),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  registerInfo.email = value;
                  //Do something with the user input.
                },
                decoration: InputDecoration(
                    hintText: 'Email Address',
                    contentPadding: EdgeInsets.all(20.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.inputTextBorderColor,
                            width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.selectedInputTextBorderColor,
                            width: 2))),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  registerInfo.password = value;
                  //Do something with the user input.
                },
                decoration: InputDecoration(
                    hintText: 'Password',
                    contentPadding: EdgeInsets.all(20.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.inputTextBorderColor,
                            width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.selectedInputTextBorderColor,
                            width: 2))),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  registerInfo.passwordTwo = value;
                  //Do something with the user input.
                },
                decoration: InputDecoration(
                    hintText: 'Confirm password',
                    contentPadding: EdgeInsets.all(20.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.inputTextBorderColor,
                            width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: CustomColors.selectedInputTextBorderColor,
                            width: 2))),
              ),
              const SizedBox(
                height: 40.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: CustomColors.selectedInputTextBorderColor),
                child: const Text('Register', style: TextStyle(fontSize: 40)),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (registerInfo.name.length < 2) {
                      throw new Exception("NameException");
                    }
                    if (registerInfo.password.length < 1) {
                      throw new FirebaseAuthException(code: "weak-password");
                    }
                    if (registerInfo.surname.length < 2) {
                      print(registerInfo.surname.toString());
                      throw new Exception("SurnameException");
                    }
                    if (registerInfo.password != registerInfo.passwordTwo) {
                      throw new Exception("PasswordsDontMatch");
                    }
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: registerInfo.email,
                        password: registerInfo.password);

                    if (newUser != null) {
                      String currentUserUid = newUser.user!.uid;
                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(currentUserUid)
                          .set(SaveUserData(registerInfo.name,
                                  registerInfo.surname, registerInfo.email)
                              .returnMap());

                      Navigator.pushNamed(context, 'home_screen');
                    }
                  } on FirebaseAuthException catch (e) {
                    switch (e.code) {
                      case "weak-password":
                        errorMessage =
                            "Password should be at least 6 characters";
                        break;
                      case "unknown":
                      case "invalid-email":
                        errorMessage = "Incorrect Email";
                        break;
                      case "network-request-failed":
                        errorMessage =
                            "Connection to internet lost, try again later";
                        break;
                      case "email-already-in-use":
                        errorMessage =
                            "The email address is already in use by another account.";
                        break;
                    }
                  } catch (e) {
                    switch (e.toString()) {
                      case "Exception: PasswordsDontMatch":
                        errorMessage = "Passwords dont match";
                        break;
                      case "Exception: NameException":
                        errorMessage =
                            "Name should have at least two characters";
                        break;
                      case "Exception: SurnameException":
                        errorMessage =
                            "Surname should have at least two characters";
                        break;
                    }
                  }

                  if (errorMessage.isNotEmpty) errorMessage = "";
                  setState(() {
                    showSpinner = false;
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

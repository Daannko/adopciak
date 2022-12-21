// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:adopciak/model/user_data.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'model/colors.dart';
import 'model/register_info.dart';
import 'model/styles.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  RegisterInfo registerInfo = RegisterInfo();
  String errorMessage = "";
  bool showSpinner = false;

  FToast fToast = FToast();

  @override
  Widget build(BuildContext context) {
    fToast.init(context);
    _showToast(String message) {
      Widget toast = Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: CustomColors.toastColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.not_interested_rounded),
            const SizedBox(
              width: 24.0,
            ),
            Text(message),
          ],
        ),
      );
      fToast.showToast(child: toast, gravity: ToastGravity.BOTTOM);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 70, 24, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Enter to register",
                    style: TextStyle(
                      fontSize: CustomStyles.enterToRegisterSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
                              color: CustomColors.thirdColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.fourthColor,
                              width: CustomStyles.width))),
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
                              color: CustomColors.thirdColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.fourthColor,
                              width: CustomStyles.width))),
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
                              color: CustomColors.thirdColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.fourthColor,
                              width: CustomStyles.width))),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    registerInfo.phoneNumber = value;
                    //Do something with the user input.
                  },
                  decoration: InputDecoration(
                      hintText: 'Phone Number',
                      contentPadding: EdgeInsets.all(20.0),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.thirdColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.fourthColor,
                              width: CustomStyles.width))),
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
                              color: CustomColors.thirdColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.fourthColor,
                              width: CustomStyles.width))),
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
                              color: CustomColors.thirdColor,
                              width: CustomStyles.width)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: CustomColors.fourthColor,
                              width: CustomStyles.width))),
                ),
                const SizedBox(
                  height: 40.0,
                ),
                TextButton(
                  style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: CustomColors.fourthColor),
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
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: registerInfo.email,
                              password: registerInfo.password);

                      if (newUser != null) {
                        String currentUserUid = newUser.user!.uid;
                        FirebaseFirestore.instance
                            .collection("users")
                            .doc(currentUserUid)
                            .set(SaveUserData(
                                    registerInfo.name,
                                    registerInfo.surname,
                                    registerInfo.email,
                                    registerInfo.phoneNumber.toString())
                                .returnMap());

                        Navigator.pushReplacementNamed(
                            context, 'navbar_screen');
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

                    if (errorMessage.isNotEmpty) {
                      _showToast(errorMessage);
                      errorMessage = "";
                    }
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

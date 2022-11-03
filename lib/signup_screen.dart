// ignore_for_file: non_constant_identifier_names

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adopciak/custom_snackbar';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;
  String email = "";
  String password = "";
  String passwordTwo = "";
  String name = "";
  String surname = "";
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
                  name = value;
                  //Do something with the user input.
                },
                decoration: const InputDecoration(
                    hintText: 'Name',
                    contentPadding: EdgeInsets.all(20.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(38, 70, 83, 0.5), width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(38, 70, 83, 1), width: 2))),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.name,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  surname = value;
                  //Do something with the user input.
                },
                decoration: const InputDecoration(
                    hintText: 'Surname',
                    contentPadding: EdgeInsets.all(20.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(38, 70, 83, 0.5), width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(38, 70, 83, 1), width: 2))),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                decoration: const InputDecoration(
                    hintText: 'Email Address',
                    contentPadding: EdgeInsets.all(20.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(38, 70, 83, 0.5), width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(38, 70, 83, 1), width: 2))),
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
                  password = value;
                  //Do something with the user input.
                },
                decoration: const InputDecoration(
                    hintText: 'Password',
                    contentPadding: EdgeInsets.all(20.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(38, 70, 83, 0.5), width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(38, 70, 83, 1), width: 2))),
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
                  passwordTwo = value;
                  //Do something with the user input.
                },
                decoration: const InputDecoration(
                    hintText: 'Confirm password',
                    contentPadding: EdgeInsets.all(20.0),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(38, 70, 83, 0.5), width: 2)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(38, 70, 83, 1), width: 2))),
              ),
              const SizedBox(
                height: 40.0,
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color.fromRGBO(38, 70, 83, 1)),
                child: const Text('Register', style: TextStyle(fontSize: 40)),
                onPressed: () async {
                  setState(() {
                    showSpinner = true;
                  });
                  try {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (name.length < 2) {
                      throw new Exception("NameException");
                    }
                    if (password.length < 1) {
                      throw new FirebaseAuthException(code: "weak-password");
                    }
                    if (surname.length < 2) {
                      print(surname.toString());
                      throw new Exception("SurnameException");
                    }
                    if (password != passwordTwo) {
                      throw new Exception("PasswordsDontMatch");
                    }
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);

                    if (newUser != null) {
                      final data = {
                        "Credits": 0,
                        "Name": name,
                        "Surname": surname,
                        "Supports": [],
                        "Email": email,
                        "UserID": newUser.user.uid
                      };

                      FirebaseFirestore.instance
                          .collection("users")
                          .doc(email)
                          .set(data);

                      showSnackBar(
                          context, "Welcome to Adopciak!", "Registered");
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
    );
  }
}

import 'package:adopciak/model/particles.dart';
import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:adopciak/custom_snackbar';
import 'package:adopciak/model/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/styles.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  String email = "testmail@mail.com";
  String password = "123456";
  bool showSpinner = false;
  String errorMessage = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: AnimatedBackground(
          vsync: this,
          behaviour: RandomParticleBehaviour(options: particles),
          child: Padding(
            padding: CustomStyles.paddingSymmetric,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                    //Do something with the user input.
                  },
                  decoration: InputDecoration(
                      hintText: 'Email',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: CustomStyles.paddingAll20,
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
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                    //Do something with the user input.
                  },
                  decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: CustomStyles.paddingAll20,
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
                        backgroundColor:
                            CustomColors.selectedInputTextBorderColor),
                    child: Text('Login',
                        style: TextStyle(fontSize: CustomStyles.fontSize40)),
                    onPressed: () async {
                      setState(() {
                        showSpinner = true;
                      });
                      try {
                        FocusManager.instance.primaryFocus?.unfocus();
                        final user = await _auth.signInWithEmailAndPassword(
                            email: email, password: password);
                        if (user != null) {
                          final user = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(email)
                              .get();
                          String name = user.get("Name");

                          final prefs = await SharedPreferences.getInstance();

                          await prefs.setString('UserID', user.get('UserID'));

                          Navigator.pushNamed(context, 'navbar_screen');
                        }
                      } on FirebaseAuthException catch (e) {
                        switch (e.code) {
                          case "unknown":
                            errorMessage = "Enter propper ";
                            if (email.isEmpty)
                              errorMessage += "email";
                            else
                              errorMessage += "password";
                            break;
                          case "invalid-email":
                            errorMessage = "Incorrect Email";
                            break;
                          case "network-request-failed":
                            errorMessage =
                                "Connection to internet lost, try again later";
                            break;
                          case "wrong-password":
                            errorMessage = "Incorrect Email or Password";
                            break;
                        }
                        print(e.code);
                      }

                      if (errorMessage.isNotEmpty) errorMessage = "";
                      setState(() {
                        showSpinner = false;
                      });
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

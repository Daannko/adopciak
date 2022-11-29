import 'package:adopciak/model/particles.dart';
import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:adopciak/custom_snackbar';
import 'package:adopciak/model/colors.dart';

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
            padding: EdgeInsets.symmetric(horizontal: 24.0),
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
                SizedBox(
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
                  decoration: InputDecoration(
                      hintText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
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
                        backgroundColor:
                            CustomColors.selectedInputTextBorderColor),
                    child: const Text('Login', style: TextStyle(fontSize: 40)),
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

                          showSnackBar(
                              context, "Welcome back, " + name, "Login");
                          Navigator.pushNamed(context, 'home_screen');
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

                      if (errorMessage.isNotEmpty)
                        showSnackBar(context, errorMessage, "Error");

                      errorMessage = "";
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

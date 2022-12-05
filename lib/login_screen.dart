import 'package:adopciak/model/particles.dart';
import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
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
  // late String email;
  // late String password;

  final TextEditingController _emailController =
      TextEditingController(text: "");
  final TextEditingController _passwordController =
      TextEditingController(text: "");

  bool saveCredentials = true;
  bool showSpinner = false;
  String errorMessage = "";
  final _storage = new FlutterSecureStorage();

  Future<void> _readCredentials() async {
    _emailController.text =
        await _storage.read(key: "KEY_EMAIL") ?? "testmail@mail.com";
    _passwordController.text =
        await _storage.read(key: "KEY_PASSWORD") ?? "123456";
  }

  _onSignUp() {
    Navigator.pushNamed(context, 'registration_screen');
  }

  @override
  void initState() {
    super.initState();
    _readCredentials();
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
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  // initialValue: email,
                  textAlign: TextAlign.center,
                  // onChanged: (value) {
                  //   email = value;
                  //   //Do something with the user input.
                  // },
                  controller: _emailController,
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
                TextFormField(
                  obscureText: true,
                  autocorrect: false,
                  // initialValue: password,
                  enableSuggestions: false,
                  textAlign: TextAlign.center,
                  // onChanged: (value) {
                  //   password = value;
                  //   //Do something with the user input.
                  // },
                  controller: _passwordController,
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
                  height: CustomStyles.smallBoxHeight,
                ),
                CheckboxListTile(
                  title: const Text("Remember me"),
                  value: saveCredentials,
                  onChanged: (bool? value) {
                    setState(() {
                      saveCredentials = value!;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                SizedBox(
                  height: CustomStyles.smallBoxHeight,
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
                            email: _emailController.text,
                            password: _passwordController.text);
                        if (user != null) {
                          final user = await FirebaseFirestore.instance
                              .collection('users')
                              .doc(_emailController.text)
                              .get();

                          if (saveCredentials) {
                            await _storage.write(
                                key: "KEY_EMAIL", value: _emailController.text);
                            await _storage.write(
                                key: "KEY_PASSWORD",
                                value: _passwordController.text);
                          } else {
                            await _storage.delete(key: "KEY_EMAIL");
                            await _storage.delete(key: "KEY_PASSWORD");
                          }

                          Navigator.pushNamed(context, 'navbar_screen');
                        }
                      } on FirebaseAuthException catch (e) {
                        switch (e.code) {
                          case "unknown":
                            errorMessage = "Enter propper ";
                            if (_emailController.text.isEmpty)
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
                SizedBox(
                  height: CustomStyles.bigBoxHeight,
                ),
                const Text(
                  "You don't have an account?",
                  textAlign: TextAlign.center,
                ),
                InkWell(
                  onTap: _onSignUp,
                  child: Text(
                    "Sign Up now to get access.",
                    style: TextStyle(
                        color: CustomColors.selectedInputTextBorderColor,
                        fontSize: CustomStyles.fontSize18,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

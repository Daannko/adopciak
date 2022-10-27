import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                width: 300,
                alignment: Alignment.center,
                margin: EdgeInsets.all(10),
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color.fromRGBO(38, 70, 83, 1),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'login_screen');
                  },
                  child: const Text("Log In", style: TextStyle(fontSize: 40)),
                ),
              ),
              Container(
                  margin: EdgeInsets.all(5),
                  child: TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Color.fromRGBO(42, 157, 143, 0.8)),
                      onPressed: () {
                        Navigator.pushNamed(context, 'registration_screen');
                      },
                      child: const Text("Sign In",
                          style: TextStyle(fontSize: 40))))
            ]))));
  }
}

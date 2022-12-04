import 'package:adopciak/services/firebase_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'model/colors.dart';
import 'model/styles.dart';
import 'model/user_details.dart';

class UserDetalisScreen extends StatefulWidget {
  const UserDetalisScreen({super.key});

  @override
  _UserDetalisState createState() => _UserDetalisState();
}

class _UserDetalisState extends State<UserDetalisScreen> {
  final _auth = FirebaseAuth.instance;
  final FirebaseStorageService firebaseStorageSerivce =
      Get.put(FirebaseStorageService());
  final myController = TextEditingController();
  List<UserDetails> users = [];
  List<String?> imagePath = [];
  List<Image> images = [];
  bool displayList = false;
  bool editName = false;
  bool editSurname = false;
  TextEditingController changePasswordTextController = TextEditingController();
  FToast fToast = FToast();

  @override
  void initState() {
    super.initState();
    myController.addListener(changeData);
    final db = FirebaseFirestore.instance;

    final User? user = _auth.currentUser;
    final uid = user!.uid;

    db
        .collection("users")
        .where('UserID', isEqualTo: uid)
        .get()
        .then(((value) async {
      for (int i = 0; i < value.size; i++) {
        final data = value.docs[i].data();

        UserDetails user = UserDetails(data["UserID"], data["Credits"],
            data["Email"], data["Name"], data["Surname"]);

        users.add(user);

        // String? path =
        //     await firebaseStorageSerivce.getImage(data["imageName"].toString());
        // images.add(Image.network(path!));
      }
      setState(() {
        displayList = true;
      });
    }));
  }

  void changeData() {
    setState(() {});
  }

  void updateDB() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(users[0].userID)
        .set(users[0].returnMap());
    changeData();
  }

  void _changePassword(String password) async {
    //Create an instance of the current user.
    User user = FirebaseAuth.instance.currentUser!;

    //Pass in the password to updatePassword.
    user.updatePassword(password).then((_) {
      print("Successfully changed password");
    }).catchError((error) {
      print("Password can't be changed" + error.toString());
      //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
    });
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        fToast.init(context);

        return AlertDialog(
          title: const Text('Change password'),
          content: TextField(
            controller: changePasswordTextController,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Change'),
              onPressed: () {
                if (changePasswordTextController.text.length < 6) {
                  _showToast() {
                    Widget toast = Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.redAccent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.not_interested_rounded),
                          const SizedBox(
                            width: 12.0,
                          ),
                          const Text("Haslo musi miec co najmniej 6 znakow"),
                        ],
                      ),
                    );
                    fToast.showToast(
                        child: toast, gravity: ToastGravity.BOTTOM);
                  }

                  _showToast();
                  print("za krotkie");
                } else {
                  _changePassword(changePasswordTextController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          height: double.infinity,
          color: CustomColors.homePageBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: SingleChildScrollView(
              child: Container(
                margin: CustomStyles.marginsAll20,
                decoration: BoxDecoration(
                  borderRadius: CustomStyles.radius20,
                ),
                child: !displayList
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(children: [
                        Container(
                          decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(spreadRadius: 1, blurRadius: 1)
                            ],
                            borderRadius: CustomStyles.radius20,
                          ),
                          child: Image.asset('images/user.png'),
                        ),
                        Container(
                          width: double.infinity,
                          margin: CustomStyles.margin10,
                          padding: CustomStyles.paddingAll7,
                          child: Column(
                            children: [
                              Container(
                                  width: double.infinity,
                                  margin: CustomStyles.margin10,
                                  padding: CustomStyles.paddingAll7,
                                  decoration: BoxDecoration(
                                      borderRadius: CustomStyles.radius30,
                                      color:
                                          CustomColors.animalScreenBodyColor),
                                  child: editName
                                      ? SizedBox(
                                          width: double.infinity,
                                          child: TextFormField(
                                            initialValue: users[0].name,
                                            textInputAction:
                                                TextInputAction.done,
                                            onFieldSubmitted: (value) {
                                              setState(() {
                                                editName = false;
                                                users[0].name = value;
                                                updateDB();
                                              });
                                            },
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              users.last.name,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize:
                                                      CustomStyles.fontSize20),
                                              maxLines: CustomStyles
                                                  .animalScreenMaxLines,
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.create_outlined),
                                              onPressed: () {
                                                setState(() {
                                                  editName = true;
                                                });
                                              },
                                            ),
                                          ],
                                        )),
                              const Text(" "),
                              Container(
                                  width: double.infinity,
                                  margin: CustomStyles.margin10,
                                  padding: CustomStyles.paddingAll7,
                                  decoration: BoxDecoration(
                                      borderRadius: CustomStyles.radius30,
                                      color:
                                          CustomColors.animalScreenBodyColor),
                                  child: editSurname
                                      ? SizedBox(
                                          width: double.infinity,
                                          child: TextFormField(
                                            initialValue: users[0].surname,
                                            textInputAction:
                                                TextInputAction.done,
                                            onFieldSubmitted: (value) {
                                              setState(() {
                                                editSurname = false;
                                                users[0].surname = value;
                                                updateDB();
                                              });
                                            },
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              users.last.surname,
                                              style: TextStyle(
                                                  color: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  fontSize:
                                                      CustomStyles.fontSize20),
                                              maxLines: CustomStyles
                                                  .animalScreenMaxLines,
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                  Icons.create_outlined),
                                              onPressed: () {
                                                setState(() {
                                                  editSurname = true;
                                                });
                                              },
                                            ),
                                          ],
                                        )),
                              Container(
                                  width: double.infinity,
                                  margin: CustomStyles.margin10,
                                  padding: CustomStyles.paddingAll7,
                                  decoration: BoxDecoration(
                                      borderRadius: CustomStyles.radius30,
                                      color: Colors.red.shade300),
                                  child: TextButton(
                                    child: const Text(
                                      "Zmien Haslo",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 27),
                                    ),
                                    onPressed: () {
                                      _dialogBuilder(context);
                                    },
                                  ))
                            ],
                          ),
                        ),
                      ]),
              ),
            ),
          )),
    );
  }
}

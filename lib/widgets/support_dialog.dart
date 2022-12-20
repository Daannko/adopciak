import 'package:adopciak/model/colors.dart';
import 'package:adopciak/model/styles.dart';
import 'package:flutter/material.dart';

class SupportDialogButton extends StatefulWidget {
  const SupportDialogButton({super.key});

  @override
  State<SupportDialogButton> createState() => _SupportDialogButtonState();
}

class _SupportDialogButtonState extends State<SupportDialogButton> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: CustomColors.fourthColor,
        borderRadius: CustomStyles.radiusAdoptuj,
      ),
      child: TextButton(
        onPressed: (() => {showMyDialog(context)}),
        child: Text(
          "Wspomóż",
          style: TextStyle(
              fontSize: CustomStyles.fontListView, color: Colors.black),
        ),
      ),
    );
  }

  void showMyDialog(BuildContext context) {
    showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            height: 200,
            child: Column(
              children: [
                const Text("Podaj sumę comiesięcznego wsparcia"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          _controller.text = '5';
                        },
                        child: const Text("5")),
                    TextButton(
                        onPressed: () {
                          _controller.text = '25';
                        },
                        child: const Text("25")),
                    TextButton(
                        onPressed: () {
                          _controller.text = '100';
                        },
                        child: const Text("100")),
                  ],
                ),
                TextField(
                  controller: _controller,
                  onSubmitted: (value) {
                    _controller.text = value;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

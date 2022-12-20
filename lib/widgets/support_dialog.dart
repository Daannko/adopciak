import 'package:adopciak/model/colors.dart';
import 'package:adopciak/model/styles.dart';
import 'package:flutter/material.dart';

class SupportDialogButton extends StatefulWidget {
  const SupportDialogButton({
    super.key,
    required this.onSupportAccept,
  });

  final ValueChanged<int> onSupportAccept;

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
          "Support",
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
            height: 117,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Provide monthly donation"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                        onPressed: () {
                          _controller.text = '5';
                        },
                        child: Text("5",
                            style: TextStyle(color: CustomColors.fourthColor))),
                    TextButton(
                        onPressed: () {
                          _controller.text = '25';
                        },
                        child: Text("25",
                            style: TextStyle(color: CustomColors.fourthColor))),
                    TextButton(
                        onPressed: () {
                          _controller.text = '100';
                        },
                        child: Text("100",
                            style: TextStyle(color: CustomColors.fourthColor))),
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
              child:
                  Text('OK', style: TextStyle(color: CustomColors.fourthColor)),
              onPressed: () {
                widget.onSupportAccept(int.parse(_controller.text));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

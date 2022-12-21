import 'package:adopciak/model/colors.dart';
import 'package:adopciak/model/styles.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SupportDialogButton extends StatefulWidget {
  const SupportDialogButton({
    super.key,
    required this.onSupportAccept,
    required this.buttonText,
  });

  final ValueChanged<int> onSupportAccept;
  final String buttonText;

  @override
  State<SupportDialogButton> createState() => _SupportDialogButtonState();
}

class _SupportDialogButtonState extends State<SupportDialogButton> {
  late TextEditingController _controller;
  FToast fToast = FToast();

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
          widget.buttonText,
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
        fToast.init(context);

        _showToast(String message) {
          Widget toast = Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25.0),
              color: CustomColors.toastColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.not_interested_rounded),
                const SizedBox(
                  width: 12.0,
                ),
                Text(message),
              ],
            ),
          );
          fToast.showToast(child: toast, gravity: ToastGravity.BOTTOM);
        }

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
                try {
                  int amount = int.parse(_controller.text);
                  if (amount < 1) {
                    _showToast("Amount must be greater than 0");
                  } else {
                    widget.onSupportAccept(int.parse(_controller.text));
                    Navigator.pop(context);
                  }
                } on Exception catch (_) {
                  _showToast("Must be a number");
                }
              },
            ),
          ],
        );
      },
    );
  }
}

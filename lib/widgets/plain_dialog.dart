import 'package:adopciak/model/colors.dart';
import 'package:adopciak/model/styles.dart';
import 'package:flutter/material.dart';

class PlainDialog extends StatelessWidget {
  const PlainDialog({
    super.key,
    required this.title,
    required this.content,
    required this.yesCallback,
    required this.noCallback,
  });

  final title;
  final content;
  final VoidCallback yesCallback;
  final VoidCallback noCallback;

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
          "Button",
          style: TextStyle(
              fontSize: CustomStyles.fontListView, color: Colors.black),
        ),
      ),
    );
  }

  showMyDialog(BuildContext context) {
    showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: () => {
                  noCallback(),
                  Navigator.pop(context, 'Cancel'),
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => {
                  yesCallback(),
                  Navigator.pop(context, 'OK'),
                },
                child: const Text('OK'),
              ),
            ],
          );
        });
  }
}

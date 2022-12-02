import 'dart:collection';

import 'package:adopciak/model/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({
    super.key,
    required this.filterNames,
    required this.filterValues,
    required this.onSelectedFiltersAnimalsChanged,
    required this.onTextChanged,
  });

  final List<String> filterNames;
  final List<bool> filterValues;
  final ValueChanged<List<bool>> onSelectedFiltersAnimalsChanged;
  final ValueChanged<String> onTextChanged;

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final textController = TextEditingController();
  List<String> _tempFilterNames = [];
  List<bool> _tempFilterValues = [];

  @override
  void initState() {
    _tempFilterNames = widget.filterNames;
    _tempFilterValues = widget.filterValues;
    textController.text = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double winWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
      child: Container(
          width: winWidth * 0.95,
          height: 40,
          decoration: BoxDecoration(
            border: Border.all(
              color: CustomColors.secondColor,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        _dialogBuilder(
                            context, _tempFilterNames, _tempFilterValues);
                      },
                      icon: const Icon(Icons.filter_alt)),
                  SizedBox(
                      width: winWidth * 0.7,
                      child: TextField(
                        controller: textController,
                        onSubmitted: (String value) {
                          setState(() {
                            textController.text = value;
                          });
                          widget.onTextChanged(textController.text);
                        },
                      ))
                ],
              ))),
    );
  }

  Future<void> _dialogBuilder(BuildContext context,
      List<String> tempFilterNames, List<bool> tempSelectedFilters) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Filter'),
          content: SizedBox(
            width: 200,
            height: 200,
            child: ListView.builder(
              itemCount: tempSelectedFilters.length,
              itemBuilder: (context, index) {
                return StatefulBuilder(builder: (context, setState) {
                  doTheFlop() {
                    setState(() {});
                  }

                  return CheckboxListTile(
                    title: Text(tempFilterNames[index]),
                    value: tempSelectedFilters[index],
                    onChanged: (bool? value) {
                      tempSelectedFilters[index] = value!;
                      doTheFlop();
                    },
                  );
                });
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Filtruj'),
              onPressed: () {
                widget.onSelectedFiltersAnimalsChanged(tempSelectedFilters);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

import 'package:adopciak/add_animal_screen.dart';
import 'package:adopciak/model/colors.dart';
import 'package:adopciak/model/styles.dart';
import 'package:adopciak/my_animals_screen.dart';
import 'package:adopciak/user_details_screen.dart';
import 'package:adopciak/support_screen.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dart:math' as math;

class NavBarScreen extends StatefulWidget {
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    SupportScreen(),
    AddAnimalScreen(),
    UserDetalisScreen(),
    MyAnimals()
  ];

  void _onItemTapped(int index) {
    setState(() {
      if (_widgetOptions[index] is HomeScreen) {
        (_widgetOptions[index] as HomeScreen).f();
      }
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IndexedStack(index: _selectedIndex, children: _widgetOptions),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Animals',
            backgroundColor: CustomColors.secondColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Supported',
            backgroundColor: CustomColors.secondColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle),
            label: 'Add',
            backgroundColor: CustomColors.secondColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
            backgroundColor: CustomColors.secondColor,
          ),
          BottomNavigationBarItem(
            icon: Transform.rotate(
              angle: 180 * math.pi / 180,
              child: Icon(Icons.catching_pokemon_rounded),
            ),
            label: 'My animals',
            backgroundColor: CustomColors.secondColor,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: CustomColors.firstColor,
        onTap: _onItemTapped,
      ),
    );
  }
}

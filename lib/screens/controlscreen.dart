import 'package:flutter/material.dart';
import 'package:weather_app_2/screens/homescreen.dart';
import 'package:weather_app_2/screens/profilescreen.dart';
import 'package:weather_app_2/screens/searchscreen.dart';
import '../main.dart';

class ControllScreen extends StatefulWidget {
  const ControllScreen({Key? key}) : super(key: key);

  @override
  State<ControllScreen> createState() => _ControllScreenState();
}

class _ControllScreenState extends State<ControllScreen> {
  var pages = [HomeScreen(), SearchScreen(), ProfileScreen()];
  var selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile') //
        ],
        currentIndex: selectedIndex,
        onTap: (index) {
          //for hw addd other index of red screen or green in the items property as well as the pages variable
          //search bar no funtionality
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}

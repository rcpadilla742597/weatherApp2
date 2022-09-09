import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app_2/screens/homescreen.dart';
import 'package:weather_app_2/screens/profilescreen.dart';
import 'package:weather_app_2/screens/searchscreen.dart';
import '../controllers/controlScreenController.dart';
import '../main.dart';

//animated container for page transition

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
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Liked') //
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

class ControlScreen extends GetView<ControlScreenController> {
  var pages = [HomeScreen(), SearchScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: pages[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite), label: 'Liked') //
          ],
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
            controller.changeIndex(index);
          },
        ),
      ),
    );
  }
}

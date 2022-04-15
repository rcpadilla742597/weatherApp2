import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:weather_app_2/constants/colors.dart';
import 'package:weather_app_2/controllers/homescreen_controller.dart';
import 'package:weather_app_2/models/homescreen/currentweather_model.dart';
import 'package:weather_app_2/models/homescreen/extenstions.dart';
import 'package:weather_app_2/screens/controlscreen.dart';
import 'package:weather_app_2/screens/searchscreen.dart';

class ProfileScreen extends GetView<HomeScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.green,
        body: ValueListenableBuilder<Box>(
            valueListenable: Hive.box('favorites').listenable(),
            builder: (context, value, _) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: value.keys.length,
                      itemBuilder: (context, index) {
                        if (value.values.toList()[index]) {
                          return Text('${value.keys.toList()[index]}');
                        } else {
                          return Container();
                        }
                        // a listviewbuilder are going to have 2 main things: the builder property, that has the values of cotnext index and extra property and itemcount: tells the listeviewbuidler how many items you have to iterate through
                      },
                    ),
                  )
                ],
              );
            }));
  }
}

// @HiveType()
// class Favorites extends HiveObject {
//   @HiveField(0)
//   late String testKey;
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.green,
//         body: ValueListenableBuilder<Box>(
//             valueListenable: Hive.box('favorites').listenable(),
//             builder: (context, value, _) {
//               return Column(
//                 children: [
//                   Text('result: ${value.get('testKey')}'),
//                 ],
//               );
//             }));
//   }
// }

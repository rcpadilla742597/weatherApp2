import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:weather_app_2/constants/colors.dart';
import 'package:weather_app_2/constants/textConstants.dart';
import 'package:weather_app_2/controllers/controlScreenController.dart';
import 'package:weather_app_2/controllers/homescreen_controller.dart';
import 'package:weather_app_2/controllers/searchscreencontroller.dart';
import 'package:weather_app_2/models/homescreen/currentweather_model.dart';
import 'package:weather_app_2/models/homescreen/extenstions.dart';
import 'package:weather_app_2/screens/controlscreen.dart';
import 'package:weather_app_2/screens/searchscreen.dart';

class ProfileScreen extends GetView<HomeScreenController> {
  var csc = Get.find<ControlScreenController>();
  var scc = Get.find<SearchScreenController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ValueListenableBuilder<Box>(
            valueListenable: Hive.box('favorites').listenable(),
            builder: (context, box, _) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: box.keys.length,
                      itemBuilder: (context, index) {
                        if (box.values.toList()[index]['favorite']) {
                          int date = box.values.toList()[index]['timezone'];
                          return TextButton(
                              onPressed: () {
                                csc.changeIndex(1);
                                scc.reFetch(box.keys.toList()[index]);
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 219, 218, 218),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  width: 375,
                                  height: 250,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              '${box.keys.toList()[index]}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 20.0,
                                                  color: Colors.blue),
                                            ).myPadding(10),
                                            Text(
                                              '${date.toDate()}',
                                              style: profileCard1,
                                            ).myPadding(10),

                                            Text('Date', style: profileCard1)
                                                .myPadding(10),
                                            //303.2.toFString()
                                            Text('title', style: profileCard2)
                                                .myPadding(10),
                                            Text('Image Goes Here',
                                                    style: profileCard1)
                                                .myPadding(10),
                                            Text('Description', style: cardDesc)
                                                .myPadding(10),
                                          ],
                                        )
                                      ])));
                        } else {
                          return Container();
                        }
                      },
                    ),
                  )
                ],
              );
            }));
  }
}

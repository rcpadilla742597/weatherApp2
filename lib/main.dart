import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app_2/constants/colors.dart';
import 'package:weather_app_2/constants/urlConstants.dart';
import 'package:weather_app_2/models/homescreen/articlemodel.dart';
import 'package:weather_app_2/models/homescreen/currentweather_model.dart';
import 'package:weather_app_2/models/homescreen/extenstions.dart';
import 'package:weather_app_2/screens/controlscreen.dart';
import 'controllers/controlScreenController.dart';
import 'controllers/homescreen_controller.dart';
import 'controllers/networkcontroller.dart';
import 'controllers/searchscreencontroller.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:html/dom.dart';
import 'package:html/dom_parsing.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('favorites');
  var box2 = await Hive.openBox('history');
  if (!box2.containsKey('historyList') || box2.get('historyList') == null) {
    box2.put('historyList', []);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(HomeScreenController());
    Get.put(SearchScreenController());
    Get.put(ControlScreenController());
    Get.put(NetworkController());
    //network controller goes here
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: ControlScreen(),
    );
  }
}

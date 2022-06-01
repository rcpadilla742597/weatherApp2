import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_2/models/homescreen/currentweather_model.dart';
import 'package:weather_app_2/models/homescreen/forecastweather_model.dart';
import 'package:weather_app_2/models/homescreen/timelineweather_model.dart';
import 'package:weather_app_2/models/weather_model.dart';
import 'package:dart_ipify/dart_ipify.dart';

class SearchScreenController extends GetxController
    with StateMixin<WeatherModel> {
  var textController = TextEditingController()
      .obs; //whenever i change the value you see it on the ui. getx gives you access to obs

  // onInit gets called when HomeScreenController is created
  @override
  void onInit() {
    change(null, status: RxStatus.empty());
    // super refers to GetxController. HomeScreenController is a child which extends GetxController.
    super.onInit();
    //My contribution to the parent
  }

  clear() {
    textController.value.text = '';
    historyFetch();
  } //HW 4/23/22 needs button with onpressed function. it's going to be inside the textformfield. look through docs for something that shows you can add a button where the X button is
  // FIGURE OUT A WAY TO NOt CREATE DUPLICATES IN THE HISTORY LIST. first check if the value exists in the list, if it does, then dont add it if it doesnt then proceed to add it

  reFetch(String location) {
    textController.value.text = location;
    weatherFetch();
  }

  weatherFetch() async {
    try {
      change(null, status: RxStatus.loading());
      // trys below

      var response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=${textController.value.text}&appid=fe514ac7e7ef730c4b1da547d4a2e9ea'));
      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      } else {
//timeline
        List loDaysWeather = jsonDecode(response.body)["list"];
//forecast
        List loWeather = jsonDecode(response.body)["list"];

        List shortList = [];
        for (int i = 0; i < loDaysWeather.length; i++) {
          if (i % 8 == 0) {
            shortList.add(loDaysWeather[i]);
          }
        }
        var t = shortList
            .map((jsonInList) => TimelineWeatherModel.fromJson(jsonInList))
            .toList();

        loWeather.forEach((jsonInList) =>
            jsonInList = ForecastWeatherModel.fromJson(jsonInList));
        var f = loWeather
            .map((jsonInList) => ForecastWeatherModel.fromJson(jsonInList))
            .toList();
        t.forEach((element) {});

        var cardResponse = await http.get(Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=${textController.value.text}&appid=49a2adca18d67e77118367efe5497060'));

        if (cardResponse.statusCode != 200) {
          throw HttpException('${cardResponse.statusCode}');
        } else {
          var loCardWeather = jsonDecode(cardResponse.body);

          var c = CurrentWeatherModel.fromJson(loCardWeather);
          change(WeatherModel.filled(c: c, f: f, t: t),
              status: RxStatus.success());
          var x = WeatherModel.filled(c: c, f: f, t: t);
          value = WeatherModel.filled(c: c, f: f, t: t);
          update();
          var box = Hive.box('history');
          //Open box
          // load box value of historyList into a variable x
          // add the current location into x
          // put x into historyList

          var listFromH = box.get('historyList');
          while (listFromH.remove(c.location)) {}
          var listModified = [...listFromH, c.location];
          box.put('historyList', listModified);
          //whatever is nested deepest gets executed first. which is why box.get gets executed first
          //whatever we typed* not typing

        }
      }
    } catch (e) {
      change(WeatherModel(c: CurrentWeatherModel.empty()),
          status: RxStatus.error('error'));
    }
  }

  historyFetch() async {
    change(WeatherModel(c: CurrentWeatherModel.empty()),
        status: RxStatus.empty());
  }
}

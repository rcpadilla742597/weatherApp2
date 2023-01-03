import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_2/models/geoModel.dart';
import 'package:weather_app_2/models/homescreen/currentweather_model.dart';
import 'package:weather_app_2/models/homescreen/forecastweather_model.dart';
import 'package:weather_app_2/models/homescreen/timelineweather_model.dart';
import 'package:weather_app_2/models/weather_model.dart';

enum SearchScreenStatus {
  direct, //goes to weatherfetch()
  options //goes to options
}

class SearchScreenController extends GetxController
    with StateMixin<SearchScreenStatus> {
  var textController = TextEditingController()
      .obs; //whenever i change the value you see it on the ui. getx gives you access to obs
  var options = [].obs;
  var w_model = WeatherModel(c: CurrentWeatherModel.empty()).obs;

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
  }

  reFetch(CurrentWeatherModel model) {
    // make a new function here called geocoding
    // which takes a parameter of location
    //do a get request to the open weather api.
    //http://api.openweathermap.org/geo/1.0/direct?q=London&limit=5&appid={API key}
    // weatherFetch(); //comment this out when testing
    geoCoding();
  }

  fromHistory(CurrentWeatherModel model) async {
    try {
      var response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${model.lat}&lon=${model.lon}&appid=49a2adca18d67e77118367efe5497060'));

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}#1');
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
            'https://api.openweathermap.org/data/2.5/weather?lat=${model.lat}&lon=${model.lon}&appid=49a2adca18d67e77118367efe5497060'));

        if (cardResponse.statusCode != 200) {
          throw HttpException('${cardResponse.statusCode}#2');
        } else {
          var loCardWeather = jsonDecode(cardResponse.body);

          var c = CurrentWeatherModel.fromJson(loCardWeather);
          if (model.location.toString() != "") {
            c.location = model.location.toString();
          }
          w_model.value = WeatherModel.filled(c: c, f: f, t: t);
          change(SearchScreenStatus.direct, status: RxStatus.success());

          update();
          var box = Hive.box('history');
          //Open box
          // load box value of historyList into a variable x
          // add the current location into x
          // put x into historyList

          List listFromH = box.get('historyList');
          //This is how to remove the duplicates. It keeps removing it till it cant anymore
          listFromH.removeWhere((l) {
            print(l.values);
            // print(listFromH.runtimeType);
            return l.values.toList()[0] == c.location;
          });

          var listModified = [...listFromH, c.toJson()];
          box.put('historyList', listModified);
          //whatever is nested deepest gets executed first. which is why box.get gets executed first
          //whatever we typed* not typing

        }
      }
    } catch (e) {
      change(SearchScreenStatus.direct,
          status: RxStatus.error('DIRECT FAILED${e}'));
    }
  }

  geoCoding() async {
    try {
      var response = await http.get(Uri.parse(
          'http://api.openweathermap.org/geo/1.0/direct?q=${textController.value.text}&limit=5&appid=49a2adca18d67e77118367efe5497060'));

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}');
      } else {
        List geoCodeResponse = json.decode(response.body);
        print(geoCodeResponse.length);
        if (geoCodeResponse.length == 1) {
          weatherFetch();
          return;
        }
        options.clear();
        geoCodeResponse.forEach(
          (element) {
            GeoModel geoModel2 = GeoModel.fromJson(element);
            options.add(geoModel2);
            print(geoModel2.toString());
          },
        );
        change(SearchScreenStatus.options, status: RxStatus.success());
      }
    } catch (e) {
      change(SearchScreenStatus.direct,
          status: RxStatus.error('geocode error'));
    }
  }

  fr0mList(GeoModel currentlocation) async {
    try {
      var response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?lat=${currentlocation.lat}&lon=${currentlocation.lon}&appid=49a2adca18d67e77118367efe5497060'));
      print(currentlocation.lat);
      print(currentlocation.lon);

      if (response.statusCode != 200) {
        throw HttpException('${response.statusCode}#1');
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
            'https://api.openweathermap.org/data/2.5/weather?lat=${currentlocation.lat}&lon=${currentlocation.lon}&appid=49a2adca18d67e77118367efe5497060'));

        if (cardResponse.statusCode != 200) {
          throw HttpException('${cardResponse.statusCode}#2');
        } else {
          var loCardWeather = jsonDecode(cardResponse.body);

          var c = CurrentWeatherModel.fromJson(loCardWeather);
          c.location = currentlocation.toString();
          w_model.value = WeatherModel.filled(c: c, f: f, t: t);
          change(SearchScreenStatus.direct, status: RxStatus.success());

          update();
          var box = Hive.box('history');
          //Open box
          // load box value of historyList into a variable x
          // add the current location into x
          // put x into historyList

          var listFromH = box.get('historyList');
          listFromH.removeWhere((l) => l.values.toList()[0] == c.location);
          var listModified = [...listFromH, c.toJson()];
          box.put('historyList', listModified);
          //whatever is nested deepest gets executed first. which is why box.get gets executed first
          //whatever we typed* not typing

        }
      }
    } catch (e) {
      change(SearchScreenStatus.direct,
          status: RxStatus.error('DIRECT FAILED${e}'));
    }
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
          w_model.value = WeatherModel.filled(c: c, f: f, t: t);
          change(SearchScreenStatus.direct, status: RxStatus.success());

          update();
          var box = Hive.box('history');
          //Open box
          // load box value of historyList into a variable x
          // add the current location into x
          // put x into historyList

          var listFromH = box.get('historyList');
          listFromH.removeWhere((l) => l.values.toList()[0] == c.location);
          var listModified = [...listFromH, c.toJson()];
          box.put('historyList', listModified);
          //whatever is nested deepest gets executed first. which is why box.get gets executed first
          //whatever we typed* not typing

        }
      }
    } catch (e) {
      change(SearchScreenStatus.direct, status: RxStatus.error('error'));
    }
  }

  historyFetch() async {
    change(SearchScreenStatus.direct, status: RxStatus.empty());
  }

  // Create update favorites function in search screen.dart

  likeBtn() async {
    var box = Hive.box('favorites');

    // make a new key here
    // use print() print the value of w_model.value.c.location

    if (box.containsKey(w_model.value.c.location)) {
      box.delete(w_model.value.c.location);
    } else {
      box.put(w_model.value.c.location, {
        "timezone": w_model.value.c.timezone,
        "favorite": true,
        "lat": w_model.value.c.lat,
        "lon": w_model.value.c.lon,
        "name": w_model.value.c.location.split(",")[0].trim(),
        "country": w_model.value.c.location.split(",")[2].trim(),
        "state": w_model.value.c.location.split(",")[1].trim(),
      });
    }
  }
}

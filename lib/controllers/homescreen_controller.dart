import 'dart:convert';
import 'dart:io';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_2/models/homescreen/currentweather_model.dart';
import 'package:weather_app_2/models/homescreen/forecastweather_model.dart';
import 'package:weather_app_2/models/homescreen/timelineweather_model.dart';
import 'package:weather_app_2/models/weather_model.dart';
import 'package:dart_ipify/dart_ipify.dart';

class HomeScreenController extends GetxController
    with StateMixin<WeatherModel> {
  var location = 'Tampa'; //default value
  // onInit gets called when HomeScreenController is created
  @override
  void onInit() {
    weatherFetch();
    // super refers to GetxController. HomeScreenController is a child which extends GetxController.
    super.onInit();
    //My contribution to the parent
  }

  Future<void> geoLocator() async {
    change(WeatherModel(c: CurrentWeatherModel.empty()),
        status: RxStatus.loading());
    var query = await Ipify.ipv4();
    var response = await http.get(
        Uri.parse('http://ip-api.com/json/${query}?fields=status,city,query'));
    var test = jsonDecode(response.body);
    location = test["city"];
    if (response.statusCode != 200) {
      throw HttpException('${response.statusCode}');
    } else {
      // message prints below if geolocator was successful
    }
  }

  weatherFetch() async {
    try {
      // trys below
      await geoLocator();

      var response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=${location}&appid=fe514ac7e7ef730c4b1da547d4a2e9ea'));
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
            'https://api.openweathermap.org/data/2.5/weather?q=${location}&appid=49a2adca18d67e77118367efe5497060'));

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
        }
      }
    } catch (e) {
      change(WeatherModel(c: CurrentWeatherModel.empty()),
          status: RxStatus.error('$e'));
    }
  }

  void updateEditState() {}
}

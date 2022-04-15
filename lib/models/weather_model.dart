import 'package:weather_app_2/models/homescreen/forecastweather_model.dart';
import 'package:weather_app_2/models/homescreen/timelineweather_model.dart';

import 'homescreen/currentweather_model.dart';

class WeatherModel {
  CurrentWeatherModel c = CurrentWeatherModel.empty();
  List<ForecastWeatherModel> f = [];
  List<TimelineWeatherModel> t = [];

  WeatherModel(
      {required CurrentWeatherModel c,
      List<ForecastWeatherModel> f = const [],
      List<TimelineWeatherModel> t = const []});

  WeatherModel.filled(
      {required CurrentWeatherModel c,
      required List<ForecastWeatherModel> f,
      required List<TimelineWeatherModel> t}) {
    this.c = c;
    this.f = f;
    this.t = t;
  }
}

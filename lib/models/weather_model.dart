import 'package:weather_app_2/models/homescreen/forecastweather_model.dart';
import 'package:weather_app_2/models/homescreen/timelineweather_model.dart';

import 'homescreen/currentweather_model.dart';

class WeatherModel {
  late CurrentWeatherModel c;
  late List<ForecastWeatherModel> f;
  late List<TimelineWeatherModel> t;

  addC(c) {
    this.c = c;
  }

  addF(f) {
    this.f = f;
  }

  addT(t) {
    this.t = t;
  }
}

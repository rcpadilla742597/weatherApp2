// fweathermodel

class ForecastWeatherModel {
  // defines unix time
  int time = 0;
  // defines icon
  String picture = '';
  // defines weather for weather condition
  String condition = 'cloudy';
  // defines temperature in kelvin
  double temp = 0.0;

  // this is the default constructor for forecast weather model
  ForecastWeatherModel(
      {required int time,
      required String pictureUrl,
      required String condition,
      required double temp}) {
    this.time = time;
    picture = pictureUrl;
    this.condition = condition;
    this.temp = temp;
  }

// this is a factory constructor to create a forecast weather model from json data
  factory ForecastWeatherModel.fromJson(Map<String, dynamic> json) {
    return ForecastWeatherModel(
      time: json['dt'] ?? 0,
      pictureUrl:
          "https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png",
      condition: json["weather"][0]["main"] ?? 0,
      temp: 0.0,
    );
  }
}

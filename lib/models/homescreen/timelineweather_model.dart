//dweathermodel

class TimelineWeatherModel {
  // defines icon
  String picture = "https://openweathermap.org/img/wn/01d@2x.png";
  // defines unix time
  int time = 0;
  // defines temperature in kelvin
  double temp = 0.0;
// this is the default constuctor for the timeline weather model
  TimelineWeatherModel(
      {required String picture, required int time, required double temp}) {
    this.picture = picture;
    this.temp = temp;
    this.time = time;
  }
// this is a factory constructor to create a timeline model from json data
  factory TimelineWeatherModel.fromJson(Map<dynamic, dynamic> json) {
    return TimelineWeatherModel(
        picture:
            "https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png",
        time: json['dt'] ?? 0,
        temp: json['main']['temp'].toDouble() ?? 0.0);
  }
}

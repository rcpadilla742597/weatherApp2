class TimelineWeatherModel {
  // defines icon
  String picture = '';
  // defines unix time
  int time = 0;
  // defines temperature in kelvin
  double temp = 0.0;
// this is the default constuctor for the timeline weather model
  TimelineWeatherModel(
      {required String picture, required int time, required double temp});
// this is a factory constructor to create a timeline model from json data
  factory TimelineWeatherModel.fromJson(Map<dynamic, dynamic> json) {
    return TimelineWeatherModel(
        picture:
            "https://raw.githubusercontent.com/rcpadilla742597/open-weather-icons/main/${json['weather'][0]['icon']}.svg",
        // time: json['dt'] ?? 0,
        // temp: json['main']['temp'] ?? 0.0);
        time: 0,
        temp: 0.0);
  }
}

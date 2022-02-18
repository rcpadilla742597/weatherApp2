class CurrentWeatherModel {
  // defines locations
  String location = '';
  // defines temperature in kelvin
  double temp = 0.0;
  // defines icon
  String picture = '';
  // defines weather condition
  String condition = '';
  // defines unix time
  int time = 0;

// this is the default constructor for the card weather model
  CurrentWeatherModel({
    String location = '',
    required double temp,
    required String pictureUrl,
    required String condition,
    required int time,
  });
// this is a factory constructor to create a card weather model from json data
  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
      time: json['dt'] ?? 0,
      location: json['name'] ?? '0',
      temp: json['main']['temp'] ?? 0,
      pictureUrl:
          "https://raw.githubusercontent.com/rcpadilla742597/open-weather-icons/main/${json['weather'][0]['icon']}.svg",
      condition: json["weather"][0]["description"],
    );
  }
}

// cweathermodel

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
  String name = '';
  String country = '';
  String state = '';

  int time = 0;

  int timezone = 0;

  late double lat = 0.0;

  late double lon = 0.0;

// this is the default constructor for the card weather model
  CurrentWeatherModel({
    String location = '',
    required double temp,
    required String pictureUrl,
    required String condition,
    required int time,
    required int timezone,
    required double lat,
    required double lon,
    required String name,
    required String country,
    required String state,
  }) {
    this.location = location;

    this.temp = temp;
    this.time = time;
    picture = pictureUrl;
    this.condition = condition;
    this.timezone = timezone;
    this.lon = lon;
    this.lat = lat;
    this.name = name;
    this.country = country;
    this.state = state;
  }

// this is a factory constructor to create a card weather model from json data
  factory CurrentWeatherModel.fromJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
        time: json['dt'] ?? 0,
        location: json['name'] ?? '0',
        temp: json['main']['temp'] ?? 0.0,
        pictureUrl:
            "https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png",
        condition: json["weather"][0]["description"] ?? '',
        timezone: json['timezone'] ?? 0,
        lat: json['coord']['lat'] ?? 0.0,
        name: json['name'] ?? '0',
        country: json['country'] ?? '0',
        state: json['location'] ?? '0',
        lon: json['coord']['lon'] ?? 0.0);

    //ADD LON AND LAT
  }

  factory CurrentWeatherModel.fromHiveHistoryJson(Map<String, dynamic> json) {
    return CurrentWeatherModel(
        time: json['time'],
        location: json['location'],
        temp: json['temp'],
        pictureUrl: json['pictureUrl'],
        condition: json['condition'],
        timezone: json['timezone'],
        lat: json['lat'],
        name: json['name'] ?? '0',
        country: json['country'] ?? '0',
        state: json['location'] ?? '0',
        lon: json['lon']);

    //ADD LON AND LAT
  }

  factory CurrentWeatherModel.fromHiveFavoriteJson(Map<String, dynamic> json) {
    var model = CurrentWeatherModel.empty();

    model.lon = json['lon'];
    model.lat = json['lat'];
    return model;
  }

  toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['location'] = this.location;
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    data['condition'] = this.condition;
    data['pictureUrl'] = this.picture;
    data['time'] = this.time;
    data['timezone'] = this.timezone;
    data['temp'] = this.temp;
    data['state'] = this.state;
    data['country'] = this.country;
    data['name'] = this.name;
    return data;
  }

  factory CurrentWeatherModel.empty() {
    return CurrentWeatherModel(
      temp: 0.0,
      pictureUrl:
          'https://raw.githubusercontent.com/rcpadilla742597/open-weather-icons/main/01d.svg',
      condition: '',
      time: 0,
      timezone: 0,
      lat: 0.0,
      lon: 0.0,
      name: '',
      state: '',
      country: '',
    );
  }
}

class GeoModel {
  late String name;
  late String country;
  String? state;
  late double lat;
  late double lon;

  GeoModel(
      {required this.name,
      required this.country,
      String? state,
      required this.lat,
      required this.lon}) {
    this.name = name;
    this.country = country;
    this.state = state;
    this.lat = lat;
    this.lon = lon;
  }
  GeoModel.fromJson(Map json) {
    this.name = json['name'];
    this.country = json['country'];
    this.state = json['state'];
    this.lat = json['lat'];
    this.lon = json['lon'];
  }
  @override
  String toString() {
    if (this.state == null) {
      return '${this.name}, ${this.country}';
    } else {
      return '${this.name}, ${this.state}, ${this.country}';
    }
  }
}

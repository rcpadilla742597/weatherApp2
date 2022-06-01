// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Kelvin to Fahrenheit
extension WeatherExtensions on double {
  String toFString() {
    var convert = (this - 273.0) * (9 / 5) + 32.0;
    convert = convert.roundToDouble();
    return '$convert°';
  }

  double toF() {
    var convert = (this - 273) * (9 / 5) + 32;
    return convert;
  }
}

// Double with rounding
extension RoundDouble on double {
  double toRound(int round) {
    var round2 = double.parse((this).toStringAsFixed(round));
    return round2;
  }
}

// Attaching hello to string
extension Hello on String {
  String toHello() {
    var attach = this;
    return 'Hello, $attach!';
  }
}

// Timestamp to Date
extension TimeExtensions on int {
  String toReadable() {
    if (this == 0) {
      return 'Error';
    }

    var date = DateTime.fromMillisecondsSinceEpoch((this * 1000).round());
    var formattedDate = DateFormat.yMMMd().format(date); // Apr 8, 2020
    return '$formattedDate';
  }

  String dayOfWeek() {
    var date = DateTime.fromMillisecondsSinceEpoch((this * 1000).round());
    var displayDays = DateFormat('EEEE').format(date);

    return '$displayDays';
  }
}

// Padding
extension PaddingExtensions on Widget {
  Widget myPadding(double padding) => Padding(
        padding: EdgeInsets.all(padding),
        child: this,
      );
}

extension TimeZone on int {
  String toDate() {
    if (this == 0) {
      return 'Error';
    }

    DateTime currentDate = new DateTime.now().toUtc();

    DateTime utcDate = currentDate.subtract(new Duration(seconds: this.abs()));
    print(utcDate);
    return '$utcDate';
  }
}

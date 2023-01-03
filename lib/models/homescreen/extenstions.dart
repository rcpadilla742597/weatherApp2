// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Kelvin to Fahrenheit
extension WeatherExtensions on double {
  String toFString() {
    double convert = (this - 273.0) * (9 / 5) + 32.0;
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

// Padding for the Main Card
extension PaddingExtensions on Widget {
  Widget myPadding(double padding) => Padding(
        padding: const EdgeInsets.fromLTRB(15, 10, 0, 10),
        child: this,
      );
}

// Padding for the Card Date -> Time on 'Favorites' Profile Screen
extension InsideCardPaddingExtensions on Widget {
  Widget insidePadding(double padding) => Padding(
        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
        child: this,
      );
}

extension TimeZone on int {
  TimeOfDay toDate() {
    if (this == 0) {
      return TimeOfDay.now();
      // not ideal, not the optimal solution
    }

    DateTime currentDate = new DateTime.now().toUtc();
    DateTime utcDate = currentDate.subtract(new Duration(seconds: this.abs()));

    var myTime = TimeOfDay.fromDateTime(utcDate);

    return myTime;
  }
}

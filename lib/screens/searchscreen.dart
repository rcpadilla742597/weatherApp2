import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app_2/constants/colors.dart';
import 'package:weather_app_2/constants/textConstants.dart';
import 'package:weather_app_2/controllers/homescreen_controller.dart';
import 'package:weather_app_2/controllers/searchscreencontroller.dart';
import 'package:weather_app_2/models/geoModel.dart';
import 'package:weather_app_2/models/homescreen/currentweather_model.dart';
import 'package:weather_app_2/models/homescreen/extenstions.dart';
import 'package:weather_app_2/screens/controlscreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather_app_2/main.dart';

class SearchScreen extends GetView<SearchScreenController> {
  var box = Hive.box('favorites');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
              Container(
                height: 70,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: TextFormField(
                            onChanged: (value) {
                              controller.historyFetch();
                            },
                            controller: controller.textController.value,
                            decoration: InputDecoration(
                                hintText: 'Search',
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.close),
                                  onPressed: () {
                                    controller.clear();
                                  },
                                )),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              controller.geoCoding();
                            },
                            child: const Text('Submit'),
                          )),
                    ]),
              ),
              controller.obx((state) {
                if (state == SearchScreenStatus.direct) {
                  return Center(
                    child: Column(children: [
                      ValueListenableBuilder<Box>(
                          valueListenable: Hive.box('favorites').listenable(),
                          builder: (context, value, _) {
                            return Column(
                              children: [
                                IconButton(
                                  icon: box.containsKey(
                                          controller.w_model.value.c.location)
                                      ? Icon(Icons.favorite)
                                      : Icon(Icons.favorite_border),
                                  onPressed: () {
                                    controller.likeBtn();
                                  },
                                ),
                              ],
                            );
                          }),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: controller.w_model.value.c.temp >= 294.261
                                ? cList1
                                : cList2,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        width: 450,
                        height: 250,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  controller.w_model.value.c.location,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20.0,
                                      color: Colors.white),
                                ).myPadding(10),
                                Text(
                                  controller.w_model.value.c.time.toReadable(),
                                  style: TextStyle(
                                      fontSize: 15.0, color: Colors.white),
                                ).myPadding(10),
                                //303.2.toFString()
                                Text(
                                  controller.w_model.value.c.temp.toFString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 60.0,
                                      color: Colors.white),
                                ).myPadding(10),
                                Text(
                                  controller.w_model.value.c.condition,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                      color: Colors.white),
                                ).myPadding(10),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 50.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image(
                                    image: NetworkImage(
                                        controller.w_model.value.c.picture),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                        child: Container(
                          height: 100,
                          width: 430,
                          child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: controller.w_model.value.f.length,
                            itemBuilder: (context, index) {
                              var forecast = controller.w_model.value.f[index];

                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                              colors: forecast.temp >= 294.261
                                                  ? cList1
                                                  : cList2,
                                            ),
                                          ),
                                          child: AlertDialog(
                                            title: Text('Today'),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                    DateTime.fromMillisecondsSinceEpoch(
                                                                forecast.time *
                                                                    1000)
                                                            .hour
                                                            .toString() +
                                                        ":00"),
                                                Image(
                                                  image: NetworkImage(
                                                      forecast.picture),
                                                ),
                                                Text(forecast.condition),
                                              ],
                                            ),
                                            actions: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text("Close"))
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    width: 50,
                                    height: 50,
                                    child: Column(
                                      children: [
                                        Text(
                                            DateTime.fromMillisecondsSinceEpoch(
                                                        forecast.time * 1000)
                                                    .hour
                                                    .toString() +
                                                ":00"),
                                        Image(
                                          image: NetworkImage(forecast.picture),
                                        ),
                                        Text(forecast.condition),
                                      ],
                                    )),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      Container(
                        child: DataTable(
                            headingRowHeight: 0.0, // This hides the tabs
                            horizontalMargin: 0.0, // Adjusts the lines
                            columnSpacing: 60,
                            columns: const <DataColumn>[
                              DataColumn(label: Text('Day of week')),
                              DataColumn(label: Text('Condition')),
                              DataColumn(label: Text('Temperature')),
                            ],
                            rows: controller.w_model.value.t.map((weather) {
                              int day = weather.time;
                              double temp = weather.temp;
                              return DataRow(cells: <DataCell>[
                                DataCell(Text(day.dayOfWeek())),
                                DataCell(
                                  Center(
                                      child: Image(
                                    image: NetworkImage(weather.picture),
                                  )),
                                ),
                                DataCell(Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(temp.toFString()),
                                  ],
                                )),
                              ]);
                            }).toList()),
                      ),
                    ]),
                  );
                } else {
                  return Container(
                      child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.options.toList().length,
                    //an x amount of geomodels exist in controller.options
                    itemBuilder: (BuildContext context, int index) {
                      // IF {MYCOLOR =}
                      return InkWell(
                        onTap: () {
                          controller
                              .fr0mList(controller.options.toList()[index]);
                          //THE FUNCTION NEEDS TO PASS in a geomodel
                        },
                        child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                                color: index % 2 == 0
                                    ? Colors.amber
                                    : Colors.blue),
                            child:
                                Text('${controller.options.toList()[index]}')),
                      );
                    },
                  )); //options UI goes here
                }
              },
                  onEmpty: ValueListenableBuilder<Box>(
                      valueListenable: Hive.box('history').listenable(),
                      builder: (context, hBox, _) {
                        var listFromH = hBox.get('historyList').toList();

                        var updatedLength;
                        if (listFromH.length >= 5) {
                          updatedLength = listFromH.sublist(0, 5).length;
                        } else {
                          updatedLength = listFromH.length;
                        }
                        return Column(
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: updatedLength,
                                  itemBuilder: (context, index) {
                                    var value =
                                        listFromH.reversed.toList()[index];
                                    var currentWeather =
                                        CurrentWeatherModel.fromHiveHistoryJson(
                                            value);
                                    if (value != null) {
                                      return TextButton(
                                        onPressed: () {
                                          controller
                                              .fromHistory(currentWeather);
                                        },
                                        //pass textstyle from constants files
                                        child: Text(
                                          currentWeather.location,
                                          textAlign: TextAlign.start,
                                          style: listItemStyle,
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  }),
                            ),
                          ],
                        );
                      }))
            ])));
  }
}

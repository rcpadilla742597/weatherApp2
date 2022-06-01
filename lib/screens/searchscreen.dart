import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app_2/constants/colors.dart';
import 'package:weather_app_2/constants/textConstants.dart';
import 'package:weather_app_2/controllers/homescreen_controller.dart';
import 'package:weather_app_2/controllers/searchscreencontroller.dart';
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
                height: 50,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
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
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              controller.weatherFetch();
                            },
                            child: const Text('Submit'),
                          )),
                    ]),
              ),
              Container(height: 100),
              controller.obx((state) {
                print(state!.t);
                return Center(
                  child: Column(children: [
                    ValueListenableBuilder<Box>(
                        valueListenable: Hive.box('favorites').listenable(),
                        builder: (context, value, _) {
                          print(box.containsKey(state.c.location));

                          return Column(
                            children: [
                              IconButton(
                                icon: box.containsKey(state.c.location)
                                    ? Icon(Icons.favorite)
                                    : Icon(Icons.favorite_border),
                                onPressed: () {
                                  if (box.containsKey(state.c.location)) {
                                    box.delete(state.c.location);
                                  } else {
                                    box.put(state.c.location, {
                                      "timezone": state.c.timezone,
                                      "favorite": true
                                    });
                                  }
                                },
                              ),
                            ],
                          );
                          // always lsitening to the value of testKey, so if testkey ever changes this text wiget will change as well
                        }),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topRight,
                          end: Alignment.bottomLeft,
                          colors: state.c.temp >= 294.261 ? cList1 : cList2,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      width: 375,
                      height: 250,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                state.c.location,
                                style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.0,
                                    color: Colors.white),
                              ).myPadding(10),
                              Text(
                                state.c.time.toReadable(),
                                style: TextStyle(
                                    fontSize: 15.0, color: Colors.white),
                              ).myPadding(10),
                              //303.2.toFString()
                              Text(
                                state.c.temp.toFString(),
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 60.0,
                                    color: Colors.white),
                              ).myPadding(10),
                              Text(
                                state.c.condition,
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0,
                                    color: Colors.white),
                              ).myPadding(10),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.only(right: 50.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                  image: NetworkImage(state.c.picture),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: state.f.length,
                        itemBuilder: (context, index) {
                          var forecast = state.f[index];

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
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: 50,
                                height: 50,
                                child: Column(
                                  children: [
                                    Text(DateTime.fromMillisecondsSinceEpoch(
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
                          rows: state.t.map((weather) {
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
                                    if (value != null) {
                                      return TextButton(
                                        onPressed: () {
                                          controller.reFetch(value);
                                        },
                                        //pass textstyle from constants files
                                        child: Text(
                                          value,
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

//add valuelistenable around container, so you can see it update. do the same thing we did for profile screen. Implement a listview builder.

//hw design search bar, ui of it
// when i click on the search bar and start typing, i want to set the state of my search screen controller to empty so that i can see my history. when i start typing how can i execute a function.

// in the text input field wiget, theres something that allows me to start typing, when i do start typing, ensure that the state is empty. 

//change the state by doing controller. and call the function in the controller
// search hiveupdatevalue
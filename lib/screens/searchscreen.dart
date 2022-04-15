import 'dart:html';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app_2/constants/colors.dart';
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
        body: Center(
            child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
              Form(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                    TextFormField(
                      controller: controller.textController.value,
                      decoration: const InputDecoration(
                        hintText: 'Search',
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: ElevatedButton(
                          onPressed: () {
                            controller.weatherFetch();
                            print(controller.textController.value.text);
                          },
                          child: const Text('Submit'),
                        ))
                  ])),
              controller.obx((state) {
                print(state!.t);
                return Center(
                  child: Column(children: [
                    // the first thing here is a value listener builder attached to a box, extra
                    Text('${box.get('value')}'),

                    ValueListenableBuilder<Box>(
                        valueListenable: Hive.box('favorites').listenable(),
                        builder: (context, value, _) {
                          print('$value');
                          return Column(
                            children: [
                              IconButton(
                                icon: box.get(state.c.location) ?? false
                                    ? Icon(Icons.favorite)
                                    : Icon(Icons.favorite_border),
                                onPressed: () {
                                  if (box.containsKey(state.c.location)) {
                                    box.put(state.c.location,
                                        !box.get(state.c.location));
                                  } else {
                                    box.put(state.c.location, true);
                                  }

                                  print('result: ${box.get('testKey')}');
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
                            print(weather.picture);
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
                  onEmpty: Container(
                      child: Text(
                          Hive.box('history').get('historyList').toString())))
            ]))));
  }
}

//hw design search bar, ui of it
// when i click on the search bar and start typing, i want to set the state of my search screen controller to empty so that i can see my history. when i start typing how can i execute a function.

// in the text input field wiget, theres something that allows me to start typing, when i do start typing, ensure that the state is empty. 

//change the state by doing controller. and call the function in the controller
// search hiveupdatevalue
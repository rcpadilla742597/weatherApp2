import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:weather_app_2/constants/colors.dart';
import 'package:weather_app_2/controllers/homescreen_controller.dart';
import 'package:weather_app_2/models/homescreen/currentweather_model.dart';
import 'package:weather_app_2/models/homescreen/extenstions.dart';
import 'package:weather_app_2/screens/controlscreen.dart';

class HomeScreen extends GetView<HomeScreenController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: controller.obx(
        (state) {
          print(state!.t);
          return Center(
            child: SingleChildScrollView(
              child: Column(children: [
                SizedBox(
                  height: 15,
                ),
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
                            style:
                                TextStyle(fontSize: 15.0, color: Colors.white),
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
                                                          forecast.time * 1000)
                                                      .hour
                                                      .toString() +
                                                  ":00"),
                                          Image(
                                            image:
                                                NetworkImage(forecast.picture),
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
            ),
          );
        },

        // here you can put your custom loading indicator, but
        // by default would be Center(child:CircularProgressIndicator())
        onLoading: CircularProgressIndicator(),
        onEmpty: Text('No data found'),
        // here also you can set your own error widget, but by
        // default will be an Center(child:Text(error))
        onError: (error) => Text('error'),
      ),
      backgroundColor: Colors.white,
    );
  }
}

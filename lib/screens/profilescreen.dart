import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:weather_app_2/widgets/globalwidgets.dart';
import 'package:weather_app_2/controllers/profilescreencontroller.dart';

class ProfileScreen extends GetView<ProfileScreenController> {
  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
          backgroundColor: controller.editMode(),
          body: ValueListenableBuilder<Box>(
              valueListenable: Hive.box('favorites').listenable(),
              builder: (context, box, _) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            controller.updateEditState();
                          },
                          icon: controller.editIcon()),
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          itemCount: box.keys.length,
                          itemBuilder: (context, index) {
                            // buttonCarouselController.startAutoPlay();
                            if (box.values.toList()[index]['favorite']) {
                              int date = box.values.toList()[index]['timezone'];
                              if (controller.editState) {
                                return Dismissible(
                                  // background: Container(color: Colors.red),
                                  key: Key('card ${index}'),
                                  child: ProfileCard(
                                      box: box, date: date, index: index),
                                );
                              } else {
                                return ProfileCard(
                                    box: box, date: date, index: index);
                              }
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}

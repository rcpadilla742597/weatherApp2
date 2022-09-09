import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:weather_app_2/constants/colors.dart';
import 'package:weather_app_2/constants/textConstants.dart';
import 'package:weather_app_2/controllers/controlScreenController.dart';
import 'package:weather_app_2/controllers/homescreen_controller.dart';
import 'package:weather_app_2/controllers/searchscreencontroller.dart';
import 'package:weather_app_2/models/homescreen/articlemodel.dart';
import 'package:weather_app_2/models/homescreen/currentweather_model.dart';
import 'package:weather_app_2/models/homescreen/extenstions.dart';
import 'package:weather_app_2/screens/controlscreen.dart';
import 'package:weather_app_2/screens/searchscreen.dart';
import '../controllers/networkcontroller.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';

class ProfileScreen extends GetView<HomeScreenController> {
  var csc = Get.find<ControlScreenController>();
  var scc = Get.find<SearchScreenController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ValueListenableBuilder<Box>(
            valueListenable: Hive.box('favorites').listenable(),
            builder: (context, box, _) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(60, 0, 60, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: box.keys.length,
                        itemBuilder: (context, index) {
                          CarouselController buttonCarouselController =
                              CarouselController();
                          // buttonCarouselController.startAutoPlay();
                          if (box.values.toList()[index]['favorite']) {
                            NetworkController controller1 =
                                Get.put(NetworkController(), tag: "$index");
                            controller1.makeList('${box.keys.toList()[index]}');
                            int date = box.values.toList()[index]['timezone'];
                            return card(box, index, date, context, controller1,
                                buttonCarouselController);
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

  Padding card(
      Box<dynamic> box,
      int index,
      int date,
      BuildContext context,
      NetworkController controller1,
      CarouselController buttonCarouselController) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Container(
          height: 350,
          width: 500,
          child: Column(
            children: [
              // Favorited Cities Location & Time
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${box.keys.toList()[index]}', style: profileScreenCard),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextButton.icon(
                        onPressed: () {
                          csc.changeIndex(1);
                          scc.reFetch(box.keys.toList()[index]);
                        },
                        icon: Icon(Icons.cloud),
                        label: Text('View Weather')),
                  ),
                  Text('${date.toDate().format(context)}',
                      style: profileScreenCard),
                ],
              ),
              Expanded(
                child: controller1.obx(
                  (state) {
                    return FlutterCarousel.builder(
                      carouselController: buttonCarouselController,
                      options: CarouselOptions(
                        height: 350.0,
                        aspectRatio: 16 / 9,
                        viewportFraction: 1.0,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlay: true,
                        autoPlayInterval: const Duration(seconds: 1),
                        autoPlayAnimationDuration:
                            const Duration(milliseconds: 800),
                        autoPlayCurve: Curves.easeInOut,
                        enlargeCenterPage: false,
                        pageSnapping: true,
                        scrollDirection: Axis.horizontal,
                        // pauseAutoPlayOnTouch: false,
                        // pauseAutoPlayOnManualNavigate: true,
                        // pauseAutoPlayInFiniteScroll: false,
                        enlargeStrategy: CenterPageEnlargeStrategy.scale,
                        disableCenter: false,
                        showIndicator: true,
                        slideIndicator: CircularSlideIndicator(),
                      ),
                      itemCount: 3,
                      itemBuilder: (context, index2, pageIndex) {
                        var article = state?[index2];

                        return Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      controller1.openUrl(article?.link);
                                      // js.context
                                      //     .callMethod('open', [article?.link]);
                                      print(article?.link);
                                    },
                                    child: LimitedBox(
                                      maxHeight: 255,
                                      child: AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: Image.network(
                                            '${article?.img}',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 20.0),
                                  child: Text(
                                    '${article?.title}',
                                    style: profileScreenCard,
                                    softWrap: false,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ]),
                        );
                      },
                    );
                  },
                  onLoading: const Center(child: CircularProgressIndicator()),
                  onEmpty: const Text('No data found'),
                  // interpolation can be used if the error variable is ever null
                  onError: (error) => Text(error!),
                ),
              )
            ],
          ),
        ));
  }
}

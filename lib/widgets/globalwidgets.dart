import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_carousel_widget/indicators/circular_slide_indicator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:weather_app_2/constants/textConstants.dart';
import 'package:weather_app_2/models/homescreen/extenstions.dart';
import '../controllers/controlScreenController.dart';
import '../controllers/networkcontroller.dart';
import '../controllers/searchscreencontroller.dart';

class ProfileCard extends StatefulWidget {
  ProfileCard({
    required this.box,
    required this.index,
    required this.date,
  });
  Box<dynamic> box;
  int index;
  int date;

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  CarouselController buttonCarouselController = CarouselController();

  var csc = Get.find<ControlScreenController>();

  var scc = Get.find<SearchScreenController>();
  late NetworkController controller1;

  @override
  void initState() {
    super.initState;
    controller1 = Get.put(NetworkController(), tag: widget.index.toString());
    controller1.makeList('${widget.box.keys.toList()[widget.index]}');
  }

  @override
  Widget build(BuildContext context) {
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
                  Text('${widget.box.keys.toList()[widget.index]}',
                      style: profileScreenCard),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: TextButton.icon(
                        onPressed: () {
                          csc.changeIndex(1);
                          scc.reFetch(widget.box.keys.toList()[widget.index]);
                        },
                        icon: Icon(Icons.cloud),
                        label: Text('View Weather')),
                  ),
                  Text('${widget.date.toDate().format(context)}',
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

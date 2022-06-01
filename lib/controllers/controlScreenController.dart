import 'package:get/get.dart';

class ControlScreenController extends GetxController {
  var selectedIndex = 0.obs;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  changeIndex(value) {
    selectedIndex.value = value;
  }
}

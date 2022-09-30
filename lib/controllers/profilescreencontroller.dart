import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:weather_app_2/controllers/searchscreencontroller.dart';
import 'package:weather_app_2/models/weather_model.dart';

class ProfileScreenController extends GetxController
    with StateMixin<WeatherModel> {
  final _testVar = 'hello world'.obs;
  get testVar => this._testVar.value.substring(0, 5);
  set testVar(value) => this._testVar.value = value + ':user';
  get wholeTestVar => this._testVar.value;

  final _editState = false.obs;
  //
  set editState(value) => this._editState.value = value;
  get editState => this._editState.value;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  updateEditState() {
    editState = !editState;
  }

  Icon editIcon() {
    if (editState) {
      return Icon(Icons.edit_off);
    } else {
      return Icon(Icons.edit);
    }
  }

  editMode() {
    if (editState) {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  }
}


import 'dart:ui';

import 'package:blackeco/core/services/localstorage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController{
  late String theme;

  setTheme(String? val){
    if(val!=null){
      Get.find<LocalStorageService>().setTheme(val);
      theme=val;
      changeTheme();
      return;
    }
      theme=Get.find<LocalStorageService>().getTheme()??"light";
    update();
  }

  changeTheme(){
    if(theme=="light"){
      Get.changeThemeMode(ThemeMode.light);
    }
    else{
      Get.changeThemeMode(ThemeMode.dark);
    }
    update();
  }

  setSystemTheme(){
    var brightness = SchedulerBinding.instance!.window.platformBrightness;
    bool darkModeOn = brightness == Brightness.dark;
    if(darkModeOn){
      Get.find<LocalStorageService>().setTheme("dark");
      theme="dark";
    }
    else{
      Get.find<LocalStorageService>().setTheme("light");
      theme='light';
    }
    changeTheme();
    update();
  }

  @override
  void onInit() {
    setTheme(null);
    super.onInit();
  }
}
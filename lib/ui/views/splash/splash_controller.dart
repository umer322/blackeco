import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class SplashController extends GetxController{
  @override
  void onInit() {
    checkStartUpLogic();
    super.onInit();
  }

  checkStartUpLogic(){
    Future.delayed(Duration(seconds: 2),()async{
//      await Get.find<FireBaseAuthService>().signOut();
        if(kIsWeb){
          Get.offNamed("/admindashboard");
        }
        else{
          Get.offNamed("/navigation");
        }
    });
  }
}

import 'package:blackeco/core/services/firebaseauth_service.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{
  TextEditingController? emailController;
  TextEditingController? passwordController;
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();
  bool showPassword=false;

  toggleShowPassword(){
    showPassword=!showPassword;
    update();
  }

  @override
  void onInit() {
    emailController=TextEditingController();
    passwordController=TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailController?.dispose();
    passwordController?.dispose();
    super.onClose();
  }


  login()async{
    try{
      Show.showLoader();
      await Get.find<FireBaseAuthService>().login(email: emailController!.text, password:passwordController!.text);
      Get.back();
      Get.offAllNamed("/navigation");
    }
    catch(e){
      if(Get.isOverlaysOpen){
        Get.back();
      }
      Show.showErrorSnackBar("Error", "$e");
    }
  }
}
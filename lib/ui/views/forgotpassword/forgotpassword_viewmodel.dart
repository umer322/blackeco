
import 'package:blackeco/core/services/firebaseauth_service.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ForgotPasswordViewModel extends GetxController{
  late TextEditingController emailController;
  final forgotPasswordFormKey=GlobalKey<FormState>();

  sendEmail(){
    try{
      Get.find<FireBaseAuthService>().sendEmail(emailController.text);
      emailController.clear();
      Show.showSnackBar("Message","An email has been sent to mentioned email address.Please check your email");
    }
    catch(e){
      Show.showErrorSnackBar("Error","$e");
    }
  }


  @override
  void onInit() {
    emailController=TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
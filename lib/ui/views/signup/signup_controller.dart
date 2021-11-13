

import 'package:blackeco/core/services/firebaseauth_service.dart';
import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/models/user_model.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:blackeco/ui/views/navigationtabs/navigationtabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController{
  TextEditingController? emailController;
  TextEditingController? passwordController;
  UserModel? user;
  String? name;
  GlobalKey<FormState> signupKey = GlobalKey<FormState>();
  bool showPassword1=false;
  bool showPassword2=false;
  bool acceptTermsAndCondition=false;
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

  toggleShowPassword1(){
    showPassword1=!showPassword1;
    update();
  }
  toggleShowPassword2(){
    showPassword2=!showPassword2;
    update();
  }

  toggleAcceptTermsAndCondition(bool? val){
    acceptTermsAndCondition=val!;
    update();
  }

  signUpWithEmailAndPassword()async{
      try{
        Show.showLoader();
        user=UserModel(name: name,email: emailController?.text.trim(),);
        await Get.find<FireBaseAuthService>().signUp(email: emailController?.text.trim(), password: passwordController?.text);
        await Get.find<FireStoreService>().saveUser(Get.find<FireBaseAuthService>().auth.currentUser!.uid,user!);
        Get.find<NavigationTabsController>().index=0;
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
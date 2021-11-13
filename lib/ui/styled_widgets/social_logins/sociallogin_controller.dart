
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:get/get.dart';

class SocialLoginController extends GetxController{
  loginWithFacebook()async{
    try{
      await Get.find<UserController>().loginWithFacebook();
    }
    catch(e){
      print(e);
      Show.showErrorSnackBar("Error", "$e");
    }
  }

  loginWithGoogle()async{
    try{
      await Get.find<UserController>().loginWithGoogle();
    }
    catch(e){
      Show.showErrorSnackBar("Error", "$e");
    }
  }
}
import 'package:blackeco/ui/styled_widgets/social_logins/sociallogin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SocialLogins extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SocialLoginController>(
        init: SocialLoginController(),
        builder: (controller){
      return Row(children: [
        Expanded(child: Center(child: Image.asset("assets/apple.png",height: Get.width*0.2,width: Get.width*0.2,))),
        Expanded(child: GestureDetector(
            onTap: (){
              controller.loginWithFacebook();
            },
            child: Center(child: Image.asset("assets/facebook.png",height: Get.width*0.2,width: Get.width*0.2,)))),
        Expanded(child: GestureDetector(
            onTap: (){
              controller.loginWithGoogle();
            },
            child: Center(child: Image.asset("assets/google.png",height: Get.width*0.2,width: Get.width*0.2,))))
      ],);
    });
  }
}

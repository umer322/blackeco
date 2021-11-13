import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginErrorView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText("Login to access this page",style: TextStyles.title1,),
          SizedBox(height: Get.height*0.02,),
          SizedBox(
            width: Get.width*0.5,
            child: StyledButton(title: "Login"
              ,onPressed: (){
                Get.toNamed("/login");
              },),
          ),
        ],
      ),
    );
  }
}

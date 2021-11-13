import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/social_logins/social_logins.dart';
import 'package:blackeco/ui/styled_widgets/styled_button.dart';
import 'package:blackeco/ui/styled_widgets/styled_textformfield.dart';
import 'package:blackeco/ui/views/login/login_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LoginView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
            child: GetBuilder<LoginController>(builder: (controller){
              return Form(
                key: controller.loginKey,
                child: Column(
                  children: [
                    SizedBox(height: kToolbarHeight,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Hero(tag:"1",child: Image.asset("assets/logo.png",width: Get.width*0.1,)),
                        ),
                        SizedBox(width: 10,),
                        AutoSizeText("Login",style: TextStyles.h2,)
                      ],),
                    SizedBox(height: Get.height*0.03,),
                    StyledTextFormField(
                      controller: controller.emailController,
                      hintText: "Email Address",
                      validator: (String? val){
                        if(val!.isEmpty){
                          return "Email is required";
                        }
                        else if(!GetUtils.isEmail(val)){
                          return "Enter a valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: Get.height*0.02,),
                    StyledTextFormField(
                      controller: controller.passwordController,
                      hintText: "Password",
                      obscureText: !controller.showPassword,
                      validator: (String? val){
                        if(val!.isEmpty){
                          return "Password is required";
                        }
                        else if(val.length<8){
                          return "Password cannot be less than 8 characters";
                        }
                        return null;
                      },
                      suffixIcon: GestureDetector(
                        onTap: controller.toggleShowPassword,
                        child: Icon(controller.showPassword?Icons.visibility_off:Icons.visibility,color: Colors.black,),
                      ),
                    ),
                    SizedBox(height: Get.height*0.01,),
                    Align(alignment: Alignment.centerRight,child: AutoSizeText.rich(TextSpan(
                      children: [
                        TextSpan(
                          text: "Forgot Password?"
                        ),
                      ]
                    )),),
                    SizedBox(height: Get.height*0.02,),
                    StyledButton(title: "Login"
                    ,onPressed: (){
                      if(controller.loginKey.currentState!.validate()){
                        controller.login();
                      }
                      },),
                    SizedBox(height: Get.height*0.03,),
                    Row(children: [
                      Expanded(child: Container(height: 2,color: Theme.of(context).accentColor,),),
                      AutoSizeText(" OR continue with ",style: TextStyles.title1.copyWith(color: Theme.of(context).accentColor),),
                      Expanded(child: Container(height: 2,color: Theme.of(context).accentColor,),),
                    ],),
                    SizedBox(height: Get.height*0.04,),
                    Container(
                        height: Get.height*0.065,
                        child: SocialLogins()),
                    Expanded(child: SizedBox()),
                    AutoSizeText.rich(TextSpan(
                      children: [
                        TextSpan(
                          text: "Don't have an account? "
                        ),
                        TextSpan(
                            text:"Sign Up",
                            style: TextStyle(color: Colors.blue),
                        recognizer: TapGestureRecognizer()..onTap=(){
                              Get.toNamed("/signup");
                        })
                      ],
                    ),presetFontSizes: [FontSizes.s18],),
                    SizedBox(height: Get.height*0.015,)
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

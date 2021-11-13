import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/social_logins/social_logins.dart';
import 'package:blackeco/ui/styled_widgets/styled_button.dart';
import 'package:blackeco/ui/styled_widgets/styled_textformfield.dart';
import 'package:blackeco/ui/views/signup/signup_controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SignUpView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: Get.height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
            child: GetBuilder<SignUpController>(builder: (controller){
              return Form(
                key: controller.signupKey,
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
                        AutoSizeText("Sign Up",style: TextStyles.h2,)
                      ],),
                    SizedBox(height: Get.height*0.01,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Checkbox(value: controller.acceptTermsAndCondition, onChanged: controller.toggleAcceptTermsAndCondition,activeColor: Theme.of(context).primaryColor,),
                      Flexible(
                        child: AutoSizeText.rich(TextSpan(
                          children: [
                            TextSpan(
                                text: "By continuing, I agree to BlackEco's "
                            ),
                            TextSpan(
                                text:"Terms and Services",
                                style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()..onTap=(){

                                }),
                            TextSpan(
                                text: " and acknowledge BlackEco’s "
                            ),
                            TextSpan(
                                text:"Privacy Policy",
                                style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()..onTap=(){
                                }),
                            TextSpan(
                                text: ", including BlackEco’s cookies policy."
                            ),
                          ],
                        ),presetFontSizes: [FontSizes.s14],),
                      ),
                    ],),
                    SizedBox(height: Get.height*0.01,),
                    StyledTextFormField(
                      hintText: "Full Name",
                      validator: (String? val){
                        if(val!.isEmpty){
                          return "Name is required";
                        }
                        return null;
                      },
                      onSaved: (val){
                          controller.name=val;
                      },
                    ),
                    SizedBox(height: Get.height*0.02,),
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
                      obscureText: !controller.showPassword1,
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
                        onTap: controller.toggleShowPassword1,
                        child: Icon(controller.showPassword1?Icons.visibility_off:Icons.visibility,color: Colors.black,),
                      ),
                    ),
                    StyledTextFormField(
                      hintText: "Re-Enter Password",
                      obscureText: !controller.showPassword2,
                      validator: (String? val){
                        if(val!.isEmpty){
                          return "Please verify your password";
                        }
                        else if(val!=controller.passwordController?.text){
                          return "Password doesn't match";
                        }
                        return null;
                      },
                      suffixIcon: GestureDetector(
                        onTap: controller.toggleShowPassword2,
                        child: Icon(controller.showPassword2?Icons.visibility_off:Icons.visibility,color: Colors.black,),
                      ),
                    ),
                    SizedBox(height: Get.height*0.03,),
                    StyledButton(title: "Sign Up"
                      ,onPressed: (){
                        if(controller.signupKey.currentState!.validate()){
                          controller.signupKey.currentState!.save();

                          controller.signUpWithEmailAndPassword();
                        }
                      },),
                    SizedBox(height: Get.height*0.03,),
                    Row(children: [
                      Expanded(child: Container(height: 2,color: Theme.of(context).accentColor,),),
                      AutoSizeText(" OR Sign Up using ",style: TextStyles.title1.copyWith(color: Theme.of(context).accentColor),),
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
                            text: "Already have an account? "
                        ),
                        TextSpan(
                            text:"Login",
                            style: TextStyle(color: Colors.blue),
                            recognizer: TapGestureRecognizer()..onTap=(){
                              Get.back();
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


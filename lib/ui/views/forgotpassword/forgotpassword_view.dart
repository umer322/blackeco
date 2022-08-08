import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/styled_widgets/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'forgotpassword_viewmodel.dart';

class ForgotPasswordView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: AutoSizeText("Forgot Password"),
      ),
      body: GetBuilder<ForgotPasswordViewModel>(
        init: ForgotPasswordViewModel(),
        builder: (model){
        return Form(
          key: model.forgotPasswordFormKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width*0.05,vertical: Get.height*0.01),
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(
                      hintText: "E-mail"),
                  controller: model.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (val){
                    if(val!.isEmpty){
                      return 'Email is required';
                    }
                    else if(!GetUtils.isEmail(val)){
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: Get.height*0.02,),
                StyledButton(onPressed: (){
                    if(model.forgotPasswordFormKey.currentState!.validate()){
                      FocusScope.of(context).requestFocus(FocusNode());
                      model.sendEmail();
                    }
                  },
                  title: "Submit",
                )
              ],
            ),
          ),
        );
      },),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/styled_button.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_view1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBusinessIntro extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Add a Business"),
      ),
      body: Container(
        height: Get.height,
        child: Column(
          children: [
            SizedBox(height: Get.height*0.04,),
              Flexible(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width*0.1),
                child: Image.asset("assets/image1.png"),
              )),
            SizedBox(height: Get.height*0.01,),
            Flexible(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AutoSizeText.rich(TextSpan(
                  children: [
                    TextSpan(
                      text: "Create Black",
                      style: TextStyle(fontWeight: FontWeight.w600)
                    ),
                    TextSpan(
                        text: "Eco ",
                        style: TextStyle(fontWeight: FontWeight.w300,color: Theme.of(context).primaryColor)
                    ),
                    TextSpan(
                        text: "Business Profile",
                        style: TextStyle(fontWeight: FontWeight.w600)
                    )
                  ],
                  style: TextStyles.h2
                )),
                SizedBox(height: Get.height*0.01,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width*0.1),
                  child: AutoSizeText("BlackEco is a platform for listing yours business, growing your business and a way to connect  with potential customers. By having your business on BlackEco you will be able to:",style: TextStyles.body1.copyWith(color: Colors.grey[500]),textAlign: TextAlign.center,),
                )
              ],
            )),
            Expanded(
                flex: 2,
                child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
              child: Container(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height*0.01,),
                    Row(children: [
                      Container(height: Get.width*0.03,width: Get.width*0.03,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.black),),
                      SizedBox(width:Get.width*0.05,),
                      AutoSizeText.rich(TextSpan(
                        children: [
                          TextSpan(
                            text: "Reach the vast "
                          ),
                          TextSpan(
                              text: "Black",
                              style: TextStyle(fontWeight: FontWeight.w600)
                          ),
                          TextSpan(
                              text: "Eco ",
                              style: TextStyle(fontWeight: FontWeight.w300,color: Theme.of(context).primaryColor)
                          ),
                          TextSpan(
                            text: "Community"
                          )
                        ],
                      ),presetFontSizes: [18,16],)

                    ],),
                    SizedBox(height: Get.height*0.01,),
                    Row(children: [
                      Container(height: Get.width*0.03,width: Get.width*0.03,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.black),),
                      SizedBox(width:Get.width*0.05,),
                      Flexible(child: AutoSizeText("Increase your social media traffic.",presetFontSizes: [18,16],))
                    ],),
                    SizedBox(height: Get.height*0.01,),
                    Row(children: [
                      Container(height: Get.width*0.03,width: Get.width*0.03,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.black),),
                      SizedBox(width:Get.width*0.05,),
                      Flexible(child: AutoSizeText("Increase your sales and conversion rates.",presetFontSizes: [18,16],))
                    ],),
                    SizedBox(height: Get.height*0.01,),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Container(height: Get.width*0.03,width: Get.width*0.03,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.black),),
                      SizedBox(width:Get.width*0.05,),
                      Flexible(child: AutoSizeText("Manage your custom  dashboard which will allow you to respond to reviews and see who visit your store/profile.",presetFontSizes: [18,16],))
                    ],),
                    SizedBox(height: Get.height*0.01,),
                    Row(children: [
                      Container(height: Get.width*0.03,width: Get.width*0.03,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.black),),
                      SizedBox(width:Get.width*0.05,),
                      Flexible(child: AutoSizeText("Get access to powerful adverting tools",presetFontSizes: [18,16],))
                    ],),
                    SizedBox(height: Get.height*0.01,),
                    Row(children: [
                      Container(height: Get.width*0.03,width: Get.width*0.03,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.black),),
                      SizedBox(width:Get.width*0.05,),
                      Flexible(child: AutoSizeText("Free for a limited time.",presetFontSizes: [18,16],))
                    ],),
                    SizedBox(height: Get.height*0.02,),
                    StyledButton(title: "Start"
                      ,onPressed: (){
                          Get.to(()=>AddBusinessViewOne());
                      },),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}

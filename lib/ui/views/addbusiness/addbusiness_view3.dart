import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/models/social_media_data.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/styled_button.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddBusinessViewThree extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Add a Business"),
      ),
      body: GetBuilder<AddBusinessController>(builder: (controller){
        return SingleChildScrollView(
          child: Container(
            height: Get.height-(kToolbarHeight+Get.height*0.03),
            width: Get.width,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Get.height*0.02,
                  ),
                  AutoSizeText("Add Business Social Media ",style: TextStyles.h2.copyWith(color: Theme.of(context).primaryColor),),
                  SizedBox(
                    height: Get.height*0.02,
                  ),
                  for(SocialMediaData media in controller.businessData!.socialData!)
                    Column(children: [
                      Row(children: [
                        Image.asset(media.icon!,width: Get.width*0.05,),
                        SizedBox(width: Get.width*0.05,),
                        AutoSizeText(media.name!,style: TextStyles.h2,)
                      ],),
                      Padding(
                        padding:  EdgeInsets.only(bottom: Get.height*0.03),
                        child: TextFormField(
                          initialValue: media.url,
                          onChanged: (val){
                            media.url=val;
                          },
                          decoration: InputDecoration(
                            hintText: "Add your link"
                          ),
                        ),
                      ),
                    ],),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(child: Container(
                        width: Get.width*0.25,
                        child: StyledButton(
                            onPressed: (){
                              controller.uploadBusiness();
                            },
                            title: "Done"),
                      ))
                    ],
                  ),
                  SizedBox(height: Get.height*0.03,),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}

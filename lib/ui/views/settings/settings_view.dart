import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/views/settings/apptheme_view.dart';
import 'package:blackeco/ui/views/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SettingsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(
        init: SettingsController(),
        builder: (controller){
      return Scaffold(
        appBar: AppBar(
          title: AutoSizeText("Settings"),
        ),
        body: Padding(
          padding:  EdgeInsets.symmetric(horizontal: Get.width*0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height*0.03,),
              AutoSizeText("Display",style: TextStyles.h1.copyWith(color: Theme.of(context).primaryColor),),
              ListTile(
                onTap: (){
                  Get.to(()=>AppThemeView());
                },
                contentPadding: EdgeInsets.all(0),
                title: AutoSizeText("App Theme"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              AutoSizeText("Notifications",style: TextStyles.h1.copyWith(color: Theme.of(context).primaryColor),),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: AutoSizeText("Email Notification"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: AutoSizeText("Push Notification"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              AutoSizeText("Privacy",style: TextStyles.h1.copyWith(color: Theme.of(context).primaryColor),),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: AutoSizeText("Privacy Setrings"),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
              ListTile(
                title: AutoSizeText("Clear History"),
                contentPadding: EdgeInsets.all(0),
              ),
            ],
          ),
        ),
      );
    });
  }
}

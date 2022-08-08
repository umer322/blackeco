import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/views/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppThemeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (controller){
      return Scaffold(
        appBar: AppBar(
          title: AutoSizeText("Display"),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height*0.03,),
              AutoSizeText("App Theme",style: TextStyles.h1.copyWith(color: Theme.of(context).primaryColor),),
              ListTile(
                contentPadding: EdgeInsets.all(0),
                title: AutoSizeText("Light"),
                onTap: (){
                  controller.setTheme("light");
                },
                trailing: controller.theme=="light"?Icon(Icons.done):SizedBox(),
              ),
              ListTile(
                onTap: (){
                  controller.setTheme("dark");
                },
                trailing: controller.theme=="dark"?Icon(Icons.done):SizedBox(),
                contentPadding: EdgeInsets.all(0),
                title: AutoSizeText("Dark"),
              ),
              ListTile(
                onTap: (){
                  controller.setSystemTheme();
                },
                contentPadding: EdgeInsets.all(0),
                title: AutoSizeText("System Default"),
                subtitle: AutoSizeText("Light or dark theme will be selected according to device settings."),
              ),
            ],
          ),
        ),
      );
    });
  }
}

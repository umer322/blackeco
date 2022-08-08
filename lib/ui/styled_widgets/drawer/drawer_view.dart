import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/drawer/drawer_controller.dart';
import 'package:blackeco/ui/views/aboutus/aboutus_view.dart';
import 'package:blackeco/ui/views/contactus/contactus_view.dart';
import 'package:blackeco/ui/views/mybusiness/mybusinesses_view.dart';
import 'package:blackeco/ui/views/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DrawerView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: AppDrawerController(),
        builder: (controller){
          return Drawer(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
              child: Column(
                children: [
                  SizedBox(height: kToolbarHeight,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset("assets/logo.png",width: Get.width*0.15,),
                      AutoSizeText.rich(TextSpan(
                        children: [
                          TextSpan(
                            text: "Black",
                            style: TextStyle(color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.w800)
                          ),
                          TextSpan(
                            text: "Eco",
                            style: TextStyle(color: Theme.of(context).primaryColor,)
                          ),
                          TextSpan(
                            text: "\u1d40\u1d39",
                              style: TextStyle(fontSize: FontSizes.s10,)
                          )
                        ]
                      ),presetFontSizes: [FontSizes.s24],)
                    ],
                  ),
                  SizedBox(height: Get.height*0.02,),
                  Divider(),
                  Obx((){
                    return Get.find<BusinessesController>().myBusinesses.length>0?
                    ListTile(
                      onTap: (){
                        Get.to(()=>MyBusinessesView());
                      },
                      leading: Icon(Icons.business_center_outlined),
                      title: AutoSizeText("My Business(es)"),
                    ):
                    ListTile(
                      onTap: (){
                        if(Get.find<UserController>().currentUser.value.id==null){
                          Show.showErrorSnackBar("Error", "Please login to continue");
                        }
                        else{
                          Get.toNamed("/addbusiness");
                        }
                      },
                      leading: Icon(Icons.business_center_outlined),
                      title: AutoSizeText("Add a Business"),
                    );
                  }),
                  Divider(),
                  ListTile(
                    onTap: (){
                      Get.to(()=>AboutUsView());
                    },
                    leading: Icon(Icons.info_outline),
                    title: AutoSizeText.rich(TextSpan(
                        children: [
                          TextSpan(
                              text: "About ",
                              style: TextStyle(color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.w300)
                          ),
                          TextSpan(
                              text: "Black",
                              style: TextStyle(color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.w600)
                          ),
                          TextSpan(
                              text: "Eco",
                              style: TextStyle(color: Theme.of(context).primaryColor,)
                          ),
                          TextSpan(
                              text: "\u1d40\u1d39",
                              style: TextStyle(fontSize: FontSizes.s10,)
                          )
                        ]
                    ),presetFontSizes: [FontSizes.s16],),
                  ),
                  ListTile(
                    onTap: (){},
                    leading: Icon(Icons.share),
                    title: AutoSizeText.rich(TextSpan(
                        children: [
                          TextSpan(
                              text: "Share ",
                              style: TextStyle(color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.w300)
                          ),
                          TextSpan(
                              text: "Black",
                              style: TextStyle(color: Theme.of(context).primaryColorDark,fontWeight: FontWeight.w600)
                          ),
                          TextSpan(
                              text: "Eco",
                              style: TextStyle(color: Theme.of(context).primaryColor,)
                          ),
                          TextSpan(
                              text: "\u1d40\u1d39",
                              style: TextStyle(fontSize: FontSizes.s10,)
                          )
                        ]
                    ),presetFontSizes: [FontSizes.s16],),
                  ),
                  ListTile(
                    onTap: (){
                      if(Get.find<UserController>().currentUser.value.id==null){
                        Show.showErrorSnackBar("Error", "Please login to continue");
                      }
                      else{
                        Get.to(()=>ContactUsView());
                      }
                    },
                    leading: Icon(Icons.help_center_outlined),
                    title: AutoSizeText("Help Center"),
                  ),
                  Spacer(),
                  Divider(),
                  ListTile(
                    onTap: (){
                      Get.to(()=>SettingsView());
                    },
                    leading: Icon(Icons.settings_outlined),
                    title: AutoSizeText("Settings"),
                    trailing: Icon(Icons.lightbulb_outline,color: Theme.of(context).primaryColor,),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

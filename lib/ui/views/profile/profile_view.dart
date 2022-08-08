import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/drawer/drawer_view.dart';
import 'package:blackeco/ui/styled_widgets/styled_button.dart';
import 'package:blackeco/ui/views/contactus/contactus_view.dart';
import 'package:blackeco/ui/views/mybusiness/mybusinesses_view.dart';
import 'package:blackeco/ui/views/profile/profileedit_view.dart';
import 'package:blackeco/ui/views/settings/settings_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProfileView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerView(),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
          title: AutoSizeText("Profile"),
          actions: [IconButton(onPressed: (){
            Get.to(()=>SettingsView());
          }, icon: Icon(Icons.settings))],
        ),
        body:Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
          child: Column(
            children: [
              SizedBox(
                height: Get.height*0.02,
              ),
              Obx((){

                return Get.find<UserController>().currentUser.value.id==null?StyledButton(title: "Login to your account"
                  ,onPressed: (){
                    Get.toNamed("/login");
                  },):ListTile(
                  onTap: (){
                    Get.to(ProfileEditView());
                  },
                  leading: CircleAvatar(
                    foregroundImage: Get.find<UserController>().currentUser.value.imageUrl==null?AssetImage("assets/person.png") as ImageProvider:CachedNetworkImageProvider(
                        Get.find<UserController>().currentUser.value.imageUrl!
                    ),
                  ),
                  title: AutoSizeText(Get.find<UserController>().currentUser.value.name!,style: TextStyles.title1,),
                  trailing: AutoSizeText("Edit",style: TextStyles.title2.copyWith(color: Theme.of(context).primaryColorDark),),
                );
              }),
              SizedBox(
                height: Get.height*0.02,
              ),
              Divider(
                thickness: 2,
              ),
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
              // Obx((){
              //   return Get.find<UserController>().currentUser.value.id==null?SizedBox():ListTile(
              //     leading: Icon(Icons.shopping_bag),
              //     title: AutoSizeText("My Impact"),
              //   );
              // }),
              Obx((){
                return Get.find<UserController>().currentUser.value.id==null?SizedBox():ListTile(
                  onTap: (){
                    Get.to(()=>ContactUsView());
                  },
                  leading: Icon(Icons.inbox),
                  title: AutoSizeText("Contact Us"),
                );
              }),
              Obx((){
                return Get.find<UserController>().currentUser.value.id==null?SizedBox():ListTile(
                  onTap: ()async{
                    await Get.defaultDialog(title: "Logout",middleText: "Are you sure you want to logout?",
                      titleStyle: TextStyle(color: Theme.of(context).primaryColorDark),
                      cancel: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),onPressed: (){
                        Get.back();
                      },child: Text("No",style: TextStyle(color: Theme.of(context).primaryColorLight),),
                      ),confirm: ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),onPressed: ()async{
                        Get.back();
                        Show.showLoader();
                        try{
                          await Get.find<UserController>().signOut();
                          if(Get.isOverlaysOpen){
                            Get.back();
                          }
                        }
                        catch(e){
                          if(Get.isOverlaysOpen){
                            Get.back();
                          }
                          Show.showErrorSnackBar("Error", "$e");
                        }
                      },child: Text("Yes",style: TextStyle(color:Theme.of(context).primaryColorLight),),
                      ),);
                  },
                  leading: Icon(Icons.logout_outlined),
                  title: AutoSizeText("Log Out"),
                );
              }),
            ],
          ),
        ),
      );
  }
}

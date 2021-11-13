import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/location_service.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/views/profile/profile_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileEditView extends GetView<ProfileEditController> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileEditController>(
        init: ProfileEditController(),
        builder: (controller){
      return Scaffold(
        appBar: AppBar(
          title: AutoSizeText("Edit Profile"),
          actions: [controller.edit?TextButton(onPressed: (){
            controller.updateUser();
          }, child: AutoSizeText("Save")):SizedBox()],
        ),
        body: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height*0.02,),
                    Stack(
                      children: [
                        Container(
                          height: Get.height*0.12,
                          width: Get.height*0.12,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black54),
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: controller.imageUrl!=null?Image.file(File(controller.imageUrl!,),fit: BoxFit.cover,):Get.find<UserController>().currentUser.value.imageUrl!=null?CachedNetworkImage(imageUrl: Get.find<UserController>().currentUser.value.imageUrl!,fit: BoxFit.cover,):Image.asset("assets/person.png",fit: BoxFit.cover,),
                          ),
                        ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: controller.setImage,
                              child: Container(
                                height: Get.width*0.1,
                                width: Get.width*0.1,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Center(child: Icon(Icons.camera_alt,color: Theme.of(context).primaryColor,),),
                              ),
                            ))
                      ],
                    ),
                    SizedBox(height: Get.height*0.02,),
                    AutoSizeText("Name",style: TextStyles.title1.copyWith(color: Theme.of(context).accentColor),),
                    TextFormField(
                      initialValue: controller.user.name,
                      onChanged: (val){
                        controller.user.name=val;
                        controller.edit=true;
                        controller.update();
                      },
                    ),
                    SizedBox(height: Get.height*0.02,),
                    AutoSizeText("Location",style: TextStyles.title1.copyWith(color: Theme.of(context).accentColor),),
                    TextFormField(
                      controller: controller.locationController,
                      readOnly: true,
                      onTap: ()async{
                        var data =await Get.find<LocationService>().getLocation();
                        if(data!=null){
                          controller.user.location=data;
                          controller.locationController.text=data.city!;
                          controller.edit=true;
                          controller.update();
                        }
                      },
                    )
                  ],),
              ),
      );
    });
  }
}

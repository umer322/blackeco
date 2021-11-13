

import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/multimedia_service.dart';
import 'package:blackeco/models/user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ProfileEditController extends GetxController{
  String? imageUrl;
  bool edit=false;
  late UserModel user;
  late TextEditingController locationController;

  setImage()async{
    final multiMediaService=Get.find<MultiMediaService>();
    SelectImage? type=await multiMediaService.selectImageFrom();
    if(type!=null){
      String? image=await multiMediaService.pickImage(type);
      if(image!=null){
        imageUrl=image;
        edit=true;
        update();
      }
    }
    update();
  }

  updateUser(){
    if(imageUrl!=null){
      user.imageUrl=imageUrl;
    }
    Get.find<UserController>().updateUser(user);
    Get.back();
  }

  @override
  void onInit() {
    locationController=TextEditingController();
    user=UserModel.fromJson(Get.find<UserController>().currentUser.value.toMap(), Get.find<UserController>().currentUser.value.id!);
    if(user.location!=null){
      locationController.text=user.location!.city!;
    }
    super.onInit();
  }

}
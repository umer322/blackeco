

import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/services/multimedia_service.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/models/day_time_picker.dart';
import 'package:blackeco/models/social_media_data.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_wait.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AddBusinessController extends GetxController{
  BusinessData? businessData;
  late TextEditingController businessLocationController;
  late TextEditingController tagsController;
  bool edit=false;
  AddBusinessController({this.businessData});
  selectCoverImage()async{
    SelectImage? data = await Get.find<MultiMediaService>().selectImageFrom();
    if(data!=null){
      String? image=await Get.find<MultiMediaService>().pickImage(data);
      if(image!=null){
        var croppedImage=await Get.find<MultiMediaService>().cropImage(image);
        if(croppedImage!=null){
          businessData!.coverImage=croppedImage;
          update();
        }

      }
    }
  }


  uploadBusiness(){
    try{
      if(edit){
        Get.find<BusinessesController>().updateBusiness(businessData!);
      }
      else{
        Get.find<BusinessesController>().uploadBusiness(businessData!);
      }
      Get.until((route) => route.isFirst);
      Get.to(()=>AddBusinessWait(edit));
    }
    catch(e){
      Show.showErrorSnackBar("Error", "$e");
    }
  }

  loadServiceImages(BuildContext context)async{
    var data= await Get.find<MultiMediaService>().getImages(context);
    if(data!=null){
      businessData!.menuImages!.addAll(data);
      update();
    }
  }

  loadImages(BuildContext context)async{
    var data= await Get.find<MultiMediaService>().getImages(context);
    if(data!=null){
      businessData!.images!.addAll(data);
      update();
    }
  }

  initializeBusinessData(){
    businessData=BusinessData();
    businessData!.timeData=AppTimeData.timeList;
    businessData!.images=[];
    businessData!.menuImages=[];
    businessData!.favorites=[];
    businessData!.tags=[];
    businessData!.socialData=[];
    businessData!.socialData!.addAll(SocialMediaData.mediaSitesDropdown.map((e) => SocialMediaData.fromJson(e)).toList());
  }
  @override
  void onInit() {
    tagsController=TextEditingController();
    businessLocationController=TextEditingController();
   if(businessData==null){
     initializeBusinessData();
   }
   else{
     edit=true;
     businessLocationController.text=businessData!.location!.formattedAddress!;
   }

    super.onInit();
  }
}
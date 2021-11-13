

import 'dart:async';

import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController{
 List<String> tags=[];
 late List<BusinessData> favorites;
 late StreamSubscription businessDataSubscription;
 bool showGroupView=false;

 changeGroupView(bool value){
   if(value){
     setGroups();
   }
   showGroupView=value;
   update();
 }


 setGroups(){
   favorites.forEach((element) {
     tags.add(element.category!);
   });
   tags=tags.toSet().toList();
 }


 listenToBusinessDataChange(){
   favorites=Get.find<BusinessesController>().businesses.where((e) => e.favorites!.contains(Get.find<UserController>().currentUser.value.id)).toList();
   businessDataSubscription=Get.find<BusinessesController>().businesses.listen((data) {
     favorites=data.where((element) => element.favorites!.contains(Get.find<UserController>().currentUser.value.id)).toList();
     update();
   });
 }

 @override
  void onInit() {
    listenToBusinessDataChange();
    super.onInit();
  }
 @override
 void onClose() {
   businessDataSubscription.cancel();
   super.onClose();
 }
}
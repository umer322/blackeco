

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
   tags.clear();
   favorites.forEach((element) {
     tags.add(element.category!);
   });
   tags=tags.toSet().toList();
 }


 listenToBusinessDataChange(){

   setFavorites(Get.find<UserController>().currentUser.value.favorites!, Get.find<BusinessesController>().businesses);
   businessDataSubscription=Get.find<UserController>().currentUser.listen((data) {
     setFavorites(data.favorites??[],  Get.find<BusinessesController>().businesses);
   });
 }

 setFavorites(List<String> favoritesList,List<BusinessData> businesses){
   favorites=favoritesList.map((e) => businesses.firstWhere((element) => element.id==e)).toList();
   setGroups();
   update();
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
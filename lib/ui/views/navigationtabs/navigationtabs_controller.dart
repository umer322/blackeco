
import 'package:blackeco/ui/views/dashboard/dashboard_view.dart';
import 'package:blackeco/ui/views/favorites/favorites_view.dart';
import 'package:blackeco/ui/views/messages/messages_view.dart';
import 'package:blackeco/ui/views/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationTabsController extends GetxController{
  int index =0;
  List<Widget> tabs=[
    DashboardView(),
    MessagesView(),
    FavoritesView(),
    ProfileView()
  ];

  Future<bool> onPop(BuildContext context)async{
    if(index!=0){
      index=0;
      update();
      return false;
    }
    bool value=await Get.defaultDialog(
      title: "Leave App",
      middleText: "Are you sure you want to leave this app?",
      onConfirm: (){
        Get.back(result: true);
      },
        buttonColor: Theme.of(context).primaryColor,
      onCancel: (){
        Get.back(result: false);
    },
      textConfirm: "Yes",
      textCancel: "No"
    );
    return value;
  }

  void changeTab(int tab){
    index=tab;
    update();
  }
}
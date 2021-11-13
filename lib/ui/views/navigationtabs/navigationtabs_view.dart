import 'package:blackeco/ui/views/navigationtabs/navigationtabs_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class NavigationTabsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationTabsController>(builder: (controller){
      return WillPopScope(child: Scaffold(
        body: IndexedStack(
          children: controller.tabs,
          index: controller.index,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: controller.changeTab,
          currentIndex: controller.index,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.explore),label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.forum_outlined),label: "Inbox"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border),label: "Favorites"),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline),label: "Me")
          ],
        ),
      ), onWillPop: ()async{
        bool value=await controller.onPop(context);
        return value;
      });
    });
  }
}

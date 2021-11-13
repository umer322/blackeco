import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/admin/views/claimbusiness/claimbusiness_view.dart';
import 'package:blackeco/ui/admin/views/complain/complains_view.dart';
import 'package:blackeco/ui/admin/views/dashboard/admindashboard_controller.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminDashBoardView extends StatelessWidget {
  const AdminDashBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminDashboardController>(builder: (controller){
      return Scaffold(
          appBar: AppBar(
            title: AutoSizeText("Dashboard"),
          ),
        body: Row(children: [
          NavigationRail(
            leading: SizedBox(
                height: 60,
                child: Image.asset("assets/logo.png")),
            extended: true,
            elevation: 10,
            selectedLabelTextStyle: TextStyles.h3,
            destinations: [
              NavigationRailDestination(icon: Icon(Icons.speed_outlined), label: AutoSizeText("Reports")),
              NavigationRailDestination(icon: Icon(Icons.search), label: AutoSizeText("Claim Business")),
            ], selectedIndex: controller.selectedIndex,
            onDestinationSelected: controller.changeIndex,
          ),
          Expanded(child: IndexedStack(
            index: controller.selectedIndex,
            children: [
              ComplainsView(),
              ClaimBusinessView()
            ],
          ))
        ],),
      );
    });
  }
}

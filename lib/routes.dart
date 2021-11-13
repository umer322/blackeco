import 'package:blackeco/ui/admin/views/dashboard/admindashboard_controller.dart';
import 'package:blackeco/ui/admin/views/dashboard/admindashboard_view.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_controller.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_intro.dart';
import 'package:blackeco/ui/views/dashboard/dashboard_controller.dart';
import 'package:blackeco/ui/views/dashboard/dashboard_view.dart';
import 'package:blackeco/ui/views/login/login_controller.dart';
import 'package:blackeco/ui/views/login/login_view.dart';
import 'package:blackeco/ui/views/navigationtabs/navigationtabs_controller.dart';
import 'package:blackeco/ui/views/navigationtabs/navigationtabs_view.dart';
import 'package:blackeco/ui/views/signup/signup_controller.dart';
import 'package:blackeco/ui/views/signup/signup_view.dart';
import 'package:blackeco/ui/views/splash/splash_controller.dart';
import 'package:blackeco/ui/views/splash/splash_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class Routes {
  static List<GetPage> pages=[
      GetPage(name: "/splash", page: ()=>SplashScreen(),binding: BindingsBuilder((){
        Get.put(SplashController());
      })),
    GetPage(name: "/login", page: ()=>LoginView(),binding: BindingsBuilder((){
      Get.put(LoginController());
    })),
    GetPage(name: "/signup", page: ()=>SignUpView(),binding: BindingsBuilder((){
      Get.put(SignUpController());
    })),
    GetPage(name: "/dashboard", page: ()=>DashboardView(),binding: BindingsBuilder((){
      Get.put(DashboardController());
    })),
    GetPage(name: "/navigation", page: ()=>NavigationTabsView(),settings: RouteSettings(name: "Navigation"),binding: BindingsBuilder((){
      Get.put(NavigationTabsController());
    })),
    GetPage(name: "/addbusiness", page: ()=>AddBusinessIntro(),binding: BindingsBuilder((){
      Get.put(AddBusinessController());
    })),
    GetPage(name: "/admindashboard", page: ()=>AdminDashBoardView(),binding: BindingsBuilder((){
      Get.put(AdminDashboardController());
    }))
  ];
}
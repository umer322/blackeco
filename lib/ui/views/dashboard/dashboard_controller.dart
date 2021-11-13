

import 'dart:async';

import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/services/localstorage_service.dart';
import 'package:blackeco/core/services/location_service.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/models/location.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController{

  String? location;

  List<BusinessData> topRatedBusinesses=[];
  List<BusinessData> newBusinesses=[];
  List<BusinessData> recentBusinesses=[];

  late StreamSubscription listenToBusinesses;

  late StreamSubscription listenToRecentBusinesses;


  setBusinessesList(){
    topRatedBusinesses=List.from(Get.find<BusinessesController>().businesses);
    recentBusinesses=List.from(Get.find<BusinessesController>().recentBusinesses);
    newBusinesses=List.from(topRatedBusinesses);
    newBusinesses.sort((a,b)=>b.date!.compareTo(a.date!));
    topRatedBusinesses.sort((a,b)=>b.rating!.compareTo(a.rating!));

    listenToRecentBusinesses=Get.find<BusinessesController>().recentBusinesses.listen((data) {
      recentBusinesses=List.from(data);
      update();
    });

    listenToBusinesses=Get.find<BusinessesController>().businesses.listen((data) {
      topRatedBusinesses=List.from(data);
      newBusinesses=List.from(topRatedBusinesses);
      newBusinesses.sort((a,b)=>b.date!.compareTo(a.date!));
      topRatedBusinesses.sort((a,b)=>b.rating!.compareTo(a.rating!));
      update();
    });
  }



  setSearchFromStorage(){
    Map data=Get.find<LocalStorageService>().getLocation();
    if(data.isNotEmpty){
      LocationModel newLocation=LocationModel.fromJson(data);
      location=newLocation.city;
    }
    update();
  }

  setSearchLocation()async{
    var data =await Get.find<LocationService>().getLocation();
    if(data!=null){
      location=data.city;
      Get.find<LocalStorageService>().setLocation(data.toMap());
      update();
    }
  }

  @override
  void onInit() {
    setSearchFromStorage();
    setBusinessesList();
    super.onInit();
  }

  @override
  void onClose() {
    listenToRecentBusinesses.cancel();
    listenToBusinesses.cancel();
    super.onClose();
  }

}


import 'package:blackeco/models/business_data.dart';
import 'package:get/get.dart';

class SingleCategoryController extends GetxController{
  final List<BusinessData> businesses;
  int searchType=0;
  SingleCategoryController({required this.businesses});

  changeSearchType(val,bool fromRadio){
    searchType=val;
    print("selecting $val");
    if(val==0){
      businesses.sort((a,b)=>b.date!.compareTo(a.date!));
    }else{
      businesses.sort((a,b)=>b.rating!.compareTo(a.rating!));
    }
    if(Get.isOverlaysOpen){
      Get.back();
    }
    if(fromRadio){
      Get.back();
    }
    update();
  }

}
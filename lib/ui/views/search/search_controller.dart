
import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:get/get.dart';

class SearchController extends GetxController{
  List<BusinessData> searchedList=[];

  onSearch(String data){
    String val=data.toLowerCase();
    if(val.isEmpty){
      searchedList=List.from(Get.find<BusinessesController>().businesses);
    }
    else{
      List<BusinessData> allBusinesses=List.from(Get.find<BusinessesController>().businesses);
      searchedList=allBusinesses.where((element) => element.name!.toLowerCase().contains(val)||element.category!.toLowerCase().contains(val)||element.tags!.where((e) => e.toLowerCase().contains(val)).toList().length>0).toList();
    }
   update();
  }

  @override
  void onInit() {
    searchedList=List.from(Get.find<BusinessesController>().businesses);
    super.onInit();
  }
}

import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:get/get.dart';

class MyBusinessesController extends GetxController{
  List<BusinessData> businesses=[];

  getUserBusinesses(){
    businesses=List.from(Get.find<BusinessesController>().myBusinesses);
    update();
  }

  @override
  void onInit() {
    getUserBusinesses();
    super.onInit();
  }
}
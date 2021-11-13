
import 'package:get/get.dart';

class AdminDashboardController extends GetxController{
  int selectedIndex=0;


  changeIndex(int index){
    selectedIndex=index;
    update();
  }

}


import 'dart:async';

import 'package:blackeco/core/controllers/reports_controller.dart';
import 'package:blackeco/models/report_model.dart';
import 'package:get/get.dart';

class ComplainsController extends GetxController{
  List<ReportModel> reports=[];
  late StreamSubscription reportsSubscription;

  setReports(){
    reports=List.from(Get.find<ReportsController>().reportsList);
    reportsSubscription=Get.find<ReportsController>().reportsList.listen((data) {
     setReportsList(List.from(data));
    });
    update();
  }

  setReportsList(List<ReportModel> data){
    reports.clear();
    reports=data;
    update();
  }

  checkReportStatus(String? status){
    List<ReportModel> allReports=List.from(Get.find<ReportsController>().reportsList);
    if(status=="All"){
      reports.clear();
      reports=allReports;
      update();
      return;
    }
    else if(status=="Open"){
      reports=allReports.where((element) => !element.closed!).toList();
      update();
    }
    else if(status=="Closed"){
      reports=allReports.where((element) => element.closed!).toList();
      update();
    }
  }

  void checkReportType(String? type){
    List<ReportModel> allReports=List.from(Get.find<ReportsController>().reportsList);
    if(type=="All"){
      reports.clear();
      reports=List.from(Get.find<ReportsController>().reportsList);
      update();
      return;
    }

    reports=allReports.where((element) => element.issueType==type).toList();
    update();
  }

  @override
  void onInit() {
    setReports();
    super.onInit();
  }

  @override
  void onClose() {
    reportsSubscription.cancel();
    super.onClose();
  }
}
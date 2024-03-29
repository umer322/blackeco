
import 'dart:async';

import 'package:blackeco/core/controllers/reports_controller.dart';
import 'package:blackeco/models/report_model.dart';
import 'package:get/get.dart';

class ClaimBusinessController extends GetxController{
  List<ReportModel> reports=[];
  late StreamSubscription reportsSubscription;

  setReports(){
    reports=List.from(Get.find<ReportsController>().claimReportsList);
    reportsSubscription=Get.find<ReportsController>().claimReportsList.listen((data) {
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
    List<ReportModel> allReports=List.from(Get.find<ReportsController>().claimReportsList);
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
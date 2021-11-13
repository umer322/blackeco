
import 'dart:async';

import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/models/report_model.dart';
import 'package:get/get.dart';

class ReportsController extends GetxService{
  RxList<ReportModel> allReportsList=RxList([]);
  RxList<ReportModel> reportsList=RxList([]);
  RxList<ReportModel> claimReportsList=RxList([]);
  late StreamSubscription reportsSubscription;

  listenToReports(){
    reportsSubscription=Get.find<FireStoreService>().allReports().listen((event) {
      reportsList.clear();
      claimReportsList.clear();
      allReportsList.clear();
      List<ReportModel> allReports=event.docs.map((e) => ReportModel.fromJson(e.data() as Map, e.id)).toList();
      allReportsList.addAll(allReports);
      reportsList.addAll(allReports.where((element) => !element.claimType!));
      claimReportsList.addAll(allReports.where((element) => element.claimType!));
    });
  }

  updateReport(ReportModel report)async{
    try{
      await Get.find<FireStoreService>().updateReport(report);
    }
    catch(e){
      rethrow;
    }
  }

  @override
  void onInit() {
    listenToReports();
    super.onInit();
  }

  @override
  void onClose() {
    reportsSubscription.cancel();
    super.onClose();
  }
}
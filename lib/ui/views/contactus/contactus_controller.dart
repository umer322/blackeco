
import 'dart:async';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/models/report_model.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:blackeco/ui/views/contactus/reportsubmitted_view.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ContactUsController extends GetxController{

  String reportType="All";
  String? issueType;
  List<ReportModel> reports=[];
  late ReportModel userReport;
  late GlobalKey<FormState> formKey=GlobalKey();
  late StreamSubscription reportsStreamSubscription;

  setReportsStream(){
    reports=List.from(Get.find<UserController>().reports);
    reportsStreamSubscription=Get.find<UserController>().reports.listen((data) {
      reports=List.from(data);
      print(data.length);
      update();
    });
  }


  setUserReport(){
    userReport=ReportModel();
  }

  pickFile()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if(result != null) {
      userReport.fileUrl=result.files.single.path;
      update();
    }
  }

  sendReport()async{
    try{
      if(userReport.issueType==null){
        userReport.issueType=issueType;
      }
      userReport.userName=Get.find<UserController>().currentUser.value.name;
      userReport.userPicture=Get.find<UserController>().currentUser.value.imageUrl;
      userReport.closed=false;
      userReport.reportStatus=0;
      userReport.date=DateTime.now();
      userReport.userId=Get.find<UserController>().currentUser.value.id;
      Show.showLoader();
      String id=await Get.find<FireStoreService>().sendReport(userReport);
      if(Get.isOverlaysOpen){
        Get.back();
      }
      Get.off(()=>ReportSubmittedView(id));
    }
    catch(e){
      if(Get.isOverlaysOpen){
        Get.back();
      }
        Show.showErrorSnackBar("Error", "$e");
    }
  }

  void changeIssueType(String? val){
    issueType=val;
    update();
  }

  void changeReportType(String? val){
    reportType=val!;
    List<ReportModel> allReports=List.from(Get.find<UserController>().reports);
    if(val=="All"){
      reports.clear();
      reports=allReports;
    }
    else{
      reports.clear();
      reports=allReports.where((element) => element.issueType==val).toList();
    }
    update();
  }

  @override
  void onInit() {
    setUserReport();
    setReportsStream();
    super.onInit();
  }
  @override
  void onClose() {
    reportsStreamSubscription.cancel();
    super.onClose();
  }
}
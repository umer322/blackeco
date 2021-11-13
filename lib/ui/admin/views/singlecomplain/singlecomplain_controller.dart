

import 'dart:async';

import 'package:blackeco/core/controllers/reports_controller.dart';
import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/models/report_model.dart';
import 'package:blackeco/models/reportmessage_model.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SingleComplainController extends GetxController{
  ReportModel report;
  SingleComplainController(this.report);
  late TextEditingController textController;
  late StreamSubscription reportsSubscription;
  late StreamSubscription reportMessagesSubscription;
  List<ReportMessageModel> messages=[];

  listenToReportMessages(){
    reportMessagesSubscription=Get.find<FireStoreService>().reportMessages(report.id!).listen((event) {
      List<ReportMessageModel> reportMessages=event.docs.map((e) => ReportMessageModel.fromJson(e.data() as Map, e.id)).toList();
      messages.clear();
      messages.addAll(reportMessages);
      update();
    });
  }

  listenToSubscriptions(){
    reportsSubscription=Get.find<ReportsController>().allReportsList.listen((data) {
      if(data.length>0){
        report=data.firstWhere((element) => element.id==report.id);
        update();
      }
    });
  }

  updateReport()async{
    Show.showLoader();
    try{
      await Get.find<ReportsController>().updateReport(report);
      if(Get.isOverlaysOpen){
        Get.back();
      }
    }
    catch(e){
      if(Get.isOverlaysOpen){
        Get.back();
      }
      Show.showErrorSnackBar("Error", "$e");
    }
  }

  changeReportStatus(){
    report.closed=!report.closed!;
    updateReport();
  }

  assignBusiness(){
    Get.defaultDialog(
      title: "Assign Business",
      middleText: "Are you sure you want to assign business to this user?",
      onCancel: (){
        Get.back();
      },
        textConfirm: "Yes",
        cancelTextColor: Colors.black,
        confirmTextColor: Colors.red,
      onConfirm: ()async{
        Get.back();
        try{
          await Get.find<FireStoreService>().updateBusinessId(report.businessId!,{"owner_id":report.userId});
          Show.showSnackBar("Message", "Business has been assigned to this user",duration: 5);
        }
        catch(e){
          Show.showErrorSnackBar("Error", "$e");
        }
    }
    );
  }

  sendMessage()async{
    try{
      ReportMessageModel message=ReportMessageModel();
      if(kIsWeb){
        message.fromAdmin=true;
      }
      message.time=DateTime.now();
      message.message=textController.text;
      message.isLoading=false;
      textController.clear();
      await Get.find<FireStoreService>().sendReportMessage(message, report.id!);

    }
    catch(e){
      Show.showErrorSnackBar("Error", "$e");
    }
  }

  formatDate(DateTime time){
    DateTime now=DateTime.now();
    if(now.day==time.day && now.year == time.year && now.month == time.month){
      return DateFormat.jm().format(time);
    }
    else if(now.year == time.year){
      return DateFormat.MMMd().format(time)+" AT "+DateFormat.jm().format(time);
    }
    else{
      return DateFormat.yMMMd().format(time)+" AT "+DateFormat.jm().format(time);
    }
  }

  @override
  void onInit() {
    listenToSubscriptions();
    listenToReportMessages();
    textController=TextEditingController();
    super.onInit();
  }

  @override
  void onClose() {
    reportMessagesSubscription.cancel();
    reportsSubscription.cancel();
    textController.dispose();
    super.onClose();
  }
}
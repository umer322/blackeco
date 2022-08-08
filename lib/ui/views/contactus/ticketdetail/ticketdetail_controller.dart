

import 'dart:async';

import 'package:blackeco/core/controllers/reports_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/models/report_model.dart';
import 'package:blackeco/models/reportmessage_model.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TicketDetailController extends GetxController{
  ReportModel report;
  TicketDetailController(this.report);
  late StreamSubscription reportListenStream;
  late StreamSubscription reportMessagesSubscription;
  late TextEditingController textController;
  List<ReportMessageModel> messages=[];
  listenToReport(){
    reportListenStream=Get.find<UserController>().reports.listen((data) {
      if(data.length>0){
        report=data.firstWhere((element) => report.id==element.id);
      }
      update();
    });
    reportMessagesSubscription=Get.find<FireStoreService>().reportMessages(report.id!).listen((event) {
      List<ReportMessageModel> reportMessages=event.docs.map((e) => ReportMessageModel.fromJson(e.data() as Map, e.id)).toList();
      messages.clear();
      reportMessages.sort((a,b)=>b.time!.compareTo(a.time!));
      messages.addAll(reportMessages);
      update();
    });
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

  updateReport()async{
    Show.showLoader();
    try{
      report.closed=false;
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

  sendMessage()async{
    try{
      ReportMessageModel message=ReportMessageModel();
        message.fromAdmin=false;
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

  @override
  void onInit() {
    listenToReport();
    textController=TextEditingController();
    super.onInit();
  }
  @override
  void onClose() {
    reportListenStream.cancel();
    reportMessagesSubscription.cancel();
    super.onClose();
  }
}
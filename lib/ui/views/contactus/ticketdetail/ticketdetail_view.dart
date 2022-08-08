import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/models/report_model.dart';
import 'package:blackeco/models/reportmessage_model.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/styled_textformfield.dart';
import 'package:blackeco/ui/views/contactus/ticketdetail/ticketdetail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TicketDetailView extends StatelessWidget {
  const TicketDetailView({Key? key,required this.report}) : super(key: key);
  final ReportModel report;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TicketDetailController>(
        init: TicketDetailController(report),
        builder: (controller){
      return Scaffold(
        appBar: AppBar(title: AutoSizeText("Ticket Detail"),centerTitle: true,),
        body: Column(children: [
          Container(
            margin: EdgeInsets.all(Get.height*0.01),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).accentColor,
            ),

            padding: EdgeInsets.all(Get.width*0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AutoSizeText(report.issueType!,style: TextStyles.h1,),
                    controller.report.closed!?AutoSizeText("Closed"):AutoSizeText(controller.report.reportStatus==0?"Pending":"Responded")
                  ],),
                SizedBox(height: 8,),
                AutoSizeText.rich(TextSpan(children: [
                  TextSpan(text: "Ticket id ",style: TextStyles.title2.copyWith(color: Theme.of(context).hintColor)),
                  TextSpan(text: "#"+report.id!,style: TextStyles.title2)
                ])),
                SizedBox(height: 8,),
                AutoSizeText.rich(TextSpan(children: [
                  TextSpan(text: "Date Submitted ",style: TextStyles.title2.copyWith(color: Theme.of(context).hintColor)),
                  TextSpan(text: DateFormat.yMMMMd().format(report.date!),style: TextStyles.title2)
                ])),
                SizedBox(height: 10,),
                report.claimType!?controller.report.businessAssigned==0?SizedBox():AutoSizeText(report.businessAssigned==1?"Business has been assigned to you":"Sorry We cannot verify if this business belong to you",style: TextStyles.title1.copyWith(color: Colors.red),):SizedBox()
              ],),),
          Expanded(child: controller.report.closed!?Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width*0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
              AutoSizeText("This Ticket has been closed by support. Still facing issue?",textAlign: TextAlign.center,),
                SizedBox(height: Get.height*0.02,),
                TextButton(onPressed: (){
                  controller.updateReport();
                }, child: AutoSizeText("Open Again"))
            ],),
          ):ListView.builder(
              reverse: true,
              itemCount: controller.messages.length,
              itemBuilder: (context,index){
                return ReportMessage(message: controller.messages[index], index: index);
              }),),
          controller.report.closed!?SizedBox():Padding(
            padding: EdgeInsets.all(Get.width*0.04),
            child: StyledTextFormField(
              controller: controller.textController,
              onChanged: (val){
                controller.update();
              },
              hintText: "Type a message...",
              suffixIcon: controller.textController.text.length==0?null:IconButton(onPressed: (){
                controller.sendMessage();
                FocusScope.of(context).requestFocus(FocusNode());
              }, icon: Icon(Icons.send,color: Theme.of(context).primaryColor,)),
            ),
          )
        ],),
      );

    });
  }
}

class ReportMessage extends GetView<TicketDetailController> {
  const ReportMessage({Key? key,required this.message,required this.index}) : super(key: key);
  final ReportMessageModel message;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      index==controller.messages.length-1?Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [AutoSizeText(controller.formatDate(message.time!))],):
      controller.messages[index+1].time!.difference(message.time!).inMinutes.abs()>5?Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [AutoSizeText(controller.formatDate(message.time!))],):SizedBox(),
      message.fromAdmin!?Row(children: [
        Expanded(
            flex:3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: Get.height*0.005,horizontal: Get.width*0.01,),
                    padding: EdgeInsets.symmetric(
                        horizontal: Get.width*0.01,
                        vertical: Get.width*0.01
                    ),
                    child: AutoSizeText(message.message??"",style: TextStyles.h3,))
              ],)),
        Expanded(
            flex: 1,
            child: SizedBox()),
      ],):
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              flex: 1,
              child: SizedBox()),
          Expanded(
              flex:3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                      margin: EdgeInsets.symmetric(vertical: Get.height*0.005,horizontal: Get.width*0.01,),
                      padding: EdgeInsets.symmetric(
                          horizontal: Get.width*0.01,
                          vertical: Get.width*0.01
                      ),
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(10)),
                      child: AutoSizeText(message.message??"",style: TextStyles.h3.copyWith(color: Colors.white),))
                ],))
        ],)
    ],);
  }
}
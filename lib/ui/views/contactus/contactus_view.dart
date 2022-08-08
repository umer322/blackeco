import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/models/report_model.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/views/contactus/contactus_controller.dart';
import 'package:blackeco/ui/views/contactus/report_view.dart';
import 'package:blackeco/ui/views/contactus/ticketdetail/ticketdetail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ContactUsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Contact Us",
      ),),
      body: GetBuilder<ContactUsController>(
          init: ContactUsController(),
          builder: (controller){
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: Get.height*0.04,),
              GestureDetector(
                onTap: (){
                  controller.setUserReport();
                  Get.to(()=>ReportView(0));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical:Get.width*0.05,horizontal: Get.width*0.03),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).primaryColorLight
                          ),
                          child: Icon(Icons.info_outline,color: Theme.of(context).primaryColorDark,)),
                      SizedBox(width: Get.width*0.03,),
                      AutoSizeText("Report a problem",style: TextStyles.h2.copyWith(color: Theme.of(context).primaryColorLight),)
                    ],),
                ),
              ),
              SizedBox(height: Get.height*0.03,),
              AutoSizeText("Ticket Center",style: TextStyles.h1.copyWith(color: Theme.of(context).primaryColor),),
              SizedBox(height: Get.height*0.03,),
              DropdownButtonFormField(
                  value: controller.reportType,
                  onChanged: controller.changeReportType,
                  items: ReportModel.allReportIssues.map((e) => DropdownMenuItem(child: AutoSizeText(e),value: e,)).toList()),
              SizedBox(height: Get.height*0.03,),
              controller.reports.length>0?
                  Expanded(
                    child: ListView.builder(
                        itemCount: controller.reports.length,
                        itemBuilder: (context,index){
                      return GestureDetector(
                        onTap: (){
                          Get.to(()=>TicketDetailView(report: controller.reports[index]));
                        },
                        child: Container(
                          margin: EdgeInsets.only(bottom: Get.height*0.01),
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
                              AutoSizeText(controller.reports[index].issueType!,style: TextStyles.h1,),
                                controller.reports[index].closed!?AutoSizeText("Closed"):AutoSizeText(controller.reports[index].reportStatus==0?"Pending":"Responded")
                              ],),
                          SizedBox(height: 8,),
                          AutoSizeText.rich(TextSpan(children: [
                            TextSpan(text: "Ticket id ",style: TextStyles.title2.copyWith(color: Theme.of(context).hintColor)),
                            TextSpan(text: "#"+controller.reports[index].id!,style: TextStyles.title2)
                          ])),
                            SizedBox(height: 8,),
                            AutoSizeText.rich(TextSpan(children: [
                              TextSpan(text: "Date Submitted ",style: TextStyles.title2.copyWith(color: Theme.of(context).hintColor)),
                              TextSpan(text: DateFormat.yMMMMd().format(controller.reports[index].date!),style: TextStyles.title2)
                            ]))
                        ],),),
                      );
                    }),
                  )
                  :AutoSizeText("No tickets have been submitted.",textAlign: TextAlign.center,style: TextStyles.h2.copyWith(color: Theme.of(context).accentColor),)
            ],
          ),
        );
      }),
    );
  }
}

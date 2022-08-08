import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/models/reportmessage_model.dart';
import 'package:blackeco/ui/admin/views/dashboard/admindashboard_controller.dart';
import 'package:blackeco/ui/admin/views/singlecomplain/singlecomplain_controller.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/styled_button.dart';
import 'package:blackeco/ui/styled_widgets/styled_textformfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SingleComplainView extends StatelessWidget {
  const SingleComplainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AdminDashboardController>(builder: (controller){
      return Scaffold(
        appBar: AppBar(
          title: AutoSizeText("Dashboard"),
        ),
        body: Row(children: [
          NavigationRail(
            leading: SizedBox(
                height: 60,
                child: Image.asset("assets/logo.png")),
            extended: true,
            elevation: 10,
            selectedLabelTextStyle: TextStyles.h3,
            destinations: [
              NavigationRailDestination(icon: Icon(Icons.speed_outlined), label: AutoSizeText("Reports")),
              NavigationRailDestination(icon: Icon(Icons.search), label: AutoSizeText("Claim Business")),
            ], selectedIndex: controller.selectedIndex,
            onDestinationSelected: (index){
              Get.back();
              controller.changeIndex(index);
            },
          ),
          Expanded(child: GetBuilder<SingleComplainController>(builder: (controller1){
            return Column(
              children: [
                SizedBox(height: Get.height*0.01,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    controller1.report.claimType!?Container(
                        width: Get.width*0.15,
                        child: StyledButton(title: "Assign Business",onPressed: (){
                          controller1.assignBusiness();
                        },)):SizedBox(),
                    SizedBox(width: Get.width*0.05,),
                    Container(
                        width: Get.width*0.15,
                        child: StyledButton(title: controller1.report.closed!?"Open":"Close",onPressed: (){
                            controller1.changeReportStatus();
                        },)),
                    SizedBox(width: Get.width*0.05,),
                  ],),
                SizedBox(height: Get.height*0.01,),
                Row(children: [
                  Expanded(child:
                  Card(
                    margin: EdgeInsets.all(Get.width*0.01),
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(Get.width*0.01),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText("Person has contacted us from help center",style: TextStyles.h2,),
                          SizedBox(height: Get.height*0.01,),
                          Row(children: [
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText("Request Type",style: TextStyles.title1,),
                                SizedBox(height: Get.height*0.01,),
                                AutoSizeText(controller1.report.issueType??'')
                              ],
                            )),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText("Additional Message",style: TextStyles.title1,),
                                SizedBox(height: Get.height*0.01,),
                                AutoSizeText(controller1.report.additionalNote??"")
                              ],
                            ))
                          ],),
                          SizedBox(height: Get.height*0.01,),
                          Row(children: [
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText("Generated on",style: TextStyles.title1,),
                                SizedBox(height: Get.height*0.01,),
                                AutoSizeText(DateFormat.yMMMEd().format(controller1.report.date!))
                              ],
                            )),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AutoSizeText("Ticket Id",style: TextStyles.title1,),
                                SizedBox(height: Get.height*0.01,),
                                AutoSizeText(controller1.report.id??"")
                              ],
                            ))
                          ],)
                      ],),
                    ),
                  ),flex: 7,),
                  Expanded(child: Card(
                    elevation: 10,
                    child: Padding(
                    padding: EdgeInsets.all(Get.width*0.01),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText("User Details",style: TextStyles.h2,),
                        SizedBox(height: Get.height*0.01,),
                        Row(children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: controller1.report.userPicture!=null?CachedNetworkImage(
                              imageUrl: controller1.report.userPicture!,
                            ):Image.asset("assets/person.png"),
                          ),
                          SizedBox(width: Get.width*0.01,),
                          Flexible(child: AutoSizeText(controller1.report.userName??""))
                        ],),
                        SizedBox(height: Get.height*0.01,),
                        AutoSizeText(controller1.report.contactEmail??"")
                      ],
                    ),
                  ),),flex: 3,)
                ],),
                Expanded(child: controller1.report.closed!?SizedBox():Row(children: [
                  Expanded(child: Card(
                    margin: EdgeInsets.all(Get.width*0.01),
                    elevation: 8,
                    child: ListView.builder(
                      reverse:true,
                        itemCount: controller1.messages.length,
                        itemBuilder: (context,index){
                      return ReportMessage(message: controller1.messages[index], index: index);
                    }),
                  ),flex: 7,),
                  Expanded(child: Column(
                    children: [
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical:Get.width*0.01),
                        child: StyledTextFormField(
                          controller: controller1.textController,
                          onChanged: (val){
                            controller.update();
                          },
                          hintText: "Type a message...",
                          suffixIcon: controller1.textController.text.length==0?null:IconButton(onPressed: (){
                            controller1.sendMessage();
                            FocusScope.of(context).requestFocus(FocusNode());
                          }, icon: Icon(Icons.send,color: Theme.of(context).primaryColor,)),
                        ),
                      )
                    ],
                  ),flex: 3,)
                ],))
              ],
            );
          }))
        ],),
      );
    });
  }
}


class ReportMessage extends GetView<SingleComplainController> {
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
      !message.fromAdmin!?Row(children: [
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

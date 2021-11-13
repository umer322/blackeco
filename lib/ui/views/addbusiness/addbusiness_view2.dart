import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/models/day_time_picker.dart';
import 'package:blackeco/ui/styled_widgets/styled_button.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_controller.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_view3.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddBusinessViewTwo extends StatelessWidget {

  final DateTime now=DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Add a Business"),
      ),
      body: GetBuilder<AddBusinessController>(builder: (controller){
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: Get.height*0.03,),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
                  child: AutoSizeText("Opening Hours",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 20,fontWeight: FontWeight.w600),)),
              for (AppTimeData data in controller.businessData!.timeData!)...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.01),
                    decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5)))
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 25,
                              height: 25,
                              child: Checkbox(
                                  activeColor: Theme.of(context).primaryColor,

                                  value: data.status, onChanged: (val){
                                  data.status=val;
                                  controller.update();

                              }),
                            ),
                            SizedBox(width: 5,),
                            AutoSizeText(data.day,style: TextStyle(color: Color(0xff35A2AB),fontSize: 16),),
                          ],
                        ),
                        data.status!?Row(children: [

                          GestureDetector(
                            onTap: ()async{
                              TimeOfDay? t = await showTimePicker(
                                  context: context,
                                  initialTime: data.startTime
                              );
                              if (t!=null){
                                  data.startTime=t;
                                  controller.update();
                              }
                            },
                            child: Row(children: [
                              AutoSizeText(DateFormat.jm().format(DateTime(now.year, now.month, now.day, data.startTime.hour, data.startTime.minute)),style: TextStyle(color: Colors.grey),),
                              Icon(Icons.keyboard_arrow_down,color: Theme.of(context).primaryColor,)
                            ],),
                          ),
                          Text(" - "),
                          GestureDetector(
                            onTap: ()async{
                              TimeOfDay? t = await showTimePicker(
                                  context: context,
                                  initialTime: data.endTime
                              );
                              if(t!=null){
                                  data.endTime=t;
                                  controller.update();
                              }

                            },
                            child: Row(children: [
                              AutoSizeText(DateFormat.jm().format(DateTime(now.year, now.month, now.day, data.endTime.hour, data.endTime.minute)),style: TextStyle(color: Colors.grey),),
                              Icon(Icons.keyboard_arrow_down,color:  Theme.of(context).primaryColor,)
                            ],),
                          ),
                        ],):AutoSizeText("Closed",style: TextStyle(color: Colors.grey),)
                      ],
                    ),
                  ),
                ),
              ],
              SizedBox(height: Get.height*0.03,),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
                  child: AutoSizeText("Services/Menu",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 20,fontWeight: FontWeight.w600),)),
              SizedBox(height: Get.height*0.02,),
              Container(
                height: MediaQuery.of(context).size.height*0.13,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.businessData!.menuImages!.length+1,
                    itemBuilder: (BuildContext context,int index){
                      if(index == 0){
                        return GestureDetector(
                          onTap: (){
                            controller.loadServiceImages(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            height: MediaQuery.of(context).size.height*0.13,
                            width: MediaQuery.of(context).size.width*0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,color: Colors.grey,),
                                AutoSizeText("Add photos",style: TextStyle(color: Colors.grey),maxLines: 1,)
                              ],
                            ),
                          ),
                        );
                      }
                      return Stack(children: [
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black,width: 1),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: controller.businessData!.menuImages![index-1].contains("firebasestorage")?CachedNetworkImage(imageUrl: controller.businessData!.menuImages![index-1],fit: BoxFit.cover,):Image.file(File(controller.businessData!.menuImages![index-1]),fit: BoxFit.cover,),
                          height: MediaQuery.of(context).size.height*0.13,
                          width: MediaQuery.of(context).size.width*0.25,
                        ),
                        Positioned(
                            right:0,
                            child: GestureDetector(
                              onTap:(){
                                controller.businessData!.menuImages!.remove(controller.businessData!.menuImages![index-1]);
                                controller.update();
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                                child: Icon(Icons.close,color: Colors.black,),
                              ),
                            ))
                      ],);
                    }),
              ),
              SizedBox(height: Get.height*0.03,),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
                  child: AutoSizeText("Photos",style: TextStyle(color: Theme.of(context).primaryColor,fontSize: 20,fontWeight: FontWeight.w600),)),
              SizedBox(height: Get.height*0.02,),
              Container(
                height: MediaQuery.of(context).size.height*0.13,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.businessData!.images!.length+1,
                    itemBuilder: (BuildContext context,int index){
                      if(index == 0){
                        return GestureDetector(
                          onTap: (){
                            controller.loadImages(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)
                            ),
                            height: MediaQuery.of(context).size.height*0.13,
                            width: MediaQuery.of(context).size.width*0.25,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.camera_alt,color: Colors.grey,),
                                AutoSizeText("Add photos",style: TextStyle(color: Colors.grey),maxLines: 1,)
                              ],
                            ),
                          ),
                        );
                      }
                      return Stack(children: [
                        Container(
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.black,width: 1),
                              borderRadius: BorderRadius.circular(5)
                          ),
                          child:controller.businessData!.images![index-1].contains("firebasestorage")?CachedNetworkImage(imageUrl: controller.businessData!.images![index-1],fit: BoxFit.cover,): Image.file(File(controller.businessData!.images![index-1]),fit: BoxFit.cover,),
                          height: MediaQuery.of(context).size.height*0.13,
                          width: MediaQuery.of(context).size.width*0.25,
                        ),
                        Positioned(
                            right:0,
                            child: GestureDetector(
                              onTap:(){
                                controller.businessData!.images!.remove(controller.businessData!.images![index-1]);
                                controller.update();
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                                child: Icon(Icons.close,color: Colors.black,),
                              ),
                            ))
                      ],);
                    }),
              ),
              SizedBox(height: Get.height*0.03,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(child: Container(
                      width: Get.width*0.25,
                      child: StyledButton(
                          onPressed: (){
                              Get.to(AddBusinessViewThree());
                          },
                          title: "Next"),
                    ))
                  ],
                ),
              ),
              SizedBox(height: Get.height*0.03,),
            ],
          ),
        );
      },),
    );
  }
}

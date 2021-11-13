import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/views/businessdetail/businessthumbnail_view.dart';
import 'package:blackeco/ui/views/mybusiness/mybusinesses_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyBusinessesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyBusinessesController>(
        init: MyBusinessesController(),
        builder: (controller){
      return Scaffold(
        appBar: AppBar(
          title: AutoSizeText("My Businesses"),
          centerTitle: true,
        ),
        body:ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: Get.width*0.05,vertical: Get.width*0.03),
            itemCount: controller.businesses.length,
            itemBuilder: (context,index){
          return BusinessThumbnailView(controller.businesses[index]);
        }),
      );
    });
  }
}

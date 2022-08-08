import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/models/day_time_picker.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/views/galleryview/gallery_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MoreInfoView extends StatelessWidget {
  const MoreInfoView({Key? key,required this.business}) : super(key: key);
  final BusinessData business;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(business.name!),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Get.height*0.02,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:Get.width*0.05),
              child: AutoSizeText("Menu",style: TextStyles.h1.copyWith(color: Theme.of(context).primaryColor),),
            ),
            SizedBox(height: Get.height*0.02,),
            Container(
              height: Get.height*0.25,
              child: ListView.builder(
                  itemCount: business.menuImages!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: (){
                        Get.to(()=>GalleryView(business.menuImages!));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: Get.width*0.05),
                        height: Get.height*0.25,
                        width: Get.width*0.45,
                        child: CachedNetworkImage(imageUrl: business.menuImages![index],fit: BoxFit.cover,),
                      ),
                    );
                  }),
            ),
            SizedBox(height: Get.height*0.02,),

            Padding(
              padding: EdgeInsets.symmetric(horizontal:Get.width*0.05),
              child: AutoSizeText("Photos",style: TextStyles.h1.copyWith(color: Theme.of(context).primaryColor),),
            ),
            SizedBox(height: Get.height*0.02,),
            Container(
              height: Get.height*0.25,
              child: ListView.builder(
                  itemCount: business.images!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      onTap: (){
                        Get.to(()=>GalleryView(business.images!));
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: Get.width*0.05),
                        height: Get.height*0.25,
                        width: Get.width*0.45,
                        child: CachedNetworkImage(imageUrl: business.images![index],fit: BoxFit.cover,),
                      ),
                    );
                  }),
            ),
            SizedBox(height: Get.height*0.02,),
          ],
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/views/businessdetail/businessthumbnail_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleCategoryView extends StatelessWidget {
  final String category;
  final List<BusinessData> data;
  SingleCategoryView(this.category,this.data);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(category),
      ),
      body: data.length==0?Center(child: AutoSizeText("No Business Exist in this Category",style: TextStyles.title1,),):ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: Get.width*0.05,vertical: 10),
          itemCount: data.length,
          itemBuilder: (context,index){
        return BusinessThumbnailView(data[index]);
      }),
    );
  }
}

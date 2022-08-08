import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/views/businessdetail/businessthumbnail_view.dart';
import 'package:blackeco/ui/views/categories/singlecategory_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleCategoryView extends StatelessWidget {
  final String category;
  final List<BusinessData> data;
  SingleCategoryView(this.category,this.data);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SingleCategoryController>(
        init: SingleCategoryController(businesses: data),
        builder: (controller)=>Scaffold(
    appBar: AppBar(
    title: AutoSizeText(category,style: TextStyles.h2.copyWith(color: Theme.of(context).primaryColorDark),),
      actions: [
        PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(children: [
                  Expanded( child: Text("New Listings")),
                  Radio(value: 0, groupValue: controller.searchType, onChanged: (val){
                    controller.changeSearchType(val,true);
                  })
                ],),
                value: 0,
              ),
              PopupMenuItem(
                child: Row(children: [
                  Expanded( child: Text("Top Rated")),
                  Radio(value: 1, groupValue: controller.searchType, onChanged: (val){
                    controller.changeSearchType(val,true);
                  })
                ],),
                value: 1,
              )
            ],
          child: Icon(Icons.more_horiz),
          onSelected: (val){
            controller.changeSearchType(val,false);
          },
        ),
      ],
    ),
    body: controller.businesses.length==0?Center(child: AutoSizeText("No business exists in this category",style: TextStyles.title1,),):ListView.separated(
    separatorBuilder: (_,index)=>Divider(thickness: 2,),
    padding: EdgeInsets.symmetric(horizontal: Get.width*0.05,vertical: 10),
    itemCount: controller.businesses.length,
    itemBuilder: (context,index){
    return BusinessThumbnailView(controller.businesses[index],fromCategoryView: true,);
    }),
    ));
  }
}

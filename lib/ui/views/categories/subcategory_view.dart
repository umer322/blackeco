import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/ui/views/categories/singlecategory_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SubCategoryView extends StatelessWidget {
  final List<String>? subCategories;
  final String subCategory;
  SubCategoryView(this.subCategories,this.subCategory);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(subCategory),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
        child: Column(
          children: [
            for(String category in subCategories!)
              ListTile(
                onTap: (){
                  List<BusinessData> data=List<BusinessData>.from(Get.find<BusinessesController>().businesses).where((element) => element.category==subCategory).toList();
                  Get.to(()=>SingleCategoryView(subCategory,data));
                },
                  title: AutoSizeText(category),contentPadding: EdgeInsets.symmetric(horizontal: 0),dense: true,
              )
          ],
        ),
      ),
    );
  }
}

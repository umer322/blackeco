import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/models/category_model.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/views/categories/subcategory_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CategoriesView extends StatelessWidget {
  final List<String> popularCategories=["Beauty","Food","Health & Medical","Apparel & Accessories","Automotive"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("All Categories"),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: Get.height*0.03,
              ),
              AutoSizeText("Popular Categories",style: TextStyles.h2.copyWith(color: Theme.of(context).primaryColor),),
              for(String category in popularCategories)
                ListTile(
                  onTap: (){
                    Get.to(()=>SubCategoryView(CategoryModel.returnSubCategory(category),category));
                  },
                  title: AutoSizeText(category),contentPadding: EdgeInsets.symmetric(horizontal: 0),dense: true,),
              AutoSizeText("All Categories",style: TextStyles.h2.copyWith(color: Theme.of(context).primaryColor),),
              for(String category in CategoryModel.categories)
                ListTile(
                  onTap: (){
                    Get.to(()=>SubCategoryView(CategoryModel.returnSubCategory(category),category));
                  },
                  title: AutoSizeText(category),contentPadding: EdgeInsets.symmetric(horizontal: 0),dense: true,trailing: Icon(Icons.arrow_forward_ios,size: 18,),)
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:blackeco/ui/views/businessdetail/businessthumbnail_view.dart';
import 'package:blackeco/ui/views/search/search_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class SearchView extends StatelessWidget {
  const SearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SearchController>(
        init: SearchController(),
        builder: (controller){
      return Scaffold(
        appBar: AppBar(
          title: TextField(
            onChanged: controller.onSearch,
            decoration: InputDecoration(
              hintText: "Search"
            ),
          ),
        ),
        body: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: Get.width*0.05,vertical: Get.width*0.02),
            itemCount: controller.searchedList.length,
            itemBuilder: (context,index){
          return BusinessThumbnailView(controller.searchedList[index]);
        }),
      );
    });
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/localstorage_service.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/circled_icon.dart';
import 'package:blackeco/ui/styled_widgets/drawer/drawer_view.dart';
import 'package:blackeco/ui/styled_widgets/loginerror_view.dart';
import 'package:blackeco/ui/views/businessdetail/businessdetail_view.dart';
import 'package:blackeco/ui/views/businessdetail/businessthumbnail_view.dart';
import 'package:blackeco/ui/views/favorites/favorites_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';


class FavoritesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme=Theme.of(context);
    return Obx((){
      return Get.find<UserController>().currentUser.value.id==null?LoginErrorView():GetBuilder<FavoritesController>(
          init: FavoritesController(),
          builder: (controller){
            return Scaffold(
              appBar: AppBar(
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                title: AutoSizeText("Favorites"),
//                actions: [IconButton(onPressed: (){}, icon: Icon(Icons.settings))],
                centerTitle: true,
              ),
              drawer: DrawerView(),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: Get.width*0.05),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: theme.accentColor))
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: Get.width*0.05),
                        child: Row(children: [
                          GestureDetector(
                            onTap: (){
                              controller.changeGroupView(false);
                            },
                            child: AnimatedContainer(duration: Duration(seconds: 1),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: controller.showGroupView?theme.accentColor:theme.primaryColor,width: controller.showGroupView?0:2))
                              ),
                              padding: EdgeInsets.only(bottom: Get.height*0.02),
                              child: AutoSizeText("Favorites",style: TextStyles.title1.copyWith(color: controller.showGroupView?theme.accentColor:theme.primaryColor),),),
                          ),
                          SizedBox(width: Get.width*0.05,),
                          GestureDetector(
                            onTap: (){
                              controller.changeGroupView(true);
                            },
                            child: AnimatedContainer(duration: Duration(seconds: 1),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: controller.showGroupView?theme.primaryColor:theme.accentColor,width: controller.showGroupView?2:0))
                              ),
                              padding: EdgeInsets.only(bottom: Get.height*0.02),
                              child: AutoSizeText("Groups",style: TextStyles.title1.copyWith(color: controller.showGroupView?theme.primaryColor:theme.accentColor),),),
                          )
                        ],),
                      ),
                    ),
                  ),
                  Expanded(child: controller.showGroupView?
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          for(String category in controller.tags)
                            _BusinessListPortion(category)
                        ],),
                      )
                      :ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
                      itemCount: controller.favorites.length,
                      itemBuilder: (context,index){
                    return BusinessThumbnailView(controller.favorites[index]);
                  }))
                ],
              ),
            );
          });
    });
  }
}

class _BusinessListPortion extends GetView<FavoritesController> {
  final String category;
  _BusinessListPortion(this.category);
  @override
  Widget build(BuildContext context) {
    List<BusinessData> data=controller.favorites.where((element) => element.category==category).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width*0.05,vertical: Get.width*0.02),
          child: AutoSizeText(category,style: TextStyles.h1,)
        ),
        Container(
          height: Get.width*0.7,
          child: ListView.builder(
              itemCount: data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_,index){
                return _BusinessDetailPortion(data[index]);
              }),
        )
      ],
    );
  }
}
class _BusinessDetailPortion extends StatelessWidget {
  final BusinessData business;

  _BusinessDetailPortion(this.business);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=>BusinessDetailView(business));
      },
      child: Container(
        height: Get.width*0.75,
        width: Get.width*0.75,
        margin: EdgeInsets.only(left: Get.width*0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(5),topRight: Radius.circular(5)),
                      child: CachedNetworkImage(imageUrl: business.coverImage!,fit: BoxFit.cover,)),
                  Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                          onTap: (){
                            if(Get.find<UserController>().currentUser.value.id==null){
                              Show.showErrorSnackBar("Error", "Please login to add this business to your favorites");
                              return;
                            }
                            if (Get.find<UserController>()
                                .currentUser
                                .value
                                .favorites!
                                .contains(business.id)) {
                              Get.find<BusinessesController>()
                                  .removeFromFavorite(business.id!);
                            } else {
                              Get.find<BusinessesController>()
                                  .addToFavorite(business.id!);
                            }
                          },
                          child: Get.find<UserController>().currentUser.value.id==business.ownerId?SizedBox():CircledIcon( Get.find<UserController>()
        .currentUser
        .value
        .favorites!
        .contains(business.id!)
    ? Icons.favorite
        : Icons.favorite_border,color: Colors.black54,iconColor: Theme.of(context).primaryColorLight,)))
                ])),
            SizedBox(height: 8,),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Row(children: [Flexible(child: AutoSizeText(business.name!,style: TextStyles.h2,)),
                      SizedBox(width: 5,),
                      RatingBarIndicator(
                        rating: business.rating!,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Theme.of(context).primaryColor,
                        ),
                        unratedColor: Theme.of(context).primaryColorLight,
                        itemCount: 5,
                        itemSize: 16.0,
                        direction: Axis.horizontal,
                      ),],),
                  ),
                  GestureDetector(
                      onTap: (){
                        try{
                          Get.find<LocalStorageService>().launchURL('https://www.google.com/maps/search/?api=1&query=${business.location?.latitude},${business.location?.longitude}');
                        }
                        catch(e){
                          Show.showErrorSnackBar("Error", "$e");
                        }
                      },
                      child: CircledIcon(Icons.location_on_outlined,iconColor: Theme.of(context).primaryColorLight,)),
                ],),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AutoSizeText(business.tags!.map((e) => e.capitalizeFirst).join(', '),style: TextStyles.body1.copyWith(color: Theme.of(context).accentColor),),
            ),
            AutoSizeText(business.status!?"Open Now":"Closed",style: TextStyles.caption.copyWith(color: business.status!?Theme.of(context).buttonColor:Theme.of(context).errorColor),)
          ],
        ),
      ),
    );
  }
}
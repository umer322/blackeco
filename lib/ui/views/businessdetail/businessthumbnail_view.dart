import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/localstorage_service.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/circled_icon.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_controller.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_view1.dart';
import 'package:blackeco/ui/views/businessdetail/businessdetail_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class BusinessThumbnailView extends StatelessWidget {
  final BusinessData business;

  BusinessThumbnailView(this.business);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Get.to(()=>BusinessDetailView(business));
      },
      child: Container(
        height: Get.width*0.75,
        width: Get.width,
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
                      child: Get.find<UserController>().currentUser.value.id==business.ownerId?GestureDetector(
                        onTap: (){
                          Get.to(()=>AddBusinessViewOne(),binding: BindingsBuilder((){
                            Get.put(AddBusinessController(businessData: business));
                          }));
                        },
                        child: CircledIcon(Icons.edit,color: Colors.black54,iconColor: Colors.white,),
                      ):GestureDetector(
                          onTap: (){
                            if(Get.find<UserController>().currentUser.value.id==null){
                              Show.showErrorSnackBar("Error", "Please login to add this business to your favorites");
                              return;
                            }
                            if(business.favorites!.contains(Get.find<UserController>().currentUser.value.id)){
                              Get.find<BusinessesController>().removeFromFavorite(business.id!);
                            }
                            else{
                              Get.find<BusinessesController>().addToFavorite(business.id!);
                            }
                          },
                          child: CircledIcon(business.favorites!.contains(Get.find<UserController>().currentUser.value.id)?Icons.favorite:Icons.favorite_border,color: Colors.black54,iconColor: Colors.white,)))
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
              child: Row(children: [
                Flexible(child: AutoSizeText(business.tags!.join(","),style: TextStyles.body1.copyWith(color: Theme.of(context).accentColor),)),
                SizedBox(width: Get.width*0.03,),
                AutoSizeText(business.status!?"Open Now":"Closed",style: TextStyles.title2.copyWith(color: business.status!?Theme.of(context).buttonColor:Theme.of(context).errorColor),)
              ],),
            ),

          ],
        ),
      ),
    );
  }
}

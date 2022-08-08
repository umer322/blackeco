import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/localstorage_service.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/models/category_model.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/circled_icon.dart';
import 'package:blackeco/ui/styled_widgets/drawer/drawer_view.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_controller.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_view1.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_wait.dart';
import 'package:blackeco/ui/views/businessdetail/businessdetail_view.dart';
import 'package:blackeco/ui/views/categories/categories_view.dart';
import 'package:blackeco/ui/views/categories/singlecategory_view.dart';
import 'package:blackeco/ui/views/dashboard/dashboard_controller.dart';
import 'package:blackeco/ui/views/search/search_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';


class DashboardView extends StatelessWidget {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerView(),
      body: GetBuilder<DashboardController>(
          init: DashboardController(),
          builder: (controller){
        return CustomScrollView(slivers: [
          SliverAppBar(
            leading: IconButton(onPressed: (){
              _scaffoldKey.currentState!.openDrawer();
            }, icon: Icon(Icons.menu,color: Theme.of(context).primaryColor,),),
            elevation: 0,
            centerTitle: true,
            title: GestureDetector(
              onTap: controller.setSearchLocation,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Get.width*0.05,vertical: Get.width*0.02),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(25)
                ),
                child: controller.location==null?AutoSizeText("Select Location"):Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Icon(Icons.location_on,color: Colors.white,size: 18,),
                    SizedBox(width: 10,)
                    ,AutoSizeText(controller.location!,style: TextStyles.title1.copyWith(color: Colors.white),)],),
              ),
            ),
            actions: [
              IconButton(onPressed: (){
                Get.to(()=>SearchView());
              }, icon: Icon(Icons.search,color: Theme.of(context).primaryColor,))
            ],
            pinned: true,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AutoSizeText("Categories",style: TextStyles.h1,),
                  TextButton(onPressed: (){
                    Get.to(()=>CategoriesView());
                  }, child: AutoSizeText("View All"))
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: Get.height*0.12,
              child: ListView.builder(
                itemBuilder: (_,index){
                  return GestureDetector(
                    onTap: (){
                      String name=CategoryModel.allCategoriesList[index].name!;
                      print(name);
                      List<BusinessData> data=List<BusinessData>.from(Get.find<BusinessesController>().businesses).where((element) => element.category==name).toList();
                      Get.to(()=>SingleCategoryView(name,data));
                    },
                    child: Column(
                      children: [
                        Expanded(child: Container(
                          margin: EdgeInsets.symmetric(horizontal: Get.width*0.015),
                          padding: EdgeInsets.all(Get.width*0.035),
                          decoration: BoxDecoration(shape: BoxShape.circle,color: Theme.of(context).accentColor),
                          child: Center(child: CategoryModel.allCategoriesList[index].image,),
                        ),),
                        SizedBox(height: Get.height*0.01,),
                        AutoSizeText(CategoryModel.allCategoriesList[index].name!.split(" ")[0],style: TextStyles.title1,)
                      ],
                    ),
                  );
                },itemCount: CategoryModel.allCategoriesList.length,
                scrollDirection: Axis.horizontal,),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all( Get.width*0.05),
              child: GestureDetector(
                onTap: (){
                  if(Get.find<UserController>().currentUser.value.id==null){
                    Show.showErrorSnackBar("Error", "Please login to continue");
                  }
                  else{
                    Get.toNamed("/addbusiness");
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical:Get.width*0.05,horizontal: Get.width*0.03),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColorDark,
                      borderRadius: BorderRadius.circular(5)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    Flexible(child: AutoSizeText("Want to list and grow your\nown business on BlackEco\u1d40\u1d39?",style: TextStyles.h3.copyWith(color: Theme.of(context).primaryColorLight),)),
                    Icon(Icons.arrow_forward_ios,color: Theme.of(context).primaryColorLight,)
                  ],),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _BusinessListPortion("Top Rated",controller.topRatedBusinesses,"No Business data available to show",(){
              Get.to(()=>SingleCategoryView("Top Rated", controller.topRatedBusinesses));
            }),
          ),
          // SliverToBoxAdapter(
          //   child: _BusinessListPortion("Recent Searches",controller.recentBusinesses,"No recent search available",(){
          //       Get.to(()=>SingleCategoryView("Recent Searches",controller.recentBusinesses ));
          //     }),
          // ),
          SliverToBoxAdapter(
            child: _BusinessListPortion("What's New",controller.newBusinesses,"No business data available to show",(){
              Get.to(()=>SingleCategoryView("What's New", controller.newBusinesses));
            }),
          ),
          SliverToBoxAdapter(
            child: SizedBox(height: Get.height*0.02,),
          )
        ],);
      }),
    );
  }
}


class _BusinessListPortion extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onPressed;
  final List<BusinessData> data;
  _BusinessListPortion(this.title,this.data,this.message,this.onPressed);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoSizeText(title,style: TextStyles.h1,),
              TextButton(onPressed: onPressed, child: AutoSizeText("View All"))
            ],
          ),
        ),
        Container(
          height: Get.width*0.75,
          child: data.length==0?Center(child: AutoSizeText(message,style: TextStyles.h2,),):ListView.builder(
              padding: EdgeInsets.only(bottom: 20),
              itemCount: data.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_,index){
            return _BusinessDetailPortion(data[index]);
          }),
        ),
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
      child: Card(
        margin: EdgeInsets.only(left: Get.width*0.05),
        elevation: 8,
        child: Container(
          width: Get.width*0.75,
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
                    Obx(()=>Positioned(
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
                              if(Get.find<UserController>().currentUser.value.favorites!.contains(business.id)){
                                Get.find<BusinessesController>().removeFromFavorite(business.id!);
                              }
                              else{
                                Get.find<BusinessesController>().addToFavorite(business.id!);
                              }
                            },
                            child: CircledIcon(Get.find<UserController>().currentUser.value.favorites!.contains(business.id!)?Icons.favorite:Icons.favorite_border,color: Colors.black54,iconColor: Colors.white,))))
                          ])),
                           Padding(
                          padding: EdgeInsets.symmetric(horizontal: Get.width*0.02,vertical: Get.height*0.005),
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

                ],),
              ),
              business.tags!.length==0?SizedBox():Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width*0.02),
                child: AutoSizeText(business.tags!.map((e) => e.capitalizeFirst).join(', '),overflow: TextOverflow.ellipsis,maxLines: 1,style: TextStyles.body1.copyWith(color: Theme.of(context).accentColor),),
              ),
              SizedBox(height: business.tags!.length==0?0:Get.height*0.005,),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width*0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                AutoSizeText(business.status!?"Open Now":"Closed",style: TextStyles.caption.copyWith(color: business.status!?Theme.of(context).buttonColor:Theme.of(context).errorColor)),

                    GestureDetector(
                        onTap: (){
                          try{
                            Get.find<LocalStorageService>().launchURL('https://www.google.com/maps/search/?api=1&query=${business.location?.latitude},${business.location?.longitude}');
                          }
                          catch(e){
                            Show.showErrorSnackBar("Error", "$e");
                          }
                        },
                        child:Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              shape: BoxShape.circle
                          ),
                          child: Center(child: Icon(Icons.location_on_outlined,color: Theme.of(context).primaryColorLight,),),
                        )),
                  ],),
              ),
              SizedBox(height: Get.height*0.01,)
            ],
          ),
        ),
      ),
    );
  }
}



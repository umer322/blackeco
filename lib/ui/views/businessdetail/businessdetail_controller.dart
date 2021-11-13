
import 'dart:async';

import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/firebasedatabase_service.dart';
import 'package:blackeco/core/services/localstorage_service.dart';
import 'package:blackeco/core/services/multimedia_service.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/models/review.dart';
import 'package:blackeco/models/timeseries_model.dart';
import 'package:blackeco/models/user_model.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class BusinessDetailController extends GetxController{
  BusinessData businessData;
  UserModel user=Get.find<UserController>().currentUser.value;
  BusinessDetailController(this.businessData);
  late ReviewModel review;
  int showView=0;
  bool showLinkView=false;
  int totalClicks=0;
  int totalSocialClicks=0;
  bool isOwner=false;
  late StreamSubscription businessDataSubscription;
  bool loadingReview=false;
  List<Map<String,dynamic>> graphData=[];
  List<ReviewModel> reviews=[];

  changeView(int value){
    showView=value;
    update();
  }

  setReviews(){
    review=ReviewModel(rating: 0);
    review.photos=[];
    businessData.reviews!.forEach((element) {
      if(element.userId==user.id){
        review=element;
        loadingReview=false;
      }
    });
    reviews=businessData.reviews!.where((element) => user.id!=element.userId).toList();
  }

  changeLinkView(bool value){
    showLinkView=value;
    update();
  }

  listenToBusinessDataChange(){
    businessDataSubscription=Get.find<BusinessesController>().businesses.listen((data) {
      data.forEach((element) {
        if(element.id==businessData.id){
          businessData=BusinessData.fromJson(element.toMap(), element.id!);
          setReviews();
        }
      });
      update();
    });
  }

  loadReviewImages(BuildContext context)async{
    var data= await Get.find<MultiMediaService>().getImages(context);
    if(data!=null){
      review.photos!.addAll(data);
      update();
    }
  }

  giveReview()async{
    loadingReview=true;
    update();
    try{
      var uuid = Uuid();
      review.id=uuid.v4();
      review.userId=Get.find<UserController>().currentUser.value.id;
      review.businessId=businessData.id;
      review.time=DateTime.now();
      await Get.find<BusinessesController>().giveReview(businessData.id!, review);
      loadingReview=false;
    }
    catch(e){
      loadingReview=false;
      Show.showErrorSnackBar("Error", e as String);
    }
    update();
  }

  setGraphData()async{
    List<TimeSeriesModel> newGraphData=await Get.find<FireBaseDatabaseService>().getAllClicks(businessData.id!);
    DateTime now=DateTime.now();
    newGraphData=newGraphData.where((element) => element.time!.isAfter(now.subtract(Duration(days: 6))) && element.time!.isBefore(now)).toList();
    newGraphData.forEach((element) {
      totalClicks+=element.clicks!;
      totalSocialClicks+=element.socialClicks!;
    });
    graphData=newGraphData.map((e) => {"time":"${DateFormat.E().format(e.time!)}","clicks":e.clicks,"socials":e.socialClicks}).toList();
    update();
  }

  @override
  void onInit() {
    listenToBusinessDataChange();
    setReviews();
    Get.find<FireBaseDatabaseService>().addClick(businessData.id!, DateTime.now());
    if(Get.find<UserController>().currentUser.value.id==businessData.ownerId){
      isOwner=true;
      setGraphData();
    }else{

      // Get.find<LocalStorageService>().addBusinessToRecentSearch(businessData.id!);
    }
    super.onInit();
  }


  // getStatisticData() async {
  //   widget.pageClicksData.forEach((element) {
  //     setState(() {
  //       totalClicks+=element.clicks;
  //     });
  //   });
  //   widget.socialClickData.forEach((element) {
  //     setState(() {
  //       totalClicks+=element.clicks;
  //     });
  //   });
  //   for( var i in List.generate(7, (index) => index)){
  //     DateTime date=now.subtract(Duration(days: i));
  //     TimeSeriesClick data=widget.pageClicksData.firstWhere((element) => element.time.day==date.day && element.time.year==date.year && element.time.month==date.month,orElse: ()=>null);
  //     TimeSeriesClick data1=widget.pageClicksData.firstWhere((element) => element.time.day==date.day && element.time.year==date.year && element.time.month==date.month,orElse: ()=>null);
  //     Map dateData={};
  //     if(data!=null){
  //       dateData['day']=DateFormat.E().format(date);
  //       dateData['clicks']=data.clicks;
  //     }
  //     if(data1!=null){
  //       if(dateData.containsKey("day")){
  //         dateData['clicks']=dateData['clicks']+data1.clicks;
  //       }else{
  //         dateData['day']=DateFormat.E().format(date);
  //         dateData['clicks']=data1.clicks;
  //       }
  //     }
  //     if(data==null && data1==null){
  //       dateData['day']=DateFormat.E().format(date);
  //       dateData['clicks']=0;
  //     }
  //     _data1.add(Map.from(dateData));
  //   }
  //   _data1=_data1.reversed.toList();
  //   setState(() {
  //
  //   });
  // }

  @override
  void onClose() {
    businessDataSubscription.cancel();
    super.onClose();
  }
}
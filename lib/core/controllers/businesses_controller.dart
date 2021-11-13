import 'dart:async';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/firebaseauth_service.dart';
import 'package:blackeco/core/services/firebasestorage_service.dart';
import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/core/services/localstorage_service.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/models/day_time_picker.dart';
import 'package:blackeco/models/review.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:get/get.dart';

class BusinessesController extends GetxService{
  RxList<BusinessData> businesses = RxList();
  RxList<BusinessData> myBusinesses=RxList();
  RxList<BusinessData> recentBusinesses=RxList();

  late StreamSubscription businessesStreamSubscription;

  listenToBusinessesStream(){
    businessesStreamSubscription=Get.find<FireStoreService>().businessesStream().listen((event) {
      businesses.clear();
      myBusinesses.clear();
      List<BusinessData> newBusinesses=event.docs.map((e) => BusinessData.fromJson(Map.from(e.data() as Map),e.id)).toList();
      newBusinesses.forEach((element) {
        element.status=checkOpeningTime(element.timeData!);
      });
      businesses.addAll(newBusinesses);
      setOwnerBusiness();
      listenToRecentSearches();
    });
  }

  setOwnerBusiness(){
    if(Get.find<FireBaseAuthService>().auth.currentUser?.uid!=null){
      businesses.forEach((element) {
        if(Get.find<FireBaseAuthService>().auth.currentUser!.uid==element.ownerId){
          myBusinesses.add(element);
        }
      });
    }
    else{
      myBusinesses.clear();
    }
  }

  updateBusiness(BusinessData business)async{
    if(!business.coverImage!.contains("firebasestorage")){
      String? coverImage=await Get.find<FireBaseStorageService>().uploadImage(business.coverImage!);
      if(coverImage!=null){
        business.coverImage=coverImage;
      }
      else{
        business.coverImage=null;
      }
    }
    List<String> photos=await Get.find<FireBaseStorageService>().uploadMultipleImages(business.images!,600,600,90);
    business.images=photos;
    List<String> serviceImages=await Get.find<FireBaseStorageService>().uploadMultipleImages(business.menuImages!,600,600,90);
    business.menuImages=serviceImages;
    await Get.find<FireStoreService>().updateBusiness(business);
  }

  uploadBusiness(BusinessData business)async{
    try{
//      Get.find<NotificationService>().showNotification("Uploading Business", "Your business is uploading right now");
      business.ownerId=Get.find<UserController>().currentUser.value.id;
      String? coverImage=await Get.find<FireBaseStorageService>().uploadImage(business.coverImage!);
      if(coverImage!=null){
        business.coverImage=coverImage;
      }
      else{
        business.coverImage=null;
      }
      List<String> photos=await Get.find<FireBaseStorageService>().uploadMultipleImages(business.images!,600,600,90);
      business.images=photos;
      List<String> serviceImages=await Get.find<FireBaseStorageService>().uploadMultipleImages(business.menuImages!,600,600,90);
      business.menuImages=serviceImages;
      business.linkClicks=0;
      business.pageViews=0;
      business.date=DateTime.now();
      await Get.find<FireStoreService>().saveBusiness(business);
//      Get.find<NotificationService>().showNotification("Business Uploaded", "Your business has been listed");
    }
    catch(e){
      rethrow;
    }
  }


  giveReview(String businessId,ReviewModel data)async{
    try{
      List<String> images=await Get.find<FireBaseStorageService>().uploadMultipleImages(data.photos!, 400, 300, 85);
      data.photos=images;
      await Get.find<FireStoreService>().addReview(businessId, data);
    }
    catch(e){
      rethrow;
    }
  }


  addToFavorite(String businessId){
    try{
     Get.find<FireStoreService>().addToFavorite(businessId, Get.find<UserController>().currentUser.value.id!);
    }
    catch(e){
      Show.showErrorSnackBar("Error", "$e");
    }
  }

  removeFromFavorite(String businessId){
    try{
      Get.find<FireStoreService>().removeFromFavorite(businessId, Get.find<UserController>().currentUser.value.id!);
    }
    catch(e){
      Show.showErrorSnackBar("Error", "$e");
    }
  }


  bool checkOpeningTime(List<AppTimeData> data){
    DateTime now=DateTime.now();
    bool opened=false;
    data.forEach((element) {
      if(element.place+1==now.weekday && element.status!){
        DateTime startTime=DateTime(now.year,now.month,now.day,element.startTime.hour,element.startTime.minute);
        DateTime endTime=DateTime(now.year,now.month,now.day,element.endTime.hour,element.endTime.minute);

        if(now.isAfter(startTime) && now.isBefore(endTime)){
          opened=true;
        }
      }
    });
    return opened;
  }

  listenToRecentSearches(){
    List<Map> recentSearches=Get.find<LocalStorageService>().getRecentSearches();
    if(businesses.length==0){
      return;
    }
    recentSearches.forEach((e) {
      BusinessData business=businesses.firstWhere((element) => element.id==e['id']);
      recentBusinesses.add(business);
    });
    Get.find<LocalStorageService>().box.listenKey("recent", (value){
      value.forEach((e){
        BusinessData business=businesses.firstWhere((element) => element.id==e['id']);
        recentBusinesses.add(business);
      });
    });
  }

  @override
  void onInit() {
    listenToBusinessesStream();
    super.onInit();
  }

  @override
  void onClose() {
    businessesStreamSubscription.cancel();
    super.onClose();
  }
}
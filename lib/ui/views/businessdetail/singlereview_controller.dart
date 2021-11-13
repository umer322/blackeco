
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/models/review.dart';
import 'package:blackeco/models/user_model.dart';
import 'package:get/get.dart';

class SingleReviewController extends GetxController{
  UserModel? user;
  ReviewModel review;
  SingleReviewController(this.review);

  setReviewUser()async{
      if(review.userId==Get.find<UserController>().currentUser.value.id){
        user=Get.find<UserController>().currentUser.value;
      }
      else{
        user=await Get.find<FireStoreService>().getUser(review.userId!);
      }
      update();
  }

  @override
  void onInit() {
    setReviewUser();
    super.onInit();
  }
}
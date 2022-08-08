import 'dart:async';
import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/chat_controller.dart';
import 'package:blackeco/core/services/firebaseauth_service.dart';
import 'package:blackeco/core/services/firebasestorage_service.dart';
import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/core/services/notification_service.dart';
import 'package:blackeco/models/report_model.dart';
import 'package:blackeco/models/user_model.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:blackeco/ui/views/navigationtabs/navigationtabs_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class UserController extends GetxController{
  Rx<UserModel> currentUser = Rx<UserModel>(UserModel());
  StreamSubscription? authUserSubscription;
  StreamSubscription? firestoreUserStream;
  StreamSubscription? reportsStream;
  RxList<ReportModel> reports=RxList();
  final googleSignIn = GoogleSignIn();
  final facebookLogin = FacebookAuth.instance;

  currentUserStream(){
    authUserSubscription=Get.find<FireBaseAuthService>().fireBaseAuthUserStream().listen((User? event1)async{
      if(event1!=null){
        firestoreUserStream = Get.find<FireStoreService>().fireStoreUserStream(event1.uid).listen((event2){
          if(event2.exists){
            try{
              currentUser.value = UserModel.fromJson(Map.from(event2.data() as Map), event2.id);
              setUserNotificationId();
              if( Get.find<ChatController>().chatsSubscription==null){
                Get.find<ChatController>().listenToChat(event2.id);
              }
             if(reportsStream==null){
               reportsStream=Get.find<FireStoreService>().reportsStream(event1.uid).listen((event) {
                 reports.clear();
                 reports.addAll(event.docs.map((e) => ReportModel.fromJson(e.data() as Map, e.id)).toList());
               });
             }
            }
            on Exception catch(exception){
              Show.showErrorSnackBar("User Error", exception.toString());
            }
            catch (e){
              Show.showErrorSnackBar("User Error", e.toString());
            }
          }
        });
      }
      else{
        print(event1);
        if(currentUser.value.chatToken!=null){
          await updateUserChatStatus({"chat_token":null});
        }
        currentUser.value=UserModel(favorites: []);
        reportsStream=null;
        reports.clear();
        Get.find<ChatController>().chats.clear();
        Get.find<ChatController>().chatsSubscription=null;
        Get.find<BusinessesController>().myBusinesses.clear();
      }
      Get.find<BusinessesController>().setOwnerBusiness();
    });
  }


  setUserNotificationId()async{
    var deviceState = await OneSignal.shared.getDeviceState();
    if (deviceState == null || deviceState.userId == null)
      return;
    if(currentUser.value.chatToken!=deviceState.userId){
      updateUserChatStatus({"chat_token":deviceState.userId});
    }
  }

  updateUserChatStatus(Map data)async{
    try{
      await Get.find<FireStoreService>().updateUser(currentUser.value.id!,data);
    }
    catch(e){
      rethrow;
    }
  }

  Future loginWithFacebook()async{
    try{
      final result = await facebookLogin.login();
      print(result.status);
      switch (result.status){
        case LoginStatus.success:
          print("user logged in");
          final AuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.token);
          final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
          User? user = authResult.user;
          print("returnign from facebook");
          Show.showLoader();
          if(user!=null) {
            UserModel? userModel=await Get.find<FireStoreService>().getUser(user.uid);
            if(userModel==null){
              UserModel newUser=UserModel(name: user.displayName,email: user.email!.trim(),);
              await Get.find<FireStoreService>().saveUser(user.uid,newUser);
              if(Get.isDialogOpen!){
                Get.back();
              }
            }
            Get.find<NavigationTabsController>().index=0;
            Get.offAllNamed("/navigation");
          }
          else{
            if(Get.isDialogOpen!){
              Get.back();
            }
            return;
          }
          break;
        case LoginStatus.cancelled:
          if(Get.isDialogOpen!){
            Get.back();
          }
          Show.showErrorSnackBar("Error", "Login cancelled by user");
          return;
        case LoginStatus.failed:
          if(Get.isDialogOpen!){
            Get.back();
          }
          Show.showErrorSnackBar("Error", "Error occured while signing in by facebook");
          return;
        default:
          if(Get.isDialogOpen!){
            Get.back();
          }
          Show.showErrorSnackBar("Error", "Error occured");
          return;
      }
    }
    catch(e){
      if(Get.isDialogOpen!){
        Get.back();
      }
      print("error 2 $e");
      rethrow;
    }
  }

  Future loginWithGoogle()async{
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      if(googleSignInAccount==null){
        Show.showErrorSnackBar("Error", "Cancelled by User");
        return;
      }
      final GoogleSignInAuthentication? googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication?.accessToken,
        idToken: googleSignInAuthentication?.idToken,
      );

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = authResult.user;
      Show.showLoader();
      if(user!=null) {
        UserModel? userModel=await Get.find<FireStoreService>().getUser(user.uid);
        if(userModel==null){
          UserModel newUser=UserModel(name: user.displayName,email: user.email!.trim(),);
          await Get.find<FireStoreService>().saveUser(user.uid,newUser);
        }
        if(Get.isDialogOpen!){
          Get.back();
        }
        Get.find<NavigationTabsController>().index=0;
        Get.offAllNamed("/navigation");
      }
      else{
        if(Get.isDialogOpen!){
          Get.back();
        }
        return;
      }
    } catch (error) {
      if(Get.isDialogOpen!){
        Get.back();
      }
     print("$error");
      rethrow;
    }
  }

  signOut()async{
    await OneSignal.shared.removeExternalUserId();
    await googleSignIn.signOut();
    await facebookLogin.logOut();
    await FirebaseAuth.instance.signOut();
  }

  updateUser(UserModel user)async{
    try{
      if(user.imageUrl!=null){
        if(user.imageUrl!=currentUser.value.imageUrl){
          String? image=await Get.find<FireBaseStorageService>().uploadImage(user.imageUrl!);
          user.imageUrl=image;
        }
      }
      await Get.find<FireStoreService>().updateUser(user.id!,user.toMap());
    }
    catch(e){
      Show.showErrorSnackBar("Error", "Cannot update user right now");
    }
  }

  @override
  void onInit() {
    currentUserStream();
    super.onInit();
  }

  @override
  void onClose() {
    reportsStream?.cancel();
    authUserSubscription?.cancel();
    firestoreUserStream?.cancel();
    super.onClose();
  }
}
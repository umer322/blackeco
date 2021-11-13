
import 'dart:async';

import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/models/chat.dart';
import 'package:blackeco/models/message.dart';
import 'package:blackeco/models/user_model.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SingleChatController extends GetxController{
  BusinessData? businessData;
  bool fromShop;
  ChatModel? chatModel;
  String? chattingWith;
  bool isOwner=false;
  UserModel? user;
  late TextEditingController chatController;
  SingleChatController(this.fromShop,{this.businessData,this.chatModel,this.user});
  List<Message> messages=[];
  late StreamSubscription messagesSubscription;



  setBusiness(){
    businessData=Get.find<BusinessesController>().businesses.firstWhere((element) => element.id==chatModel!.businessId);
  }


  checkOwner(){
    if(chatModel!.businessOwnerId==Get.find<UserController>().currentUser.value.id){
      isOwner=true;
      update();
    }
  }

  setChattingWith(){
    if(chatModel!.id!.split("_")[0]==Get.find<UserController>().currentUser.value.id!){
      chattingWith=chatModel!.id!.split("_")[1];
    }
    else{
      chattingWith=chatModel!.id!.split("_")[0];
    }
  }

  @override
  void onInit() {
    chatController=TextEditingController();
    if(businessData==null){
      setBusiness();
    }
    if(chatModel==null){
      chatModel=ChatModel(forBusiness: fromShop,businessId: businessData!.id,businessOwnerId: businessData!.ownerId,ids: {});
      String chatId=setChatId();
      chatModel!.id=chatId;
      setChatIds(chatId);
    }else{
      checkOwner();
    }
    setChattingWith();
    Get.find<UserController>().updateUserChatStatus({'chatting_with':chattingWith});
    listenToMessages();
    super.onInit();
  }


  setChatIds(String id){
    chatModel!.ids!.addAll({id.split("_")[0]:true,id.split("_")[1]:true});
  }

  setChattingUser()async{
    try{
      if(user==null){
        user=await Get.find<FireStoreService>().getUser(chattingWith!);
      }
      update();
    }
    catch(e){
      Show.showErrorSnackBar("Error", "$e");
    }
  }

  sendMessage(){
    try{
      DateTime now=DateTime.now();
      chatModel!.lastMessageUser=Get.find<UserController>().currentUser.value.id!;
      chatModel!.lastMessage=chatController.text;
      chatModel!.lastUpdated=now;
      Message message=Message(message: chatController.text,senderId: Get.find<UserController>().currentUser.value.id!,time:now);
      Get.find<FireStoreService>().saveMessage(chatModel!, message);
      chatController.clear();
    }
    catch(e){
      Show.showErrorSnackBar("Error", "$e");
    }
  }

  setChatId(){
    String currentUserId=Get.find<UserController>().currentUser.value.id!;
    if(currentUserId.compareTo(businessData!.ownerId!)==-1){
      return currentUserId+"_"+businessData!.ownerId!+"_"+businessData!.id!;
    }
    else{
      return businessData!.ownerId!+"_"+currentUserId+"_"+businessData!.id!;
    }
  }

  listenToMessages(){
    messagesSubscription=Get.find<FireStoreService>().getChatMessages(chatModel!.id!).listen((event) {
      List<Message> newMessages=event.docs.map((e) => Message.fromJson(e.data() as Map, e.id)).toList();
      newMessages.sort((a,b)=>b.time!.compareTo(a.time!));
      messages.clear();
      messages.addAll(newMessages);
      update();
    });
  }

  @override
  void onClose() {
    messagesSubscription.cancel();
    super.onClose();
  }


  formatDate(DateTime time){
    DateTime now=DateTime.now();
    if(now.day==time.day && now.year == time.year && now.month == time.month){
      return DateFormat.jm().format(time);
    }
    else if(now.year == time.year){
      return DateFormat.MMMd().format(time)+" AT "+DateFormat.jm().format(time);
    }
      else{
        return DateFormat.yMMMd().format(time)+" AT "+DateFormat.jm().format(time);
      }
  }
}

import 'dart:async';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/chat_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/core/services/notification_service.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/models/chat.dart';
import 'package:blackeco/models/message.dart';
import 'package:blackeco/models/user_model.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  late StreamSubscription userSubscription;
  late StreamSubscription chatModelSubscription;
  listenToChatModel(){
    chatModelSubscription=Get.find<ChatController>().chats.listen((value)async{
     if(value.length>0){
       List chatModels=value.where((element) => chatModel!.id==element.id).toList();

      if(chatModels.length>0){
        chatModel=chatModels[0];
      }
      else{
        Get.back();
      }
     }
    });
  }

  setBusiness(){
    businessData=Get.find<BusinessesController>().businesses.firstWhere((element) => element.id==chatModel?.businessId);
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
    String chatId=setChatId();
    if(chatModel==null){
      List<ChatModel> model=Get.find<ChatController>().chats.where((element) => element.id==chatId).toList();
      if(model.length>0) {
        chatModel=model[0];
        return;
      }
      chatModel=ChatModel(forBusiness: fromShop,businessId: businessData!.id,businessOwnerId: businessData!.ownerId,ids: {},notifications: {});
      chatModel!.id=chatId;
      setChatIds(chatId);
    }else{
      checkOwner();
    }
    setChattingWith();
    setChattingUser();
    Get.find<UserController>().updateUserChatStatus({'chatting_with':chattingWith});
    listenToChatModel();
    listenToMessages();
    super.onInit();
  }


  setChatIds(String id){
    chatModel!.ids!.addAll({id.split("_")[0]:true,id.split("_")[1]:true});
    chatModel!.notifications!.addAll({id.split("_")[0]:true,id.split("_")[1]:true});
  }

  setChattingUser()async{
    try{
        userSubscription=Get.find<FireStoreService>().getUserStream(chattingWith!).listen((event) {
          if(event.exists){
            print(event.data());
            user=UserModel.fromJson(event.data()as Map,event.id);
            update();
          }
        });

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

      bool allowNotification=chatModel!.notifications![chattingWith]??false;

      if(user!.chattingWith!=message.senderId && allowNotification){
        Get.find<NotificationService>().handleSendNotification(user!.chatToken!,isOwner?businessData!.name!:Get.find<UserController>().currentUser.value.name??"Person",message.message!,chatModel!.id!);
      }
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

  showSettings(BuildContext context)async{
    String currentUserId=Get.find<UserController>().currentUser.value.id!;
    await Get.bottomSheet(GetBuilder<SingleChatController>(builder: (controller)=>Container(
      decoration: BoxDecoration(color:Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15))),
      padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: Get.height*0.02,),
          AutoSizeText("Notifications",style: TextStyles.h2,),
          SizedBox(height: Get.height*0.02,),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            title: AutoSizeText("Snooze Notifications"),
            trailing: CupertinoSwitch(onChanged: (val)async{
              try{
                Show.showLoader();
                chatModel!.notifications![currentUserId]=!chatModel!.notifications![currentUserId];
                update();
                await Get.find<ChatController>().updateChat(chatModel!.id!, currentUserId, chatModel!.notifications![currentUserId]);
                if(Get.isOverlaysOpen){
                  Get.back();
                }
              }
              catch(e){
                if(Get.isOverlaysOpen){
                  Get.back();
                }
                Show.showErrorSnackBar("Error", "$e");
              }
            },value: chatModel!.notifications![currentUserId]??true,),
          ),
          SizedBox(height: Get.height*0.02,),
          TextButton(onPressed: ()async{
            Get.back();
            changeUserBlockStatus();
          }, child: AutoSizeText("${chatModel!.ids![chattingWith]==true?"Block":"Unblock"} ${isOwner?"${user!.name}":"${businessData!.name}"}")),
          TextButton(onPressed: (){
            Get.back();
            reportChat();
          }, child: AutoSizeText("Report ${isOwner?"${user!.name}":"${businessData!.name}"}")),
          TextButton(onPressed: ()async{
            try{
              Get.back();
              Show.showLoader();
              await Get.find<FireStoreService>().deleteUserChat(chatModel!.id!,chattingWith!,Get.find<UserController>().currentUser.value.id!);
              if(Get.isOverlaysOpen){
                Get.back();
              }
              Get.back();
            }
            catch(e){
              if(Get.isOverlaysOpen){
                Get.back();
              }
              Show.showErrorSnackBar("Error", "$e");
            }
          }, child: AutoSizeText("Delete Conversation")),
          SizedBox(height: Get.height*0.02,),
        ],
      ),
    )),isScrollControlled: true,barrierColor: Get.isDarkMode?Colors.white12:Colors.black12);
  }

  @override
  void onClose() {
    messagesSubscription.cancel();
    userSubscription.cancel();
    chatModelSubscription.cancel();
    super.onClose();
  }

  reportChat(){
    Get.defaultDialog(title: "Reported",middleText: "This user has been reported.",onConfirm: (){
      Get.back();
    });
  }

  changeUserBlockStatus()async{
    try{
      Show.showLoader();
      if(chatModel!.ids![chattingWith]==true){
        await Get.find<ChatController>().blockUser(chatModel!.id!, chattingWith!);
        chatModel!.ids![chattingWith!]=false;
      }
      else{
        await Get.find<ChatController>().unblockUser(chatModel!.id!, chattingWith!);
        chatModel!.ids![chattingWith!]=true;
      }
      update();
      if(Get.isOverlaysOpen){
        Get.back();
      }
    }
    catch(e){
      if(Get.isOverlaysOpen){
        Get.back();
      }
      Show.showErrorSnackBar("Error", "$e");
    }
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
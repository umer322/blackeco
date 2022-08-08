import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/chat_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/models/chat.dart';
import 'package:blackeco/models/user_model.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/app_progress_indicator.dart';
import 'package:blackeco/ui/styled_widgets/drawer/drawer_view.dart';
import 'package:blackeco/ui/styled_widgets/loginerror_view.dart';
import 'package:blackeco/ui/views/messages/messages_controller.dart';
import 'package:blackeco/ui/views/messages/singlechat/singlechat_controller.dart';
import 'package:blackeco/ui/views/messages/singlechat/singlechat_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class MessagesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme=Theme.of(context);
    return Obx((){
      return Get.find<UserController>().currentUser.value.id == null ?
      LoginErrorView() :
      GetBuilder<MessagesController>(
          init: MessagesController(),
          builder:(controller){
            return Scaffold(
              drawer: DrawerView(),
                appBar: AppBar(
                  title: AutoSizeText("Inbox"),actions: [
                  ],
                ),
                body: Column(
                  children: [
                    SizedBox(height: Get.height*0.015,),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: theme.accentColor))
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(left: Get.width*0.05),
                        child: Row(children: [
                          GestureDetector(
                            onTap: (){
                              controller.changeView(0);
                            },
                            child: AnimatedContainer(duration: Duration(seconds: 1),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: controller.showView==0?theme.primaryColor:theme.accentColor,width: controller.showView==0?2:0))
                              ),
                              padding: EdgeInsets.only(bottom: Get.height*0.02),
                              child: AutoSizeText("Messages",style: TextStyles.title1.copyWith(color: controller.showView==0?theme.primaryColor:theme.accentColor),),),
                          ),
                          SizedBox(width: Get.width*0.05,),
                          GestureDetector(
                            onTap: (){
                              controller.changeView(1);
                            },
                            child: AnimatedContainer(duration: Duration(seconds: 1),
                              decoration: BoxDecoration(
                                  border: Border(bottom: BorderSide(color: controller.showView==1?theme.primaryColor:theme.accentColor,width: controller.showView==1?2:0))
                              ),
                              padding: EdgeInsets.only(bottom: Get.height*0.02),
                              child: AutoSizeText("Responses",style: TextStyles.title1.copyWith(color: controller.showView==1?theme.primaryColor:theme.accentColor),),),
                          ),
                        ],),
                      ),
                    ),
                    controller.loading?Center(child: AppProgressIndicator(),):Expanded(
                      child: ListView.builder(
                          itemCount: controller.chats.length,
                          itemBuilder: (context,index){
                        return ChatRow(controller.chats[index]);
                      }),
                    )
                  ],
                )
            );
          }
      );
    });
  }
}


class ChatRow extends StatelessWidget {
  final ChatModel model;
  ChatRow(this.model);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatRowController>(
      didChangeDependencies: (state){
        if(model.lastUpdated!.compareTo(state.controller!.chatModel.lastUpdated!)>0){
          state.controller!.update();
        }
      },
        global: false,
        init: ChatRowController(model),
        builder: (controller){
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.width*0.05,vertical: Get.width*0.02),
        child: GestureDetector(
          onTap: (){
            Get.to(()=>SingleChatView(),binding: BindingsBuilder((){
              Get.put(SingleChatController(false,businessData: controller.businessData,chatModel: model,user: controller.isOwner?controller.chattingWith:null));
            }));
          },
          child: controller.isOwner&&controller.chattingWith==null?Center(child: CircularProgressIndicator(),):Row(children: [
            CircleAvatar(
              radius: Get.width*0.08,
              backgroundImage: controller.isOwner?controller.chattingWith!.imageUrl==null?AssetImage("assets/person.png") as ImageProvider:CachedNetworkImageProvider(controller.chattingWith!.imageUrl!):CachedNetworkImageProvider(controller.businessData!.coverImage!),
            ),
            SizedBox(width: Get.width*0.05,),
            Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText("${controller.isOwner?controller.chattingWith!.name:controller.businessData!.name}",style: TextStyles.h2,),
                  Flexible(child: Row(children: [Flexible(child: AutoSizeText("${controller.chatModel.lastMessage!}",maxLines: 1,style: TextStyles.body1.copyWith(color:
                  Theme.of(context).hintColor),overflow: TextOverflow.ellipsis,)),
                    SizedBox(width:Get.width*0.02,),
                    Container(height: Get.width*0.02,width: Get.width*0.02,decoration: BoxDecoration(shape: BoxShape.circle,color:  Theme.of(context).hintColor),),
                    SizedBox(width:Get.width*0.02,),
                    AutoSizeText(timeago.format(controller.chatModel.lastUpdated!),maxLines: 1,style: TextStyles.body1.copyWith(color:
                    Theme.of(context).hintColor),)],))
                ],
              ),
            )
          ],),
        ),
      );

//        ListTile(
//        leading: CircleAvatar(
//          radius: 50,
//          backgroundImage: controller.isOwner?controller.chattingWith!.imageUrl==null?AssetImage("assets/person.png") as ImageProvider:CachedNetworkImageProvider(controller.chattingWith!.imageUrl!):CachedNetworkImageProvider(controller.businessData!.coverImage!),
//        ),
//        title: AutoSizeText(controller.isOwner?controller.chattingWith!.name!:controller.businessData!.name!),
//      );
    });
  }
}


class ChatRowController extends GetxController{
  bool isOwner=false;
  UserModel? chattingWith;
  BusinessData? businessData;
  ChatModel chatModel;
  ChatRowController(this.chatModel);
  int showView=0;
  late StreamSubscription chatsSubscription;

  listenToChat(){
    chatsSubscription=Get.find<ChatController>().chats.listen((value) {
      List<ChatModel> newChats=List.from(value);
      newChats=newChats.where((element) => element.id==chatModel.id).toList();
      if(newChats.length>0){
        chatModel=newChats[0];
      }
      update();
    });
    update();
  }


  setBusinessData(String id)async{
    String currentUserid=Get.find<UserController>().currentUser.value.id!;
    businessData=Get.find<BusinessesController>().businesses.firstWhere((element) => element.id==id);
    if(chatModel.businessOwnerId==currentUserid){
      isOwner=true;
    }
    if(chatModel.id!.split("_")[0]==currentUserid){
      chattingWith=await Get.find<FireStoreService>().getUser(chatModel.id!.split("_")[1]);
    }
    else{
      chattingWith=await Get.find<FireStoreService>().getUser(chatModel.id!.split("_")[0]);
    }
    update();
  }

  @override
  void onInit() {
    if(chatModel.forBusiness!){
      setBusinessData(chatModel.businessId!);
    }
    listenToChat();
    super.onInit();
  }

  @override
  void onClose() {
    chatsSubscription.cancel();
    super.onClose();
  }
}


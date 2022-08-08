import 'dart:async';

import 'package:blackeco/core/controllers/chat_controller.dart';
import 'package:blackeco/models/chat.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController{
  List<ChatModel> chats=[];
  int showView=0;
  late StreamSubscription chatsSubscription;
  bool loading=true;
  listenToChat(){
    chats=Get.find<ChatController>().chats.reversed.toList();
    chats.sort((a,b)=>b.lastUpdated!.compareTo(a.lastUpdated!));
    loading=false;
    chatsSubscription=Get.find<ChatController>().chats.listen((value)async{
      loading=true;
      update();
      await Future.delayed(Duration(milliseconds: 300));
      chats=List<ChatModel>.from(value).reversed.toList();
      chats.sort((a,b)=>b.lastUpdated!.compareTo(a.lastUpdated!));
      loading=false;
      update();
    });
    update();
  }

  changeView(int value){
    showView=value;
    update();
  }

  @override
  void onInit() {
    listenToChat();
    super.onInit();
  }

  @override
  void onClose() {
    chatsSubscription.cancel();
    super.onClose();
  }
}
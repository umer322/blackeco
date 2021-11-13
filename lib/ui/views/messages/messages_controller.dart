import 'dart:async';

import 'package:blackeco/core/controllers/chat_controller.dart';
import 'package:blackeco/models/chat.dart';
import 'package:get/get.dart';

class MessagesController extends GetxController{
  List<ChatModel> chats=[];
  int showView=0;
  late StreamSubscription chatsSubscription;

  listenToChat(){
    chats=Get.find<ChatController>().chats;
    chatsSubscription=Get.find<ChatController>().chats.listen((value) {
      chats=value;
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
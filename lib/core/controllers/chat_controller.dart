
import 'dart:async';

import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/models/chat.dart';
import 'package:get/get.dart';

class ChatController extends GetxService{
  RxList<ChatModel> chats=RxList();

 StreamSubscription? chatsSubscription;

  listenToChat(String id){
      chatsSubscription=Get.find<FireStoreService>().getUserChats(id).listen((event) {
        print(event.docs.length);
        List<ChatModel> newChats=event.docs.map((e) => ChatModel.fromJson(e.data() as Map, e.id)).toList();
        chats.clear();
        chats.addAll(newChats);
      });
  }

  @override
  void onClose() {
    chatsSubscription?.cancel();
    super.onClose();
  }
}
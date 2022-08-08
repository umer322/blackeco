
import 'dart:async';

import 'package:blackeco/core/services/firestore_service.dart';
import 'package:blackeco/models/chat.dart';
import 'package:get/get.dart';

class ChatController extends GetxService{
  RxList<ChatModel> chats=RxList();

 StreamSubscription? chatsSubscription;

  listenToChat(String id){
      chatsSubscription=Get.find<FireStoreService>().getUserChats(id).listen((event) {
        List<ChatModel> newChats=event.docs.map((e) => ChatModel.fromJson(e.data() as Map, e.id)).toList();
        chats.clear();
        newChats.sort((a,b)=>b.lastUpdated!.compareTo(a.lastUpdated!));
        chats.addAll(newChats);
      });
  }



  updateChat(String chatId,String userId,bool type)async{
    try{
      await Get.find<FireStoreService>().updateUserChat(chatId, userId, type);
    }
    catch(e){
      rethrow;
    }
  }

  blockUser(String chatId,String userId)async{
    try{
      await Get.find<FireStoreService>().blockUser(chatId, userId);
    }
    catch(e){
      rethrow;
    }
  }

  unblockUser(String chatId,String userId)async{
    try{
      await Get.find<FireStoreService>().unblockUser(chatId, userId);
    }
    catch(e){
      rethrow;
    }
  }

  @override
  void onClose() {
    chatsSubscription?.cancel();
    super.onClose();
  }
}
import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/models/message.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/views/messages/singlechat/singlechat_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SingleChatView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()async{
          if(MediaQuery.of(context).viewInsets.bottom!=0){
            FocusScope.of(context).requestFocus(FocusNode());
            return false;
          }
          Get.find<UserController>().updateUserChatStatus({'chatting_with':null});
          return true;
        },
      child: GetBuilder<SingleChatController>(builder: (controller){
        return Scaffold(
          appBar: AppBar(
            title: controller.isOwner?controller.user==null?SizedBox():Row(children: [
              CircleAvatar(
                backgroundImage: controller.user!.imageUrl==null?AssetImage("assets/person.png") as ImageProvider:CachedNetworkImageProvider(controller.user!.imageUrl!),
              ),
              SizedBox(width: 10,),
              AutoSizeText(controller.user!.name!,style: TextStyles.h2.copyWith(color: Theme.of(context).primaryColorDark),)
            ],):Row(children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(controller.businessData!.coverImage!),
              ),
              SizedBox(width: 10,),
              AutoSizeText(controller.businessData!.name!,style: TextStyles.h2.copyWith(color: Theme.of(context).primaryColorDark),)
            ],),
            actions: [
              IconButton(onPressed: (){
                controller.showSettings(context);
              },icon: Icon(Icons.more_horiz))
            ],
          ),
          body: Padding(
            padding: EdgeInsets.only(bottom: Get.height*0.025,left: Get.width*0.05,right:Get.width*0.05),
            child: Column(
              children: [
                Expanded(child: ListView.builder(
                    reverse: true,
                    itemCount: controller.messages.length,
                    itemBuilder: (context,index){
                      Message message=controller.messages[index];
                  return Column(children: [
                    index==controller.messages.length-1?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [AutoSizeText(controller.formatDate(message.time!))],):
                    controller.messages[index+1].time!.difference(message.time!).inMinutes.abs()>5?Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [AutoSizeText(controller.formatDate(message.time!))],):SizedBox(),
                    controller.chattingWith==controller.messages[index].senderId?Row(children: [
                      Expanded(
                          flex:3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: Get.height*0.005),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: Get.width*0.05,
                                      vertical: Get.width*0.03
                                  ),
                                   child: AutoSizeText(controller.messages[index].message!,style: TextStyles.h3,))
                            ],)),
                      Expanded(
                          flex: 1,
                          child: SizedBox()),
                    ],):
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                            flex: 1,
                            child: SizedBox()),
                        Expanded(
                            flex:3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: Get.height*0.005),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: Get.width*0.05,
                                      vertical: Get.width*0.03
                                    ),
                                    decoration: BoxDecoration(color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(10)),
                                    child: AutoSizeText(controller.messages[index].message!,style: TextStyles.h3.copyWith(color: Colors.white),))
                              ],))
                      ],)
                  ],);
                })),
                controller.chatModel!.ids![controller.chattingWith]==true?Row(children: [
                  Flexible(child: TextField(
                    onChanged: (val){
                      controller.update();
                    },
                    controller: controller.chatController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Type a message',
                        contentPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 0)
                    ),
                  )),
                  IconButton(icon: Icon(Icons.send), onPressed: controller.chatController.text.length==0?null:(){
                    controller.sendMessage();
                    FocusScope.of(context).requestFocus(FocusNode());
                  })
                ],):TextButton(child: AutoSizeText("You have blocked this contact. Tap to unblock"),onPressed: (){
                  controller.changeUserBlockStatus();
                },)
              ],
            ),
          ),
        );
      }),
    );
  }
}

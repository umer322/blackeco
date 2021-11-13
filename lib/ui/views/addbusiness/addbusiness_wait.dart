import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/styled_widgets/styled_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddBusinessWait extends StatelessWidget {
  final bool updating;
  AddBusinessWait(this.updating);
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AutoSizeText("Please Wait",style: TextStyle(color: Theme.of(context).primaryColor),presetFontSizes: [20,18,16],),
          SizedBox(height: 15,),
          AutoSizeText("We are ${updating?"Updating":"creating"} your business listing.\n It will be live in short time.",maxLines: 2,presetFontSizes: [16,14],textAlign: TextAlign.center,),
          SizedBox(height: 15,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
              ),
              SizedBox(width: 5,),
              Container(
                height: 35,
                width: 35,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
              ),
              SizedBox(width: 5,),
              Container(
                height: 15,
                width: 15,
                decoration: BoxDecoration(shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor),
              )
            ],),
          SizedBox(height: 15,),
          Container(
            width: Get.width*0.4,
            child: StyledButton(title: "Ok"
              ,onPressed: (){
               Get.back();
              },),
          ),
        ],
      ),
    );
  }
}

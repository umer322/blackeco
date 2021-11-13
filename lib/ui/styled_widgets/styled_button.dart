import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StyledButton extends StatelessWidget {
  final String? title;
  final VoidCallback? onPressed;
  StyledButton({@required this.title,this.onPressed});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: Get.width,
        height: Get.height*0.065,
        decoration: BoxDecoration(color: Theme.of(context).primaryColor,borderRadius: BorderRadius.circular(5)),
        child: Center(child: AutoSizeText(title??"",style: TextStyles.title1.copyWith(color: Theme.of(context).backgroundColor),),),
      ),
    );
  }
}

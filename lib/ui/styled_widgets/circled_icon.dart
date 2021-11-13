import 'package:flutter/material.dart';

class CircledIcon extends StatelessWidget {
  final Color? color;
  final IconData iconData;
  final Color? iconColor;
  CircledIcon(this.iconData,{this.color,this.iconColor});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: color??Theme.of(context).primaryColor,
          shape: BoxShape.circle
      ),
      child: Center(child: Icon(iconData,color: iconColor,),),
    );
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: SizedBox(
            width: Get.width*0.2,
            child: FadeInUpBig(
                duration: Duration(seconds: 1),
                child: Hero(
                    tag: "1",
                    child: Image.asset("assets/logo.png")))),
      ),
    );
  }
}

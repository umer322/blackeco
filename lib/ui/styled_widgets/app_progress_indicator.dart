


import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AppProgressIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LottieBuilder.asset("assets/loader.json");
  }
}

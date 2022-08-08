import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ReportSubmittedView extends StatelessWidget {
  final String id;
  ReportSubmittedView(this.id);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Report a Problem"),
      ),
      body: Padding(
        padding:EdgeInsets.symmetric(horizontal: Get.width*0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AutoSizeText("We’ll get back to you soon!",style: TextStyles.h2.copyWith(color: Theme.of(context).primaryColor),textAlign: TextAlign.center,),
            SizedBox(height: Get.height*0.02,),
            AutoSizeText("Ticket ID #$id has been created.\nYou can see the status of your reported tickets in the Ticket center.",textAlign: TextAlign.center,)
          ],
        ),
      ),
    );
  }
}

import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/models/report_model.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/styled_button.dart';
import 'package:blackeco/ui/styled_widgets/styled_textformfield.dart';
import 'package:blackeco/ui/views/contactus/contactus_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReportView extends StatelessWidget {
  final int claimType;
  final String? businessId;
  final String? issue;
  ReportView(this.claimType,{this.issue,this.businessId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Report a Problem"),
      ),
      body: GetBuilder<ContactUsController>(builder: (controller){
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width*0.05),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: Get.height*0.03,),
                  AutoSizeText("Your Issue",style: TextStyles.h1.copyWith(color: Theme.of(context).primaryColor),),
                  SizedBox(height: Get.height*0.02,),
                  StyledTextFormField(
                    hintText: "Your Contact Email",
                    initialValue: Get.find<UserController>().currentUser.value.email,
                    validator: (val){
                      if(val!.isEmpty){
                        return "Email cannot be empty";
                      }
                      else if(!GetUtils.isEmail(val)){
                        return "Enter a valid email";
                      }
                      return null;
                    },
                    onSaved: (val){
                      controller.userReport.contactEmail=val;
                    },
                  ),
                  SizedBox(height: Get.height*0.02,),
                  claimType!=0?
                      StyledTextFormField(
                        enabled: false,
                        hintText: issue,
                      )
                      :DropdownButtonFormField(
                    validator: (String? val){
                      if(val==null){
                        return "Select issue type";
                      }
                      if(val.isEmpty){
                        return "Select issue type";
                      }
                      return null;
                    },
                      value: controller.issueType,
                      hint: AutoSizeText("Issue Type"),
                      onChanged: controller.changeIssueType,
                      items: ReportModel.reportProblemsIssues.map((e) => DropdownMenuItem(child: AutoSizeText(e),value: e,)).toList()),
                  SizedBox(height: Get.height*0.03,),
                  StyledTextFormField(
                    initialValue: controller.userReport.additionalNote,
                    hintText: "Additional Notes",
                    maxLines: 7,
                    onSaved: (val){
                      controller.userReport.additionalNote=val;
                    },
                  ),
                  SizedBox(height: Get.height*0.03,),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(onPressed: controller.pickFile, icon: Icon(Icons.file_present), label: AutoSizeText("Add File"))),
                  SizedBox(height: Get.height*0.02,),
                  controller.userReport.fileUrl==null?SizedBox():Chip(label: AutoSizeText(controller.userReport.fileUrl?.split("/").last??"Your File"),labelStyle: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),backgroundColor: Theme.of(context).primaryColor,deleteIconColor: Colors.white,onDeleted: (){
                    controller.userReport.fileUrl=null;
                    controller.update();
                  },),
                  SizedBox(height: Get.height*0.02,),
                  SizedBox(height: Get.height*0.03,),
                  StyledButton(title: "Submit"
                    ,onPressed: ()async{
                      if(controller.formKey.currentState!.validate()){
                        controller.formKey.currentState!.save();
                        controller.userReport.claimType=false;
                        if(claimType==1){
                          controller.userReport.businessId=businessId;
                          controller.userReport.claimType=true;
                          controller.userReport.issueType=issue;
                        }
                        if(claimType==2){
                          controller.userReport.businessId=businessId;
                          controller.userReport.issueType=issue;
                        }
                        await controller.sendReport();
                      }
                    },),
                ],
              ),
            ),
          ),
        );
      },),
    );
  }
}

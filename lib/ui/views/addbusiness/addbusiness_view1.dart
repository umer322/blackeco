import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/services/location_service.dart';
import 'package:blackeco/models/category_model.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/styled_button.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_controller.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_view2.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AddBusinessViewOne extends StatelessWidget {
  final GlobalKey<FormState> _formKey=GlobalKey();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddBusinessController>(builder: (controller){
      return Scaffold(
        appBar: AppBar(
          title: AutoSizeText("Add a Business"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(Get.width*0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GestureDetector(
                    onTap: ()async{
                      controller.selectCoverImage();
                    },
                    child: controller.businessData!.coverImage!=null?Stack(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: controller.businessData!.coverImage!.contains("firebasestorage")?CachedNetworkImage(imageUrl: controller.businessData!.coverImage!):Image.file(File(controller.businessData!.coverImage!))),
                      Positioned(
                          bottom: 5,
                          right: 5,
                          child:
                      GestureDetector(
                        onTap: (){
                          controller.selectCoverImage();
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.blueGrey
                          ),
                          child: AutoSizeText("Change Cover Photo",style: TextStyle(color: Colors.white),),
                        ),
                      ))
                    ],):Container(
                      height: Get.height*0.2,
                      color: Color(0xffEAEAEA),
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.add_photo_alternate,size: 40,color: Colors.grey,),
                          SizedBox(height: Get.height*0.01,),
                          AutoSizeText("Add Cover Photo",style: TextStyles.body1.copyWith(color: Colors.grey),)
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: Get.height*0.02,),
                  AutoSizeText("Business Info",style: TextStyles.h2.copyWith(color: Theme.of(context).primaryColor),),
                  SizedBox(height: Get.height*0.01,),
                  TextFormField(
                    initialValue: controller.businessData!.name,
                    validator: (val){
                      if(val!.isEmpty){
                        return "Name is required";
                      }
                      return null;
                    },
                    onSaved: (val){
                      controller.businessData!.name=val;
                    },
                    decoration: InputDecoration(
                      hintText: "Business Name"
                    ),
                  ),
                  SizedBox(height: Get.height*0.01,),
                  Row(children: [
                    CountryCodePicker(
                    onChanged: (CountryCode code){
                        controller.businessData!.countryCode=code.dialCode;
                        controller.update();
                    },
                      showFlagMain: true,
                    initialSelection: controller.businessData!.countryCode,
                  ),
                    Flexible(
                      child: TextFormField(
                        initialValue: controller.businessData!.phoneNumber,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9]"))],
                        validator: (val){
                          if(val!.isEmpty){
                            return "Number is required";
                          }
                          return null;
                        },
                        onSaved: (val){
                          controller.businessData!.phoneNumber=val;
                        },
                        decoration: InputDecoration(
                            hintText: "Business Contact Number"
                        ),
                      ),
                    ),
                  ],),
                  SizedBox(height: Get.height*0.01,),
                  TextFormField(
                    initialValue: controller.businessData!.websiteLink,
                    onSaved: (val){
                      controller.businessData!.websiteLink=val;
                    },
                    decoration: InputDecoration(
                        hintText: "Business Website"
                    ),
                  ),
                  SizedBox(height: Get.height*0.01,),
                  DropdownButtonFormField(
                      value: controller.businessData!.category,
                      hint: AutoSizeText("Business Category"),
                      validator: (val){
                        print(val);
                        if(val==null){
                          return "Category is required";
                        }
                        return null;
                      },
                      onChanged: (val){
                        controller.businessData!.category=val as String;
                      },
                      items: CategoryModel.categories.map((e) => DropdownMenuItem(child: AutoSizeText(e),value: e,)).toList()),
                  TextFormField(
                    onChanged: (val){
                      controller.update();
                    },
                    controller: controller.tagsController,
                    decoration: InputDecoration(
                        hintText: "Business Tags",
                      suffixIcon: controller.tagsController.text.length==0?null:IconButton(icon: Icon(Icons.send,color: Theme.of(context).primaryColor,), onPressed: controller.tagsController.text.length==0?null:()async{
                        controller.businessData!.tags!.add(controller.tagsController.text);
                        controller.tagsController.clear();
                        FocusScope.of(context).requestFocus(FocusNode());
                        controller.update();
                      }),
                    ),

                  ),
                  SizedBox(height: Get.height*0.01,),
                  controller.businessData!.tags!.length==0?SizedBox():Wrap(children: [
                    for(String tag in controller.businessData!.tags!)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:2.0),
                        child: Chip(label: AutoSizeText(tag,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),backgroundColor: Theme.of(context).primaryColor,onDeleted: ()async{
                          controller.businessData!.tags!.remove(tag);
                          controller.update();
                        },deleteIconColor: Colors.white,),
                      )
                  ],),
                  SizedBox(height: Get.height*0.01,),
                  TextFormField(
                    controller:controller.businessLocationController,
                    readOnly: true,
                    onTap: ()async{
                      var data =await Get.find<LocationService>().getLocation();
                      if(data!=null){
                        controller.businessData!.location=data;
                        controller.businessLocationController.text=data.formattedAddress!;
                        controller.update();
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Business Location"
                    ),
                  ),
                  SizedBox(height: Get.height*0.01,),
//                  AutoSizeText("Business Info",style: TextStyles.h2.copyWith(color: Theme.of(context).primaryColor),),
//                  SizedBox(height: Get.height*0.01,),
                  TextFormField(
                    initialValue: controller.businessData!.history,
                    onSaved: (val){
                      controller.businessData!.history=val;
                    },
                    decoration: InputDecoration(
                        hintText: "Business History"
                    ),
                  ),
                  SizedBox(height: Get.height*0.01,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(child: Container(
                        width: Get.width*0.25,
                        child: StyledButton(
                            onPressed: (){
                              if(_formKey.currentState!.validate()){
                                 if(controller.businessData!.coverImage==null){
                                    Show.showErrorSnackBar("Error", "Select cover image to continue");
                                    return;
                                  }
                                  if(controller.businessData!.location==null){
                                    Show.showErrorSnackBar("Error", "Select location to continue");
                                    return;
                                  }
                                 _formKey.currentState!.save();
                                  Get.to(AddBusinessViewTwo());
                              }
                            },
                            title: "Next"),
                      ))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

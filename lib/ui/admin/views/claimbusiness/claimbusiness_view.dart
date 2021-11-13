import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/ui/admin/views/claimbusiness/claimbusiness_controller.dart';
import 'package:blackeco/ui/admin/views/singlecomplain/singlecomplain_controller.dart';
import 'package:blackeco/ui/admin/views/singlecomplain/singlecomplain_view.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/styled_textformfield.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ClaimBusinessView extends StatelessWidget {
  const ClaimBusinessView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ClaimBusinessController>(
        init:ClaimBusinessController(),
        builder: (controller){
          return Column(children: [
            Container(
              height: 150,
              child: Card(
                margin: EdgeInsets.symmetric(horizontal: Get.width*0.01,vertical: Get.width*0.01),
                child: Padding(
                  padding:  EdgeInsets.symmetric(horizontal: Get.width*0.01,vertical: Get.width*0.01),
                  child: Row(children: [
                    Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText("Search",style: TextStyles.h2,),
                        SizedBox(height:Get.height*0.01),
                        Flexible(child: StyledTextFormField(
                        ))
                      ],)),
                    SizedBox(width: Get.width*0.02,),
                    Flexible(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AutoSizeText("Status",style: TextStyles.h2,),
                        SizedBox(height:Get.height*0.01),
                        Flexible(child: DropdownButtonFormField(
                          decoration: InputDecoration(
                              enabledBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              focusedBorder:OutlineInputBorder(borderRadius: BorderRadius.circular(10))
                          ),
                          onChanged: controller.checkReportStatus,
                          hint: AutoSizeText("status"),
                          items: ['All','Open','Closed'].map((e) => DropdownMenuItem(child: AutoSizeText(e),value: e,)).toList(),))
                      ],
                    )),
                    SizedBox(width: Get.width*0.02,),
                    Flexible(child: SizedBox()),
                  ],),
                ),
              ),
            ),
            Expanded(child: DataTable2(
                showCheckboxColumn: false,
                headingRowColor: MaterialStateProperty.all(Colors.blueGrey.shade50),
                columnSpacing: 10,
                dataRowHeight: 70,
                columns: [
                  DataColumn2(
                    label: Text('Name'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Additional Message'),
                    size: ColumnSize.M,
                  ),
                  DataColumn2(
                    label: Text('Email'),
                    size: ColumnSize.L,
                  ),
                  DataColumn2(
                    label: Text('Status'),
                    size: ColumnSize.S,
                  ),
                  DataColumn2(
                    label: Text('Date'),
                    size: ColumnSize.M,
                  ),
                ],
                horizontalMargin: 12,
                minWidth: 600,
                empty: Center(
                    child: Container(
                        padding: EdgeInsets.all(20),
                        color: Colors.grey[200],
                        child: Text('No data'))),
                rows: List<DataRow>.generate(
                    controller.reports.length,
                        (index) => DataRow(
                        onSelectChanged: (val){
                          Get.to(()=>SingleComplainView(),binding: BindingsBuilder((){
                            Get.put(SingleComplainController(controller.reports[index]));
                          }));
                        },
                        cells: [
                          DataCell(Row(children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: controller.reports[index].userPicture!=null?CachedNetworkImage(
                                imageUrl: controller.reports[index].userPicture!,
                              ):Image.asset("assets/person.png"),
                            ),
                            SizedBox(width: Get.width*0.01,),
                            Flexible(child: AutoSizeText(controller.reports[index].userName??""))
                          ],)),
                          DataCell(AutoSizeText(controller.reports[index].additionalNote??"")),
                          DataCell(AutoSizeText(controller.reports[index].contactEmail??"")),
                          DataCell(AutoSizeText(controller.reports[index].closed!?"Closed":"Open")),
                          DataCell(AutoSizeText(DateFormat.yMMMEd().format(controller.reports[index].date!))),
                        ]))
            ))
          ],);
        });
  }
}

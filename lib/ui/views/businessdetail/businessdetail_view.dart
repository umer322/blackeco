import 'dart:convert';
import 'dart:io';
import 'package:blackeco/core/services/firebasedatabase_service.dart';
import 'package:blackeco/core/services/localstorage_service.dart';
import 'package:blackeco/models/day_time_picker.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_controller.dart';
import 'package:blackeco/ui/views/addbusiness/addbusiness_view1.dart';
import 'package:blackeco/ui/views/businessdetail/moreinfo_view.dart';
import 'package:blackeco/ui/views/contactus/contactus_controller.dart';
import 'package:blackeco/ui/views/contactus/report_view.dart';
import 'package:blackeco/ui/views/galleryview/gallery_view.dart';
import 'package:blackeco/ui/views/messages/singlechat/singlechat_controller.dart';
import 'package:blackeco/ui/views/messages/singlechat/singlechat_view.dart';
import 'package:flutter/services.dart';
import 'package:flutter_echarts/flutter_echarts.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:auto_size_text/auto_size_text.dart';
import 'package:blackeco/core/controllers/businesses_controller.dart';
import 'package:blackeco/core/controllers/user_controller.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/models/review.dart';
import 'package:blackeco/models/social_media_data.dart';
import 'package:blackeco/ui/shared/show.dart';
import 'package:blackeco/ui/shared/styles.dart';
import 'package:blackeco/ui/styled_widgets/app_progress_indicator.dart';
import 'package:blackeco/ui/views/businessdetail/businessdetail_controller.dart';
import 'package:blackeco/ui/views/businessdetail/singlereview_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class BusinessDetailView extends StatelessWidget {
  final BusinessData businessData;
  BusinessDetailView(this.businessData);
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: GetBuilder<BusinessDetailController>(
          init: BusinessDetailController(businessData),
          builder: (controller) {
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                  actions: [
                    Get.find<UserController>().currentUser.value.id ==
                            controller.businessData.ownerId
                        ? SizedBox()
                        : Obx(() => IconButton(
                            onPressed: () {
                              if (controller.user.id == null) {
                                Show.showErrorSnackBar("Error",
                                    "Please login to add this business to your favorites");
                                return;
                              }
                              if (Get.find<UserController>()
                                  .currentUser
                                  .value
                                  .favorites!
                                  .contains(businessData.id)) {
                                Get.find<BusinessesController>()
                                    .removeFromFavorite(businessData.id!);
                              } else {
                                Get.find<BusinessesController>()
                                    .addToFavorite(businessData.id!);
                              }
                            },
                            icon: Icon(
                              Get.find<UserController>()
                                      .currentUser
                                      .value
                                      .favorites!
                                      .contains(businessData.id!)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.white,
                            ))),
                    IconButton(
                        onPressed: () async {
                          String url = await Get.find<LocalStorageService>()
                              .createBusinessLink(controller.businessData.id!);
                          Share.share(url);
                        },
                        icon: SvgPicture.asset("assets/share.svg")),
                    PopupMenuButton(
                        onSelected: (val) {
                          if (controller.user.id == null) {
                            Show.showErrorSnackBar(
                                "Error", "Please login to continue");
                            return;
                          }
                          if (!controller.isOwner) {
                            if (val == 0) {
                              Get.to(
                                  () => ReportView(
                                        2,
                                        issue: 'Business Complain',
                                        businessId: controller.businessData.id,
                                      ), binding: BindingsBuilder(() {
                                Get.put(ContactUsController());
                              }));
                            } else if (val == 1) {
                              Get.to(
                                  () => ReportView(
                                        1,
                                        issue: 'Claim Business',
                                        businessId: controller.businessData.id,
                                      ), binding: BindingsBuilder(() {
                                Get.put(ContactUsController());
                              }));
                            }
                          } else {
                            if (val == 0) {
                              Get.to(() => AddBusinessViewOne(),
                                  binding: BindingsBuilder(() {
                                Get.put(AddBusinessController(
                                    businessData: controller.businessData));
                              }));
                            }
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Icon(Icons.more_vert, color: Colors.white),
                        ),
                        itemBuilder: (context) => controller.isOwner
                            ? [
                                PopupMenuItem(
                                  child: Text("Edit"),
                                  value: 0,
                                ),
                              ]
                            : [
                                PopupMenuItem(
                                  child: Text("Complain"),
                                  value: 0,
                                ),
                                PopupMenuItem(
                                  child: Text("Claim"),
                                  value: 1,
                                ),
                              ]),
                  ],
                  expandedHeight: Get.height * 0.25,
                  flexibleSpace: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: controller.businessData.coverImage!,
                        fit: BoxFit.cover,
                      ),
                      Positioned.fill(
                          child: Container(
                        padding: EdgeInsets.all(Get.width * 0.05),
                        color: Colors.black26,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            AutoSizeText(
                              controller.businessData.name!,
                              style: TextStyles.h1.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RatingBarIndicator(
                                  rating: controller.businessData.rating!,
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: theme.primaryColor,
                                  ),
                                  unratedColor: theme.primaryColorLight,
                                  itemCount: 5,
                                  itemSize: 16.0,
                                  direction: Axis.horizontal,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (controller.businessData.images!.length >
                                        0) {
                                      Get.to(() => GalleryView(
                                          controller.businessData.images!));
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blueGrey),
                                    child: AutoSizeText(
                                      "See all photos",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ))
                    ],
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(top: Get.width * 0.05),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: theme.colorScheme.secondary))),
                      child: Padding(
                        padding: EdgeInsets.only(left: Get.width * 0.05),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                controller.changeView(0);
                              },
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: controller.showView == 0
                                                ? theme.primaryColor
                                                : theme.colorScheme.secondary,
                                            width: controller.showView == 0
                                                ? 2
                                                : 0))),
                                padding:
                                    EdgeInsets.only(bottom: Get.height * 0.02),
                                child: AutoSizeText(
                                  "About",
                                  style: TextStyles.title1.copyWith(
                                      color: controller.showView == 0
                                          ? theme.primaryColor
                                          : theme.colorScheme.secondary),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.05,
                            ),
                            GestureDetector(
                              onTap: () {
                                controller.changeView(1);
                              },
                              child: AnimatedContainer(
                                duration: Duration(seconds: 1),
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: controller.showView == 1
                                                ? theme.primaryColor
                                                : theme.colorScheme.secondary,
                                            width: controller.showView == 1
                                                ? 2
                                                : 0))),
                                padding:
                                    EdgeInsets.only(bottom: Get.height * 0.02),
                                child: AutoSizeText(
                                  "Reviews",
                                  style: TextStyles.title1.copyWith(
                                      color: controller.showView == 1
                                          ? theme.primaryColor
                                          : theme.colorScheme.secondary),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.05,
                            ),
                            controller.isOwner
                                ? GestureDetector(
                                    onTap: () {
                                      controller.changeView(2);
                                    },
                                    child: AnimatedContainer(
                                      duration: Duration(seconds: 1),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color:
                                                      controller.showView == 2
                                                          ? theme.primaryColor
                                                          : theme.colorScheme.secondary,
                                                  width:
                                                      controller.showView == 2
                                                          ? 2
                                                          : 0))),
                                      padding: EdgeInsets.only(
                                          bottom: Get.height * 0.02),
                                      child: AutoSizeText(
                                        "Statistics",
                                        style: TextStyles.title1.copyWith(
                                            color: controller.showView == 2
                                                ? theme.primaryColor
                                                : theme.colorScheme.secondary),
                                      ),
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: controller.showView == 1
                      ? _BusinessReviewsView()
                      : controller.showView == 0
                          ? _BusinessAboutView()
                          : controller.isOwner
                              ? _StatisticsView()
                              : SizedBox(),
                )
              ],
            );
          }),
    );
  }
}

class _BusinessReviewsView extends GetView<BusinessDetailController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05, vertical: Get.width * 0.03),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _MyReviewSection(),
            SizedBox(
              height: Get.height * 0.02,
            ),
            Row(
              children: [
                AutoSizeText(
                  "Other Reviews",
                  style: TextStyles.h2,
                ),
              ],
            ),
            SizedBox(
              height: Get.height * 0.02,
            ),
            for (ReviewModel review in controller.reviews)
              _SingleReviewSection(review)
          ],
        ),
      ),
    );
  }
}

class _MyReviewSection extends GetView<BusinessDetailController> {
  @override
  Widget build(BuildContext context) {
    return controller.user.id == null
        ? Padding(
            padding: EdgeInsets.symmetric(vertical: Get.height * 0.02),
            child: Center(
              child: AutoSizeText(
                "Login to leave a review",
                style: TextStyles.title1,
              ),
            ),
          )
        : controller.user.id == controller.businessData.ownerId
            ? SizedBox()
            : controller.loadingReview
                ? Center(
                    child: AppProgressIndicator(),
                  )
                : controller.review.id != null
                    ? _SingleReviewSection(controller.review)
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText.rich(TextSpan(children: [
                            TextSpan(
                                text: "Write Review about ",
                                style: TextStyles.body1.copyWith(
                                    color: Theme.of(context).colorScheme.secondary)),
                            TextSpan(text: controller.businessData.name)
                          ])),
                          SizedBox(
                            height: Get.height * 0.02,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                itemSize: Get.width * 0.06,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                unratedColor: Colors.black12,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onRatingUpdate: (rating) {
                                  controller.review.rating = rating;
                                  controller.update();
                                },
                              ),
                              TextButton.icon(
                                  onPressed: () {
                                    controller.loadReviewImages(context);
                                  },
                                  icon: Icon(
                                    Icons.camera_alt,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  label: AutoSizeText(
                                    "Add Photos",
                                    style: TextStyles.caption.copyWith(
                                        color: Theme.of(context).colorScheme.secondary),
                                  ))
                            ],
                          ),
                          controller.review.photos!.length > 0
                              ? Container(
                                  height: Get.height * 0.1,
                                  child: ListView.builder(
                                      itemCount:
                                          controller.review.photos!.length,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        return Stack(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(
                                                  left: Get.width * 0.05),
                                              height: Get.height * 0.1,
                                              width: Get.width * 0.2,
                                              child: Image.file(
                                                File(controller
                                                    .review.photos![index]),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            Positioned(
                                                right: 0,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    controller.review.photos!
                                                        .remove(controller
                                                            .review
                                                            .photos![index]);
                                                    controller.update();
                                                  },
                                                  child: Container(
                                                    width: 25,
                                                    height: 25,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        shape: BoxShape.circle),
                                                    child: Icon(
                                                      Icons.close,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        );
                                      }))
                              : SizedBox(),
                          SizedBox(
                            height: Get.height * 0.01,
                          ),
                          TextField(
                            onChanged: (val) {
                              if (val.isEmpty) {
                                controller.review.message = null;
                                controller.update();
                                return;
                              }
                              controller.review.message = val;
                              controller.update();
                            },
                            textAlignVertical: TextAlignVertical.top,
                            decoration: InputDecoration(
                              hintText: "Type here",
                              filled: true,
                              suffix: controller.review.message == null
                                  ? SizedBox()
                                  : GestureDetector(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        controller.giveReview();
                                      },
                                      child: Icon(
                                        Icons.send,
                                        size: 15,
                                      )),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.white10)),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.white10)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Colors.white10)),
                            ),
                          )
                        ],
                      );
  }
}

class _SingleReviewSection extends StatelessWidget {
  final ReviewModel review;
  _SingleReviewSection(this.review);
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SingleReviewController>(
        init: SingleReviewController(review),
        global: false,
        builder: (controller) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              controller.user == null
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    )
                  : Row(
                      children: [
                        CircleAvatar(
                          radius: Get.width * 0.07,
                          foregroundImage: controller.user!.imageUrl == null
                              ? AssetImage("assets/person.png") as ImageProvider
                              : CachedNetworkImageProvider(
                                  controller.user!.imageUrl!),
                        ),
                        SizedBox(
                          width: Get.width * 0.02,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoSizeText(
                                controller.user!.name!,
                                style: TextStyles.h2,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Theme.of(context).primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.01,
                                  ),
                                  AutoSizeText(
                                      controller.review.rating.toString()),
                                  SizedBox(
                                    width: Get.width * 0.03,
                                  ),
                                  Icon(
                                    Icons.camera_alt,
                                    color: Theme.of(context).primaryColor,
                                    size: 20,
                                  ),
                                  SizedBox(
                                    width: Get.width * 0.01,
                                  ),
                                  AutoSizeText(
                                    controller.review.photos!.length.toString(),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        AutoSizeText(timeago.format(controller.review.time!),
                            style: TextStyles.body1
                                .copyWith(color: Theme.of(context).hintColor))
                      ],
                    ),
              SizedBox(
                height: 8,
              ),
              AutoSizeText(controller.review.message!),
              SizedBox(
                height: review.photos!.length > 0 ? 8 : 0,
              ),
              review.photos!.length > 0
                  ? Container(
                      height: Get.height * 0.15,
                      child: ListView.builder(
                          itemCount: review.photos!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Get.to(() => GalleryView(review.photos!));
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: Get.width * 0.05),
                                height: Get.height * 0.15,
                                width: Get.width * 0.25,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: CachedNetworkImage(
                                      imageUrl: review.photos![index],
                                      fit: BoxFit.cover,
                                    )),
                              ),
                            );
                          }),
                    )
                  : SizedBox(),
              SizedBox(
                height: Get.height * 0.02,
              ),
            ],
          );
        });
  }
}

class _BusinessAboutView extends GetView<BusinessDetailController> {
  @override
  Widget build(BuildContext context) {
    DateTime now=DateTime.now();
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: Get.height * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: AutoSizeText(
            controller.businessData.status! ? "Open Now" : "Closed",
            presetFontSizes: [FontSizes.s22,FontSizes.s20],
            style: TextStyles.caption.copyWith(
                color: controller.businessData.status!
                    ? Theme.of(context).buttonColor
                    : Theme.of(context).errorColor),
          ),
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal:Get.width*0.05),
          child: AutoSizeText("Opening Hours",style: TextStyles.h1.copyWith(color: Theme.of(context).primaryColor),),
        ),
        for (AppTimeData data in controller.businessData.timeData!) ...[
          Container(
            padding: EdgeInsets.symmetric(
                vertical:
                MediaQuery.of(context).size.height * 0.01,
                horizontal:
                MediaQuery.of(context).size.width * 0.05),
            decoration: BoxDecoration(
//                          border: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.5)))
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                AutoSizeText(
                  data.day,
                  style: TextStyle(
                      color: Color(0xff35A2AB), fontSize: 16),
                ),
                data.status!
                    ? Row(
                  children: [
                    AutoSizeText(
                      DateFormat.jm().format(DateTime(
                          now.year,
                          now.month,
                          now.day,
                          data.startTime.hour,
                          data.startTime.minute)),
                      style:
                      TextStyle(color: Colors.grey),
                    ),
                    Text(" - "),
                    AutoSizeText(
                      DateFormat.jm().format(DateTime(
                          now.year,
                          now.month,
                          now.day,
                          data.endTime.hour,
                          data.endTime.minute)),
                      style:
                      TextStyle(color: Colors.grey),
                    ),
                  ],
                )
                    : AutoSizeText(
                  "Closed",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
          ),
        ],
        SizedBox(height: Get.height*0.02,),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  try {
                    print(controller.businessData.countryCode);
                    Get.find<LocalStorageService>().launchURL(
                        'tel:${controller.businessData.countryCode ?? ""}${controller.businessData.phoneNumber}');
                  } catch (e) {
                    Show.showErrorSnackBar("Error", "$e");
                  }
                },
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.secondary.withOpacity(0.3)),
                        child: SvgPicture.asset("assets/call.svg",color: theme.primaryColor,)),
                    SizedBox(
                      height: 5,
                    ),
                    AutoSizeText("Call")
                  ],
                ),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  try {
                    Get.find<LocalStorageService>().launchURL(
                        'https://www.google.com/maps/search/?api=1&query=${controller.businessData.location?.latitude},${controller.businessData.location?.longitude}');
                  } catch (e) {
                    Show.showErrorSnackBar("Error", "$e");
                  }
                },
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.secondary.withOpacity(0.3)),
                        child: SvgPicture.asset("assets/location.svg",color: theme.primaryColor)),
                    SizedBox(
                      height: 5,
                    ),
                    AutoSizeText("Location")
                  ],
                ),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  try {
                    Get.find<LocalStorageService>().launchURL(
                        controller.businessData.websiteLink!.contains("http")
                            ? controller.businessData.websiteLink!
                            : "https://${controller.businessData.websiteLink}");
                  } catch (e) {
                    Show.showErrorSnackBar("Error", "$e");
                  }
                },
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.secondary.withOpacity(0.3)),
                        child: SvgPicture.asset("assets/website.svg",color: theme.primaryColor)),
                    SizedBox(
                      height: 5,
                    ),
                    AutoSizeText("Website")
                  ],
                ),
              )),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  Get.to(() => MoreInfoView(business: controller.businessData));
                },
                child: Column(
                  children: [
                    Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.colorScheme.secondary.withOpacity(0.3)),
                        child: Icon(Icons.info_outline,color: theme.primaryColor)),
                    SizedBox(
                      height: 5,
                    ),
                    AutoSizeText("More info")
                  ],
                ),
              ))
            ],
          ),
        ),
        SizedBox(
          height: Get.height * 0.03,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: AutoSizeText(
            "Description",
            style: TextStyles.h1,
          ),
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: AutoSizeText(controller.businessData.history ?? ""),
        ),
        SizedBox(
          height: Get.height * 0.03,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: AutoSizeText(
            "Social Media",
            style: TextStyles.h1,
          ),
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Row(
            children: [
              for (SocialMediaData mediaData
                  in controller.businessData.socialData!)
                Expanded(
                    child: GestureDetector(
                  onTap: () {
                    try {
                      if (mediaData.url != null) {
                        Get.find<FireBaseDatabaseService>().addSocialClick(
                            controller.businessData.id!, DateTime.now());
                        Get.find<LocalStorageService>().launchURL(
                            mediaData.url!.contains("http")
                                ? mediaData.url!
                                : "https://${mediaData.url}");
                      }
                    } catch (e) {
                      Show.showErrorSnackBar("Error", "$e");
                    }
                  },
                  child: Center(
                    child: SizedBox(
                      width: Get.width * 0.1,
                      height: Get.width * 0.1,
                      child: Center(
                        child: Image.asset(
                          mediaData.icon!,
                        ),
                      ),
                    ),
                  ),
                ))
            ],
          ),
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: AutoSizeText(
            "Business Info",
            style: TextStyles.h1,
          ),
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: ListTile(
            onTap: () {
              try {
                Get.find<LocalStorageService>().launchURL(
                    'tel:${controller.businessData.countryCode ?? ""}${controller.businessData.phoneNumber}');
              } catch (e) {
                Show.showErrorSnackBar("Error", "$e");
              }
            },
            title: AutoSizeText(
                "Call ${controller.businessData.countryCode ?? ""}${controller.businessData.phoneNumber}"),
            contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            trailing: SvgPicture.asset("assets/call.svg",color: theme.primaryColor,),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: ListTile(
            onTap: () {
              try {
                Get.find<LocalStorageService>().launchURL(
                    controller.businessData.websiteLink!.contains("http")
                        ? controller.businessData.websiteLink!
                        : "https://${controller.businessData.websiteLink}");
              } catch (e) {
                Show.showErrorSnackBar("Error", "$e");
              }
            },
            title: AutoSizeText("${controller.businessData.websiteLink ?? ""}"),
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            trailing: SvgPicture.asset("assets/website.svg",color: theme.primaryColor,),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: ListTile(
            onTap: () {
              try {
                Get.find<LocalStorageService>().launchURL(
                    'https://www.google.com/maps/search/?api=1&query=${controller.businessData.location?.latitude},${controller.businessData.location?.longitude}');
              } catch (e) {
                Show.showErrorSnackBar("Error", "$e");
              }
            },
            title: AutoSizeText("${controller.businessData.location!.name}"),
            contentPadding: EdgeInsets.symmetric(horizontal: 0),
            trailing: SvgPicture.asset("assets/location.svg",color: theme.primaryColor,),
          ),
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        controller.businessData.tags!.length==0?SizedBox():Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: AutoSizeText(
            "Business Tags",
            style: TextStyles.h1,
          ),
        ),
        SizedBox(
          height: controller.businessData.tags!.length==0?0:Get.height * 0.02,
        ),
        controller.businessData.tags!.length==0?SizedBox():Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Wrap(children: [
            for(String tag in controller.businessData.tags!)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal:2.0),
                child: Chip(label: AutoSizeText(tag,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w600),),backgroundColor: Theme.of(context).primaryColor),
              )
          ],),
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        controller.user.id == null
            ? SizedBox()
            : controller.isOwner
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                    child: AutoSizeText(
                      "Share Business",
                      style: TextStyles.h1,
                    ),
                  ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        controller.user.id == null
            ? SizedBox()
            : controller.isOwner
                ? SizedBox()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
                    child: Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: () {
                            Get.to(() => SingleChatView(),
                                binding: BindingsBuilder(() {
                              Get.put(SingleChatController(true,
                                  businessData: controller.businessData));
                            }));
                          },
                          child: Column(
                            children: [
                              Icon(Icons.forum_outlined),
                              SizedBox(
                                height: 3,
                              ),
                              AutoSizeText("Message")
                            ],
                          ),
                        )),
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            String url = await Get.find<LocalStorageService>()
                                .createBusinessLink(
                                    controller.businessData.id!);
                            Share.share(url);
                          },
                          child: Column(
                            children: [
                              Icon(Icons.share_outlined),
                              SizedBox(
                                height: 3,
                              ),
                              AutoSizeText("Share")
                            ],
                          ),
                        )),
                        Expanded(
                            child: GestureDetector(
                          onTap: () async {
                            Show.showLoader();
                            String url = await Get.find<LocalStorageService>()
                                .createBusinessLink(
                                    controller.businessData.id!);
                            if (Get.isOverlaysOpen) {
                              Get.back();
                            }
                            Clipboard.setData(ClipboardData(text: url));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Link Copied!')),
                            );
                          },
                          child: Column(
                            children: [
                              Icon(Icons.copy),
                              SizedBox(
                                height: 3,
                              ),
                              AutoSizeText("Copy Link")
                            ],
                          ),
                        ))
                      ],
                    ),
                  ),
        SizedBox(
          height: Get.height * 0.05,
        ),
      ],
    );
  }
}

class _StatisticsView extends GetView<BusinessDetailController> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        SizedBox(
          height: Get.height * 0.02,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.05),
          child: Row(
            children: [
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  controller.setGraphData();
                  controller.changeLinkView(false);
                },
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      color:
                          controller.showLinkView ? null : theme.primaryColor,
                      borderRadius: BorderRadius.circular(5)),
                  duration: Duration(milliseconds: 500),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: Get.height * 0.02),
                          child: SvgPicture.asset(
                            "assets/space.svg",
                            color: controller.showLinkView
                                ? Colors.grey[400]
                                : Colors.white,
                          ),
                        ),
                        AutoSizeText(
                          "Listing Views",
                          style: TextStyles.title1.copyWith(
                            color: controller.showLinkView
                                ? Colors.grey[400]
                                : Colors.white,
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        )
                      ],
                    ),
                  ),
                ),
              )),
              SizedBox(
                width: Get.width * 0.05,
              ),
              Expanded(
                  child: GestureDetector(
                onTap: () {
                  controller.changeLinkView(true);
                },
                child: AnimatedContainer(
                  decoration: BoxDecoration(
                      color:
                          controller.showLinkView ? theme.primaryColor : null,
                      borderRadius: BorderRadius.circular(5)),
                  duration: Duration(milliseconds: 500),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: Get.width * 0.03),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: Get.height * 0.02),
                          child: SvgPicture.asset(
                            "assets/laptop.svg",
                            color: controller.showLinkView
                                ? Colors.white
                                : Colors.grey[400],
                          ),
                        ),
                        AutoSizeText(
                          "Link Clicks",
                          style: TextStyles.title1.copyWith(
                            color: controller.showLinkView
                                ? Colors.white
                                : Colors.grey[400],
                          ),
                        ),
                        SizedBox(
                          height: Get.height * 0.02,
                        )
                      ],
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
        SizedBox(
          height: Get.height * 0.02,
        ),
        IndexedStack(
          index: controller.showLinkView ? 0 : 1,
          children: [_LinkClickView(), _ListingGraphView()],
        )
      ],
    );
  }
}

class _LinkClickView extends GetView<BusinessDetailController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05, vertical: Get.width * 0.05),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "Links Clicks",
                      style: TextStyles.h2,
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    AutoSizeText("${DateFormat.MMMd().format(controller.graphFirstDate!)} - ${DateFormat.MMMd().format(DateTime.now())}")
                  ],
                ),
              ),
              DropdownButtonHideUnderline(
                  child: DropdownButton(
                items: ["Last Week", "Last Month"]
                    .map((e) => DropdownMenuItem(
                          child: AutoSizeText(
                            e,
                            style: TextStyle(color: Colors.blue),
                          ),
                          value: e,
                        ))
                    .toList(),
                style: TextStyle(color: Colors.blue),
                value: controller.graphDateType,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.blue,
                ),
                onChanged: controller.changeGraphDateType,
              ))
            ],
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Row(
            children: [
              AutoSizeText(
                "${controller.totalSocialClicks}",
                style: TextStyles.h1
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AutoSizeText(
                      "Views of your business social links in the last selected period."),
                ),
              ),
              // Row(
              //   children: [
              //     Container(
              //       padding: EdgeInsets.all(5),
              //       decoration: BoxDecoration(
              //           color: Colors.green, shape: BoxShape.circle),
              //       child: Icon(
              //         Icons.arrow_upward,
              //         size: 15,
              //       ),
              //     ),
              //     SizedBox(
              //       width: 5,
              //     ),
              //     AutoSizeText(
              //       "33.4%",
              //       style: TextStyles.body1.copyWith(color: Colors.green),
              //     )
              //   ],
              // )
            ],
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Container(
            child: Container(
              child: Echarts(
                option: '''
    {
    dataset: {
                    dimensions: ['time', 'socials'],
                    source: ${jsonEncode(controller.graphData)},
                  },
    grid: {
                        left: '0%',
                        right: '0%',
                        bottom: '5%',
                        top: '7%',
                        height: '85%',
                        containLabel: true,
                        z: 22,
                      },
                      xAxis: {
   
    data: ${jsonEncode(controller.graphData.map((e) => e['time']).toList())}
  },
      yAxis: {
        type: 'value'
      },
      series: [{
        type: 'line',
        smooth: true
      }]
    }
  ''',
              ),
              width: 300,
              height: 250,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListingGraphView extends GetView<BusinessDetailController> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: Get.width * 0.05, vertical: Get.width * 0.05),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      "Listing View",
                      style: TextStyles.h2,
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    AutoSizeText("${DateFormat.MMMd().format(controller.graphFirstDate!)} - ${DateFormat.MMMd().format(DateTime.now())}")
                  ],
                ),
              ),
              DropdownButtonHideUnderline(
                  child: DropdownButton(
                items: ["Last Week", "Last Month"]
                    .map((e) => DropdownMenuItem(
                          child: AutoSizeText(
                            e,
                            style: TextStyle(color: Colors.blue),
                          ),
                          value: e,
                        ))
                    .toList(),
                style: TextStyle(color: Colors.blue),
                value: controller.graphDateType,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.blue,
                ),
                    onChanged: controller.changeGraphDateType,
              ))
            ],
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Row(
            children: [
              AutoSizeText(
                "${controller.totalClicks}",
                style: TextStyles.h1
                    .copyWith(color: Theme.of(context).primaryColor),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: AutoSizeText(
                      "Views of your business listing in the last selected period."),
                ),
              ),
              // Row(
              //   children: [
              //     Container(
              //       padding: EdgeInsets.all(5),
              //       decoration: BoxDecoration(
              //           color: Colors.green, shape: BoxShape.circle),
              //       child: Icon(
              //         Icons.arrow_upward,
              //         size: 15,
              //       ),
              //     ),
              //     SizedBox(
              //       width: 5,
              //     ),
              //     AutoSizeText(
              //       "33.4%",
              //       style: TextStyles.body1.copyWith(color: Colors.green),
              //     )
              //   ],
              // )
            ],
          ),
          SizedBox(
            height: Get.height * 0.02,
          ),
          Container(
            child: Container(
              child: Echarts(
                option: '''
    {
    dataset: {
                    dimensions: ['time', 'clicks'],
                    source: ${jsonEncode(controller.graphData)},
                  },
    grid: {
                        left: '0%',
                        right: '0%',
                        bottom: '5%',
                        top: '7%',
                        height: '85%',
                        containLabel: true,
                        z: 22,
                      },
                      xAxis: {
   
    data: ${jsonEncode(controller.graphData.map((e) => e['time']).toList())}
  },
      yAxis: {
        type: 'value'
      },
      series: [{
        type: 'line',
        smooth: true
      }]
    }
  ''',
              ),
              width: 300,
              height: 250,
            ),
          ),
        ],
      ),
    );
  }
}

const darkThemeScript = r'''
(function (root, factory) {
    if (typeof define === 'function' && define.amd) {
        // AMD. Register as an anonymous module.
        define(['exports', 'echarts'], factory);
    } else if (typeof exports === 'object' && typeof exports.nodeName !== 'string') {
        // CommonJS
        factory(exports, require('echarts'));
    } else {
        // Browser globals
        factory({}, root.echarts);
    }
}(this, function (exports, echarts) {
    var log = function (msg) {
        if (typeof console !== 'undefined') {
            console && console.error && console.error(msg);
        }
    };
    if (!echarts) {
        log('ECharts is not Loaded');
        return;
    }
    var contrastColor = '#eee';
    var axisCommon = function () {
        return {
            axisLine: {
                lineStyle: {
                    color: contrastColor
                }
            },
            axisTick: {
                lineStyle: {
                    color: contrastColor
                }
            },
            axisLabel: {
                textStyle: {
                    color: contrastColor
                }
            },
            splitLine: {
                lineStyle: {
                    type: 'dashed',
                    color: '#aaa'
                }
            },
            splitArea: {
                areaStyle: {
                    color: contrastColor
                }
            }
        };
    };
    var colorPalette = ['#dd6b66','#759aa0','#e69d87','#8dc1a9','#ea7e53','#eedd78','#73a373','#73b9bc','#7289ab', '#91ca8c','#f49f42'];
    var theme = {
        color: colorPalette,
        backgroundColor: '#333',
        tooltip: {
            axisPointer: {
                lineStyle: {
                    color: contrastColor
                },
                crossStyle: {
                    color: contrastColor
                }
            }
        },
        legend: {
            textStyle: {
                color: contrastColor
            }
        },
        textStyle: {
            color: contrastColor
        },
        title: {
            textStyle: {
                color: contrastColor
            }
        },
        toolbox: {
            iconStyle: {
                normal: {
                    borderColor: contrastColor
                }
            }
        },
        dataZoom: {
            textStyle: {
                color: contrastColor
            }
        },
        timeline: {
            lineStyle: {
                color: contrastColor
            },
            itemStyle: {
                normal: {
                    color: colorPalette[1]
                }
            },
            label: {
                normal: {
                    textStyle: {
                        color: contrastColor
                    }
                }
            },
            controlStyle: {
                normal: {
                    color: contrastColor,
                    borderColor: contrastColor
                }
            }
        },
        timeAxis: axisCommon(),
        logAxis: axisCommon(),
        valueAxis: axisCommon(),
        categoryAxis: axisCommon(),
        line: {
            symbol: 'circle'
        },
        graph: {
            color: colorPalette
        },
        gauge: {
            title: {
                textStyle: {
                    color: contrastColor
                }
            }
        },
        candlestick: {
            itemStyle: {
                normal: {
                    color: '#FD1050',
                    color0: '#0CF49B',
                    borderColor: '#FD1050',
                    borderColor0: '#0CF49B'
                }
            }
        }
    };
    theme.categoryAxis.splitLine.show = false;
    echarts.registerTheme('dark', theme);
}));
''';

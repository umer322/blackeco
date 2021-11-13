
import 'package:blackeco/models/location.dart';
import 'package:blackeco/models/review.dart';
import 'package:blackeco/models/social_media_data.dart';
import 'day_time_picker.dart';

class BusinessData{
  String? id;
  String? ownerId;
  String? name;
  String? category;
  String? coverImage;
  String? websiteLink;
  String? phoneNumber;
  String? countryCode;
  DateTime? date;
  String? history;
  List<AppTimeData>? timeData;
  bool? status;
  LocationModel? location;
  List<String>? images;
  List<String>? menuImages;
  List<SocialMediaData>? socialData;
  List<String>? favorites=[];
  String? shareUrl;
  double? rating;
  List<ReviewModel>? reviews=[];
  List<String>? tags;
  int? linkClicks;
  int? pageViews;

  BusinessData({this.shareUrl,this.phoneNumber,this.countryCode,this.location,this.history,this.date,this.name,this.menuImages,this.status,this.id,this.images,this.reviews,this.coverImage,this.category,this.favorites,this.linkClicks,this.ownerId,this.pageViews,this.rating,this.socialData,this.tags,this.timeData,this.websiteLink});

  BusinessData.fromJson(Map<String,dynamic> data,String id):
        id=id,
        ownerId=data['owner_id'],
        name=data['name'],
        category=data['category'],
        coverImage=data['cover_image'],
        websiteLink=data['website'],
        shareUrl=data['share_url'],
        history=data['history'],
        countryCode=data['country_code'],
        location=LocationModel.fromJson(data['location']),
        date=DateTime.parse(data['date']),
        phoneNumber=data['phone'],
        menuImages=getImageList(data['menu_images']),
        status=data['status']??false,
        timeData=getTimeList(data['business_time']),
        images=getImageList(data['images']),
        favorites=getFavoriteList(data['favorites']??[]),
        reviews=getReviewsList(List<Map>.from(data['reviews']??[])),
        rating=getRating(List<Map>.from(data['reviews']??[])),
        linkClicks=data['link_clicks']??0,
        tags=getTagList(data['tags']??[]),
        pageViews=data['page_views']??0,
        socialData=getSocialData(data['social']);

  static List<String> getTagList(List data){
    return List<String>.from(data);
  }
  static List<ReviewModel> getReviewsList(List<Map> data){
    return data.map((e)=> ReviewModel.fromJson(e)).toList();
  }

  static double getRating(List data){
    double rating=0;

    data.forEach((element) {
      rating+=element['rating'];
    });
    if(data.length>0){
      rating=(rating/(data.length*5))*5;
    }
    return rating;
  }
  static List<SocialMediaData> getSocialData(List data){
    return data.map((e) => SocialMediaData.fromJson(e)).toList();
  }
  
  static List<String> getImageList(List data){
    return data.map((e)=>e.toString()).toList();
  }
  static getFavoriteList(List data){
    return data.map((e) => e.toString()).toList();
  }
  static getTimeList(List data){
    return data.map((e)=>AppTimeData.fromJson(e)).toList();
  }

  toMap(){
    return {
      "name":name,
      "category":category,
      "website":websiteLink,
      "owner_id":ownerId,
      "date":date?.toIso8601String(),
      "phone":phoneNumber,
      "rating":rating??0,
      "cover_image":coverImage,
      "favorites":favorites??[],
      "link_clicks":linkClicks,
      "status":status,
      'country_code':countryCode,
      "history":history,
      'share_url':shareUrl,
      "location":location?.toMap(),
      "menu_images":menuImages,
      "images":images,
      "page_views":pageViews,
      "tags":tags,
      "reviews":reviews?.map((e) => e.toMap()).toList()??[],
      "social":socialData?.map((e) => e.toMap()).toList(),
      "business_time":timeData?.map((e) => e.toMap()).toList()
    };
  }
}
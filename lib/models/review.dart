class ReviewModel{
  String? id;
  String? businessId;
  String? userId;
  double? rating;
  List<String>? photos;
  String? message;
  DateTime? time;
  int? likes;
  ReviewModel({this.message,this.rating,this.id,this.userId,this.photos,this.businessId,this.likes});

  ReviewModel.fromJson(Map data):
      id=data['id'],
      time=DateTime.parse(data['time']),
      likes=data['likes']??0,
      businessId=data['business_id'],
      userId=data['user_id'],
      rating=double.parse(data['rating']?.toString()??"0"),
      photos=getPhotos(data['photos']??[]),
      message=data['message'];

   static getPhotos(List data){
    return data.map((e) => e.toString()).toList();
  }

  toMap(){
     return {
       "id":id,
       "time":time?.toIso8601String(),
      "business_id":businessId,
       "user_id":userId,
       "likes":likes??0,
       "rating":rating,
       "photos":photos,
       "message":message
     };
  }
}
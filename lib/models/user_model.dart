import 'package:blackeco/models/location.dart';

class UserModel{
  String? id;
  String? chatToken;
  String? name;
  String? email;
  String? phoneNumber;
  String? countryCode;
  String? imageUrl;
  LocationModel? location;
  String? chattingWith;
  bool? emailNotifications;
  bool? pushNotifications;
  List<String>? favorites;
  UserModel({this.id,this.chatToken,this.chattingWith,this.favorites,this.emailNotifications,this.pushNotifications,this.name,this.phoneNumber,this.location,this.email,this.countryCode,this.imageUrl});
  UserModel.fromJson(Map data,String id):
        id=id,
        name=data['name'],
        email=data['email'],
        chatToken=data['chat_token'],
        chattingWith=data['chatting_with'],
        phoneNumber=data['phone_number'],
        imageUrl=data['image_url'],
        pushNotifications=data['push_notifications']??false,
        emailNotifications=data['email_notifications']??false,
        favorites=List<String>.from(data['favorites']??[]),
        location=data['location']!=null?LocationModel.fromJson(data['location']):null,
        countryCode=data['country_code'];

  toMap(){
    return {
      "name":name,
      'phone_number':phoneNumber,
      'email':email,
      'push_notifications':pushNotifications??false,
      'email_notifications':emailNotifications??false,
      'chatting_with':chattingWith,
      "location":location?.toMap(),
      'image_url':imageUrl,
      'chat_token':chatToken,
      'favorites':favorites??[],
      'country_code':countryCode
    };
  }
}
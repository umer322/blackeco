import 'package:blackeco/models/location.dart';

class UserModel{
  String? id;
  String? name;
  String? email;
  String? phoneNumber;
  String? countryCode;
  String? imageUrl;
  LocationModel? location;
  String? chattingWith;
  UserModel({this.id,this.chattingWith,this.name,this.phoneNumber,this.location,this.email,this.countryCode,this.imageUrl});
  UserModel.fromJson(Map data,String id):
        id=id,
        name=data['name'],
        email=data['email'],
        chattingWith=data['chatting_with'],
        phoneNumber=data['phone_number'],
        imageUrl=data['image_url'],
        location=data['location']!=null?LocationModel.fromJson(data['location']):null,
        countryCode=data['country_code'];

  toMap(){
    return {
      "name":name,
      'phone_number':phoneNumber,
      'email':email,
      'chatting_with':chattingWith,
      "location":location?.toMap(),
      'image_url':imageUrl,
      'country_code':countryCode
    };
  }
}
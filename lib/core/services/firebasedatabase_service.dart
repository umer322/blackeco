

import 'package:blackeco/models/timeseries_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

class FireBaseDatabaseService extends GetxService{

  final DatabaseReference _database=FirebaseDatabase.instance.reference();


  addClick(String businessId,DateTime time){
    try{
      _database.child("listings").child(businessId).child("${time.year}-${time.month.toString().length==1?"0${time.month}":time.month}-${time.day.toString().length==1?"0${time.day}":time.day}").child("clicks").set(ServerValue.increment(1));
    }
    catch(e){
      print(e);
      rethrow;
    }
  }

  addSocialClick(String businessId,DateTime time){
    try{
      _database.child("listings").child(businessId).child("${time.year}-${time.month.toString().length==1?"0${time.month}":time.month}-${time.day.toString().length==1?"0${time.day}":time.day}").child("socials").set(ServerValue.increment(1));
    }
    catch(e){
      print(e);
      rethrow;
    }
  }

   Future<List<TimeSeriesModel>> getAllClicks(String businessId)async{
    List<TimeSeriesModel> data=[];
    try{
      DataSnapshot? snapshot=await _database.child("listings").child(businessId).get();
      if(snapshot!=null){
        if(snapshot.value!=null){
          Map newData=Map.from(snapshot.value);
          newData.forEach((key,value) {
            value['time']=key+" 00:00:00";
            data.add(TimeSeriesModel.fromJson(value));
          });
        }
      }
      return data;
    }
    catch(e){
      rethrow;
    }
  }

}
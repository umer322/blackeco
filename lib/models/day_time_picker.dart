import 'package:flutter/material.dart';

class AppTimeData{
  final String day;
  TimeOfDay startTime;
  TimeOfDay endTime;
  bool? status;
  int place;
  AppTimeData(this.day,this.startTime,this.endTime,this.place,this.status);
  AppTimeData.fromJson(Map<String,dynamic> data):
      day=data['day'],
      startTime=TimeOfDay(hour: data['start_time_hour'], minute: data['start_time_minute']),
      endTime=TimeOfDay(hour: data['end_time_hour'], minute: data['end_time_minute']),
      status=data['status']??true,
      place=data['place'];
  toMap(){
    return {
      "day":day,
      "start_time_hour":startTime.hour,
      "start_time_minute":startTime.minute,
      "end_time_hour":endTime.hour,
      "end_time_minute":endTime.minute,
      "status":status,
      "place":place
    };
  }
  static List<AppTimeData> timeList =[
    AppTimeData("Monday",TimeOfDay(hour: 9,minute:0 ),TimeOfDay(hour: 23, minute: 0),0,true),
    AppTimeData("Tuesday",TimeOfDay(hour: 9,minute:0 ),TimeOfDay(hour: 23, minute: 0),1,true),
    AppTimeData("Wednesday",TimeOfDay(hour: 9,minute:0 ),TimeOfDay(hour: 23, minute: 0),2,true),
    AppTimeData("Thursday",TimeOfDay(hour: 9,minute:0 ),TimeOfDay(hour: 23, minute: 0),3,true),
    AppTimeData("Friday",TimeOfDay(hour: 9,minute:0 ),TimeOfDay(hour: 23, minute: 0),4,true),
    AppTimeData("Saturday",TimeOfDay(hour: 9,minute:0 ),TimeOfDay(hour: 23, minute: 0),5,true),
    AppTimeData("Sunday",TimeOfDay(hour: 9,minute:0 ),TimeOfDay(hour: 23, minute: 0),6,true)
  ];
}
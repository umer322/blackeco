class TimeSeriesModel {
  DateTime? time;
  int? clicks;
  int? socialClicks;
  TimeSeriesModel({this.time,this.clicks,this.socialClicks});

  TimeSeriesModel.fromJson(Map data):
      time=data['time']!=null?DateTime.parse(data['time']):null,
      socialClicks=data['socials']??0,
      clicks=data['clicks']??0;
}

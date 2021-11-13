class ReportMessageModel{
  String? id;
  bool? fromAdmin;
  DateTime? time;
  String? message;
  String? fileUrl;
  bool? isLoading;
  ReportMessageModel({this.time,this.message,this.fileUrl,this.fromAdmin,this.isLoading});

  ReportMessageModel.fromJson(Map data,String id):
      id=data['id'],
      fromAdmin=data['from_admin'],
      time=data['time']!=null?DateTime.parse(data['time']):null,
      message=data['message'],
      fileUrl=data['file_url'],
      isLoading=data['is_loading'];

  toMap(){
    return {
      "from_admin":fromAdmin,
      "time":time.toString(),
      "message":message,
      "file_url":fileUrl,
      "is_loading":isLoading
    };
  }
}
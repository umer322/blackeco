
class Message{
  String? id;
  String? message;
  String? senderId;
  DateTime? time;
  Message({this.message,this.time,this.id,this.senderId});
  Message.fromJson(Map data,String id):
      id=id,
      message=data['message'],
      senderId=data['sender_id'],
      time=DateTime.parse(data['time']);

  toMap(){
    return {
      "message":message,
      "sender_id":senderId,
      "time":time?.toString()
    };
  }
}
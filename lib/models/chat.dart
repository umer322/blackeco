 class ChatModel{
  String? id;
  DateTime? lastUpdated;
  String? lastMessage;
  String? lastMessageUser;
  int? unreadMessagesForUser1;
  String? businessOwnerId;
  bool? forBusiness;
  String? businessId;
  Map? ids;
  int? unreadMessagesForUser2;
  ChatModel({this.ids,this.businessId,this.businessOwnerId,this.forBusiness,this.id,this.lastMessage,this.lastMessageUser,this.lastUpdated,this.unreadMessagesForUser1,this.unreadMessagesForUser2});
  ChatModel.fromJson(Map data,String id):
      id=id,
      lastUpdated=DateTime.parse(data['last_updated']),
      forBusiness=data['for_business'],
      businessOwnerId=data['business_owner_id'],
      businessId=data['business_id'],
      ids=data['ids'],
      lastMessage=data['last_message'],
      lastMessageUser=data['last_message_user'],
      unreadMessagesForUser1=data['last_unread_1'],
      unreadMessagesForUser2=data['last_unread_2'];
  toMap(){
    return {
      "id":id,
      "last_updated":lastUpdated?.toString(),
      "business_id":businessId,
      "for_business":forBusiness,
      "ids":ids,
      "last_message":lastMessage,
      "business_owner_id":businessOwnerId,
      "last_message_user":lastMessageUser,
      "last_unread_1":unreadMessagesForUser1,
      "last_unread_2":unreadMessagesForUser2
    };
  }
 }
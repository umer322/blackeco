class ReportModel{
  String? id;
  String? userId;
  String? contactEmail;
  String? userName;
  String? userPicture;
  String? issueType;
  int? reportStatus;
  int? businessAssigned;
  bool? closed;
  String? additionalNote;
  String? fileUrl;
  DateTime? date;
  bool? claimType;
  String? businessId;

  ReportModel({this.claimType,this.closed,this.businessAssigned,this.issueType,this.date,this.id,this.userId,this.additionalNote,this.contactEmail,this.fileUrl,this.reportStatus,this.userPicture,this.userName,this.businessId});
  ReportModel.fromJson(Map data,String id):
      id=id,
      userId=data['user_id'],
      userName=data['user_name'],
      userPicture=data['user_picture'],
      businessAssigned=data['business_assigned']??0,
      contactEmail=data['contact_email'],
      issueType=data['issue_type'],
      additionalNote=data['additional_note'],
      fileUrl=data['file_url'],
      date=data['date']!=null?DateTime.parse(data['date']):null,
      reportStatus=data['report_status'],
      closed=data['closed'],
      claimType=data['claim_type'],
      businessId=data['business_id'];

  toMap(){
    return {
      "user_id":userId,
      "contact_email":contactEmail,
      "issue_type":issueType,
      'user_name':userName,
      'user_picture':userPicture,
      "additional_note":additionalNote,
      'business_assigned':businessAssigned??0,
      "file_url":fileUrl,
      "date":date?.toString(),
      'report_status':reportStatus,
      'closed':closed,
      'claim_type':claimType,
      'business_id':businessId
    };
  }

  static List<String> reportProblemsIssues=['Login/Signup Issue','Business Complaint','Other Issue'];
  static List<String> allReportIssues=['All','Login/Signup Issue','Business Complaint','Claim Business','Other Issue'];
  static List<String> adminReportTypes=['All','Login/Signup Issue','Business Complaint','Other Issue'];

}


import 'package:blackeco/core/services/firebasestorage_service.dart';
import 'package:blackeco/models/business_data.dart';
import 'package:blackeco/models/chat.dart';
import 'package:blackeco/models/message.dart';
import 'package:blackeco/models/report_model.dart';
import 'package:blackeco/models/reportmessage_model.dart';
import 'package:blackeco/models/review.dart';
import 'package:blackeco/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FireStoreService extends GetxService {
  CollectionReference _userCollection = FirebaseFirestore.instance.collection("users");
  CollectionReference _businessCollection = FirebaseFirestore.instance.collection("businesses");
  CollectionReference _reportCollection = FirebaseFirestore.instance.collection("reports");
  CollectionReference _chatCollection = FirebaseFirestore.instance.collection("chats");
  Stream<DocumentSnapshot> fireStoreUserStream(String userId){
    return _userCollection.doc(userId).snapshots();
  }

  Stream<QuerySnapshot> businessesStream() {
    return _businessCollection.snapshots();
  }


  Future<UserModel?> getUser(String id)async{
    try{
      DocumentSnapshot snapshot=await _userCollection.doc(id).get();
      if(snapshot.exists){
        UserModel user=UserModel.fromJson(snapshot.data() as Map, snapshot.id);
        return user;
      }
    }
    catch(e){
      rethrow;
    }
  }

  Stream<QuerySnapshot> allReports(){
    return _reportCollection.snapshots();
  }


  Future saveUser(String id,UserModel user)async{
    try{
      _userCollection.doc(id).set(user.toMap());
    }
    catch(e){
      rethrow;
    }
  }

  Future updateUser(String id,Map user)async{
    try{
      await _userCollection.doc(id).update(Map.from(user));
    }
    catch(e){
      rethrow;
    }
  }

  addReview(String businessId,ReviewModel review)async{
    try{
      DocumentReference documentReference = _businessCollection
          .doc(businessId);
      FirebaseFirestore.instance.runTransaction((transaction)async{
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          throw Exception("Business does not exist!");
        }
        transaction.update(documentReference, {'reviews':FieldValue.arrayUnion([review.toMap()])});
      });
    }
    catch(e){
      rethrow;
    }
  }

  addToFavorite(String businessId,String userID){
    try{
      DocumentReference documentReference = _businessCollection
          .doc(businessId);
      FirebaseFirestore.instance.runTransaction((transaction)async{
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          throw Exception("Business does not exist!");
        }
        transaction.update(documentReference, {'favorites':FieldValue.arrayUnion([userID])});
      });
    }
    catch(e){
      rethrow;
    }
  }

  removeFromFavorite(String businessId,String userID){
    try{
      DocumentReference documentReference = _businessCollection
          .doc(businessId);
      FirebaseFirestore.instance.runTransaction((transaction)async{
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          throw Exception("Business does not exist!");
        }
        transaction.update(documentReference, {'favorites':FieldValue.arrayRemove([userID])});
      });
    }
    catch(e){
      rethrow;
    }
  }

  Future saveBusiness(BusinessData data)async{
    try{
      await _businessCollection.add(data.toMap());
    }
    catch(e){
      rethrow;
    }
  }

  updateBusinessId(String id,Map<String,dynamic> data)async{
    try{
      await _businessCollection.doc(id).update(data);
    }
    catch(e){
      rethrow;
    }
  }

  Future updateBusiness(BusinessData data)async{
    try{
      await _businessCollection.doc(data.id).update(data.toMap());
    }
    catch(e){
      rethrow;
    }
  }

  Stream<QuerySnapshot> reportsStream(String id){
    return _reportCollection.where("user_id",isEqualTo: id).snapshots();
  }

  sendReport(ReportModel report)async{
    try{
      if(report.fileUrl!=null){
        String? file=await Get.find<FireBaseStorageService>().uploadImage(report.fileUrl!);
        report.fileUrl=file;
      }
      DocumentReference reference=await _reportCollection.add(report.toMap());
      return reference.id;
    }
    catch(e){
      rethrow;
    }
  }

  saveMessage(ChatModel model,Message message)async{
    try{
      await _chatCollection.doc(model.id).collection("messages").add(message.toMap());
      DocumentReference documentReference = _chatCollection
          .doc(model.id);

      FirebaseFirestore.instance.runTransaction((transaction)async{
        DocumentSnapshot snapshot = await transaction.get(documentReference);

        if (!snapshot.exists) {
          transaction.set(documentReference, model.toMap());
        }
        transaction.update(documentReference, model.toMap());
      });

    }
    catch(e){
      rethrow;
    }
  }

  Stream<QuerySnapshot> getChatMessages(String id){
    return _chatCollection.doc(id).collection("messages").snapshots();
  }
  
  Stream<QuerySnapshot> getUserChats(String id){
    print(id);
    return _chatCollection.where("ids.$id",isEqualTo: true).snapshots();
  }

  updateReport(ReportModel report)async{
    try{
      await _reportCollection.doc(report.id).update(report.toMap());
    }
    catch(e){
      rethrow;
    }
  }

  Stream<QuerySnapshot> reportMessages(String id){
    return _reportCollection.doc(id).collection("messages").snapshots();
  }

  sendReportMessage(ReportMessageModel message,String reportId)async{
    try{
      await _reportCollection.doc(reportId).collection("messages").add(message.toMap());
    }
    catch(e){
      rethrow;
    }
  }

}
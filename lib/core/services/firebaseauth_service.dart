import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FireBaseAuthService extends GetxService {
  FirebaseAuth auth =FirebaseAuth.instance;
  bool get isLoggedIn =>auth.currentUser!=null;

  Stream<User?> fireBaseAuthUserStream(){
    return auth.authStateChanges();
  }

  Future login({@required String? email,@required String? password})async{
    try{
      await auth.signInWithEmailAndPassword(email: email!, password: password!);
    }
    catch(e){
      rethrow;
    }
  }

  Future signUp({@required String? email,@required String? password})async{
    try{
      await auth.createUserWithEmailAndPassword(email: email!, password: password!);
    }
    catch(e){
      rethrow;
    }
  }

  sendEmail(String email)async{
    try{
      await auth.sendPasswordResetEmail(email: email);
    }
    catch(e){
      rethrow;
    }
  }

}
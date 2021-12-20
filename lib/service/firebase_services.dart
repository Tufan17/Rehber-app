
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:kcproje/constants/const.dart';

import '../wrapper.dart';
User currentUser=FirebaseAuth.instance.currentUser;
FirebaseStorage storage =FirebaseStorage.instance;
class FirebaseService{
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;
  Future createUsers(String email,String phone,String name) async {
      await _firestore
          .collection("users")
          .doc(userUid)
          .set({
        "userPhotoUrl":"",
        "email":email,
        "id":userUid,
        "name":name,
        "phone":phone,
      });

  }Future addUsers(String url,String phone,String name,String email) async {
    var ref=_firestore.collection("users").doc(user["id"]).collection("directory");
    var idsi=ref.doc().id;
    ref.doc(idsi).set({
      "id":idsi,
      "userPhotoUrl":url,
      "name":name,
      "email":email,
      "phone":phone,
    });
  }

  Future delete(String id) async {
    await _firestore.collection("users").doc(userUid).collection("directory").doc(id).delete();
  }


}
Future users(String id,setState,bool _homepage) async{
  auth.authStateChanges().listen((event) async {
    if(event!=null){
      userUid=event.uid;
      var data=await FirebaseFirestore
          .instance
          .collection("users")
          .doc(event.uid)
          .get();
      user=data.data();
      if(_homepage){
       Future.delayed(Duration(seconds: 1),(){
         setState((){
           user;
         });
       });
      }
    }
  });
}
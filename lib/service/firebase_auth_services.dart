import 'package:firebase_auth/firebase_auth.dart';
import 'package:kcproje/constants/const.dart';
import 'package:kcproje/service/firebase_services.dart';
class FirebaseAuthService{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future createUser(String email,String password) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
    email: email,
    password: password,
  ).then((value){
    userUid=value.user.uid;
    });
  }
  Future<String> signIn(String email,String sifre) async {
    UserCredential values;
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: sifre,
    ).then((value) {
      values=value;
    });
    return values.user.uid;
  }
  Future<bool> signOuth() async {
    await _firebaseAuth.signOut();
    return _firebaseAuth.currentUser==null?true:false;
  }

}
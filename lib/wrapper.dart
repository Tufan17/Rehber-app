import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kcproje/View/home_page_view.dart';
import 'View/auth_view.dart';
FirebaseAuth auth = FirebaseAuth.instance;

class Wrapper extends StatefulWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool look;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listen();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {
    if(look==true) {
      return HomePage();
    } else if(look==false) {
      return AuthView();
    } else {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  void listen() {
    auth.authStateChanges().listen((event) {
      if(event!=null){
        setState(() {
          look=true;
        });
      }else{
        setState(() {
          look=false;
        });
      }
    });
  }
}

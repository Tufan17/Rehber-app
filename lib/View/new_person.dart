
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kcproje/constants/const.dart';
import 'package:kcproje/service/firebase_services.dart';

class NewPerson extends StatefulWidget {
  const NewPerson({Key key}) : super(key: key);

  @override
  _NewPersonState createState() => _NewPersonState();
}

class _NewPersonState extends State<NewPerson> {
  bool ok=false;
  PickedFile image = PickedFile("");
  TextEditingController controllerName=TextEditingController();
  TextEditingController controllerMail=TextEditingController();
  TextEditingController controllerPhone=TextEditingController();
  String photoUrl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Yeni Kişi"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {
            setState(() {
              ok=true;
            });
            Future.delayed(Duration(seconds: 1),(){
              FirebaseService()
                  .addUsers(photoUrl,
                  controllerPhone.text,
                  controllerName.text,
                  controllerMail.text).then((value){
                Navigator.pop(context);
              });
            });

          }, icon: Icon(Icons.save)),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () => addUserPhoto(context),
                  child:image.path.isEmpty
                      ?
                  Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(Icons.add_a_photo_outlined,size: 65,),
                    ),
                  )
                    : Center(
                      child: Container(
                      width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                            image:FileImage(File(image.path)),
                            fit: BoxFit.cover,
                          ),
                        ),
                       ),
                    ),
                              ),
              ),
              //isim
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: controllerName,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person_outlined,
                      color: Colors.black38,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelText: "İsim-Soyisim",
                    labelStyle: TextStyle(color: Colors.black38),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              //mail
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: controllerMail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.mail_outline,
                      color: Colors.black38,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelText: "E-mail",
                    labelStyle: TextStyle(color: Colors.black38),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
              //telefon
              Padding(
                padding: EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: controllerPhone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.black38,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    labelText: "Telefon",
                    labelStyle: TextStyle(color: Colors.black38),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),
            ],
          ),
         ok?Center(
            child: Icon(Icons.check,size: 150,color: Colors.green,),
          ):Container(),
        ],
      ),
    );
  }

  void addUserPhoto(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(Icons.photo_library),
                  title: Text('Galeriden seç'),
                  onTap: () {
                    imgFromGallery().then((value){
                      setState(() {
                      });
                    });
                    Navigator.of(context).pop();
                  }),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Kameradan çek'),
                onTap: () {
                  imgFromCamera().then((value){
                    setState(() {
                    });
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future imgFromCamera() async {
    image = (await ImagePicker()
        .getImage(source: ImageSource.camera, imageQuality: 50));
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('rehber/${user["id"]}/${user["id"]}');
    UploadTask uploadTask = firebaseStorageRef.putFile(File(image.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    photoUrl = (await taskSnapshot.ref.getDownloadURL());

  }

  Future imgFromGallery() async {
   image =(await ImagePicker()
       .getImage(source: ImageSource.gallery, imageQuality: 50));
   Reference firebaseStorageRef =
   FirebaseStorage.instance.ref().child('rehber/${user["id"]}/${user["id"]}');
   UploadTask uploadTask = firebaseStorageRef.putFile(File(image.path));
   TaskSnapshot taskSnapshot = await uploadTask;
   photoUrl = (await taskSnapshot.ref.getDownloadURL());
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kcproje/constants/const.dart';
import 'package:kcproje/service/firebase_auth_services.dart';
import 'package:kcproje/service/firebase_services.dart';
import '../wrapper.dart';
import 'auth_view.dart';
import 'new_person.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PickedFile image = PickedFile("");
  String photoUrl="";
  List<String> list=[];
  bool search=false;
  TextEditingController controllerSearch=TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    users(currentUser==null?userUid:currentUser.uid,setState,true);
  }
  @override
   Widget build(BuildContext context) {
    return user.isEmpty?Scaffold(
      body:Center(child: CircularProgressIndicator(),) ,
    ):
    Scaffold(
      drawer: Drawer(
        child: Container(
          color:Colors.blue,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              (photoUrl.isNotEmpty || user["userPhotoUrl"]!=null && user["userPhotoUrl"]!="")
                  ?Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      image:NetworkImage(
                          photoUrl==""?user["userPhotoUrl"]==""?"https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png":
                          user["userPhotoUrl"]:
                          photoUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ):Center(
              child: CircleAvatar(
                backgroundColor: Colors.white,
                maxRadius: 50,
                child: Icon(Icons.person,size: 70,color: Colors.black38,),
              ),
            ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Center(
                  child: Text(user["name"],style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>NewPerson()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0.1,
                          color: Colors.red,
                          offset: Offset(0.1,1.1),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Yeni numara ekle"),
                          Icon(Icons.add_call),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0.1,
                          color: Colors.red,
                          offset: Offset(0.1,1.1),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: ()=>changeUserPhoto(context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Profil fotoğrafını güncelle"),
                            Icon(Icons.add_a_photo_outlined),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  user.clear();
                  userUid="";
                  FirebaseAuthService().signOuth().then((value){
                     if(value){
                       Navigator.pushReplacement(
                           context,
                           MaterialPageRoute(builder: (context)=>Wrapper()));
                    }

                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 0.1,
                          color: Colors.red,
                          offset: Offset(0.1,1.1),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:Center(child: Text("Çıkış yap")),
                    ),
                  ),
                ),
              ),
          ],),
        ),
      ),
      appBar: AppBar(
        elevation: 2.8,
        centerTitle: true,
        backgroundColor: Colors.blue,
        shadowColor: Colors.red,
        title: search?
            TextField(
              controller: controllerSearch,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.black38,
                ),
              ),
              onChanged: (value){
                searcher(value);
              },
            )
            :Text("KC Rehber"),
        actions: [IconButton(onPressed: (){
          setState(() {
            search=!search;
          });
          },
          icon: Icon(Icons.search),
        )],
      ),
      body:search?
      ListView.builder(
        itemCount:list.length,
        itemBuilder: (BuildContext context,indext){
          return ListTile(
            title: Text(list[indext]),
          );
        },
      ):
      StreamBuilder(
        stream: FirebaseFirestore
            .instance
            .collection("users")
            .doc(user["id"])
            .collection("directory")
            .snapshots(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          list.clear();
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }else if(snapshot.hasError){
            return Center(child: Text("Error : "+snapshot.error.toString()),);
          }
          else if(snapshot.data.docs.isEmpty){
            return Center(child: Text("Henüz hiç kişi yok..."));
          }
          return ListView(
            children:snapshot.data.docs.map((doc){
              list.add(doc["name"]);
              return ListTile(
                onLongPress: (){
                  deleteUser(context,doc.id);
                },
                title: Text(doc["name"]),
                subtitle: Text(doc["phone"]+" - "+doc["email"]),
                leading:CircleAvatar(
                  backgroundImage: NetworkImage(doc["userPhotoUrl"]),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }

  void changeUserPhoto(context) {
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
                    imgFromGallery().whenComplete((){
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

  void deleteUser(context,String id) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text('Kullanıcı silinsin mi ?',style: TextStyle(
                  fontSize: 20
                ),)),
              ),
              ListTile(
                title: Text('Evet'),
                onTap: () {
                  FirebaseService().delete(id);
                  Navigator.of(context).pop();
                },
              ),ListTile(
                 title: Text('Hayır'),
                 onTap: () {
                   Navigator.of(context).pop();
                 }),

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
    FirebaseStorage.instance.ref().child('users/${user["id"]}');
    UploadTask uploadTask = firebaseStorageRef.putFile(File(image.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    photoUrl = (await taskSnapshot.ref.getDownloadURL());
    FirebaseFirestore.instance.collection("users").doc(user["id"]).update({"userPhotoUrl":photoUrl});
  }

  Future imgFromGallery() async {
    image =(await ImagePicker()
        .getImage(source: ImageSource.gallery, imageQuality: 50));
    Reference firebaseStorageRef =
    FirebaseStorage.instance.ref().child('users/${user["id"]}');
    UploadTask uploadTask = firebaseStorageRef.putFile(File(image.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    photoUrl = (await taskSnapshot.ref.getDownloadURL());
    FirebaseFirestore.instance.collection("users").doc(user["id"]).update({"userPhotoUrl":photoUrl});
  }

  void searcher(String value){
    List<String> eleman=[];
    for(int i=0;i<list.length;++i){
      eleman.add(list[i]);
    }
    if(value.isNotEmpty){
      List<String> listData=[];
      for (var item in eleman) {
        if(item.contains((value))==null)
        {
        }else{
          if(item.contains((value))){
            listData.add(item);
          }
        }

      }
      setState(() {
        list.clear();
        list.addAll(listData);
      });
      return;
    }
    else{
      setState(() {
        search=false;
      });
    }
  }

}

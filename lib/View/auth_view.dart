import 'package:flutter/material.dart';
import 'package:kcproje/View/home_page_view.dart';
import 'package:kcproje/constants/size.dart';
import 'package:kcproje/service/firebase_auth_services.dart';
import 'package:kcproje/service/firebase_services.dart';
class AuthView extends StatefulWidget {
  const AuthView({Key key}) : super(key: key);

  @override
  _AuthViewState createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  bool see = false;
  bool _obscureText = true;
  bool auth = true;
  bool ok=false;
  TextEditingController controllerGirisEmail = TextEditingController();
  TextEditingController controllerGirisSifre = TextEditingController();

  TextEditingController controllerKayitOlName = TextEditingController();
  TextEditingController controllerKayitOlEmail = TextEditingController();
  TextEditingController controllerKayitOlSifre1 = TextEditingController();
  TextEditingController controllerKayitOlSifre2 = TextEditingController();
  TextEditingController controllerKayitOlTelefon = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(
            height: auth?MediaQueryValues(context).height*0.2:MediaQueryValues(context).height*0.05,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0,),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        auth = !auth;
                      });
                    },
                    child: Text(
                      "Giriş",
                      style: TextStyle(
                        fontSize: auth ? 20 : 15,
                        color: auth ? Colors.deepOrange : Colors.blue,
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      setState(() {
                        auth = !auth;
                      });
                    },
                    child: Text(
                      "Kayıt Ol",
                      style: TextStyle(
                        fontSize: auth ? 15 : 20,
                        color: auth ? Colors.blue : Colors.deepOrange,
                      ),
                    )),
              ],
            ),
          ),
          if (auth)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: controllerGirisEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.person_outlined,
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
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: controllerGirisSifre,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          color: Colors.grey,
                          onPressed: () {
                            setState(() {
                              see = !see;
                              _obscureText = !_obscureText;
                            });
                          },
                          icon: Icon(
                            see == true
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: see == true
                                ? Colors.deepOrange
                                : Colors.black38,
                          ),
                        ),
                        prefixIcon: Icon(
                          Icons.lock_outline_rounded,
                          color: Colors.black38,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        labelText: "Şifreniz",
                        labelStyle: TextStyle(
                          color: Colors.black38,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          if (controllerGirisSifre.text.isNotEmpty &&
                              controllerGirisEmail.text.isNotEmpty) {
                            setState(() {
                              ok=true;
                            });
                            FirebaseAuthService().signIn(
                                controllerGirisEmail.text,
                                controllerGirisSifre.text).then((value) {
                              if (value !=null) {
                                users(value,setState,false);
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              }else{
                                setState(() {
                                  ok=false;
                                });
                              }
                            });
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, top: 5, bottom: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.blue,
                            ),
                            child: ok?CircularProgressIndicator(color: Colors.white,):Text(
                              "Giriş",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            )),
                      ),
                    ),
                  )
                ],
              ),
            )
          else
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: TextFormField(
                    controller: controllerKayitOlName,
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
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: controllerKayitOlEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.mail,
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
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: controllerKayitOlSifre1,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        onPressed: () {
                          setState(() {
                            see = !see;
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          see == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: see == true
                              ? Colors.deepOrange
                              : Colors.black38,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.black38,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: "Şifreniz",
                      labelStyle: TextStyle(
                        color: Colors.black38,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: controllerKayitOlSifre2,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        color: Colors.grey,
                        onPressed: () {
                          setState(() {
                            see = !see;
                            _obscureText = !_obscureText;
                          });
                        },
                        icon: Icon(
                          see == true
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: see == true
                              ? Colors.deepOrange
                              : Colors.black38,
                        ),
                      ),
                      prefixIcon: Icon(
                        Icons.lock_outline_rounded,
                        color: Colors.black38,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: "Şifrenizi Tekrar Giriniz",
                      labelStyle: TextStyle(
                        color: Colors.black38,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: controllerKayitOlTelefon,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.black38,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      labelText: "Telefon Numarası",
                      labelStyle: TextStyle(color: Colors.black38),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      if (controllerKayitOlSifre2.text ==
                              controllerKayitOlSifre1.text &&
                          controllerKayitOlEmail.text.isNotEmpty &&
                          controllerKayitOlName.text.isNotEmpty &&
                          controllerKayitOlTelefon.text.isNotEmpty) {
                        setState(() {
                          ok=true;
                        });
                        FirebaseAuthService()
                            .createUser(controllerKayitOlEmail.text,
                                controllerKayitOlSifre1.text).whenComplete((){
                                  FirebaseService().createUsers(
                                      controllerKayitOlEmail.text,
                                      controllerKayitOlTelefon.text,
                                      controllerKayitOlName.text).whenComplete((){
                                        Navigator.pushReplacement(context,
                                            MaterialPageRoute(builder: (context)=>HomePage()));
                                  });
                        });
                      } else {
                        setState(() {
                          ok=false;
                        });
                      }
                    },
                    child: Center(
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.blue,
                          ),
                          child: ok?CircularProgressIndicator(color: Colors.white,):Text(
                            "Kayıt ol",
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          )),
                    ),
                  ),
                )
              ],
            ),
        ],
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/homepage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_project/loginpage.dart';

class UserManagement{
  Widget handleAuth(){
    return new StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context,snapshot){
        if(snapshot.hasData){
          return HomePage();
        }
        return LoginPage();
      },);
  }
  // GET CURRENT USER
  Future getCurrentUser() async {
    return await FirebaseAuth.instance.currentUser();
  }
  Future<void> addData(postData,context) async{
    Firestore.instance.collection('/users').add(postData).then((value){
      print("save user");
     // Navigator.of(context).pop();
     // Navigator.of(context).pushReplacementNamed('/login');
    }).catchError((e){
      print(e);
    });
  }
  signOut(){
    FirebaseAuth.instance.signOut();
  }
  Future getPost() async {
    var firestore = Firestore.instance;
    QuerySnapshot gn = await firestore.collection('/news').getDocuments();
    return gn.documents;
  }
  Future<void> addNews(postData,context) async{
    List<String> user;
    Firestore.instance.collection('/news').add({
      'content': postData.post,
      'publisher': postData.publisher,
      'likedby': FieldValue.arrayUnion(user),
      'vote': 0,
    }).then((value){
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/homepage');
    }).catchError((e){
      print(e);
    });
  }

  Future<void> addEvents(eventData) async {
      Firestore.instance.collection('events').add(eventData).catchError((e) {
        print(e);
      });
  }

  getData() async {
    return await Firestore.instance.collection('events').getDocuments();
  }
  Future<String> getName(String _email) async {
    String userName;
    Firestore.instance.collection('/users').where('email', isEqualTo: _email)
        .snapshots()
        .listen((data) =>
        data.documents.forEach((doc) => userName = doc["displayName"]));
    return userName;
  }
}

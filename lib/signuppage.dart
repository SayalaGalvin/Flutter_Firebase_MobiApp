import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

//services
import 'services/usermanagement.dart';


class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //FirebaseMessaging _messaging = new FirebaseMessaging();
  bool _validate = false;
  String photoUrl = '';
  bool isLoading = false;
  File avatarImageFile;
  String Filepath;
  @override
  void initState(){
  }
  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
   // if (image != null) {
      setState(() {
        avatarImageFile = image;
      //  isLoading = true;
        Filepath = basename(avatarImageFile.path);
      });
 //   }
   // uploadFile();
  }
  String _email;
  String _password;
  String _nikename;
  String _uid;
  String url ='https://firebasestorage.googleapis.com/v0/b/rotaractproject-2e98e.appspot.com/o/photo-placeholder.jpeg?alt=media&token=6cb94738-b230-40f9-a83e-88e5ed2fa214';
  UserManagement _userManagement = new UserManagement();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: Container(
              padding: EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                      decoration: InputDecoration(hintText: 'Email',
                        errorText: _validate ? 'Value Can\'t Be Empty' : null,),
                      onChanged: (value) {
                        setState(() {
                          _email = value;
                        });
                      }
                      ),
                  SizedBox(height: 15.0),
                  TextField(
                      decoration: InputDecoration(hintText: 'Password (Use 6 Characters)',
                        errorText: _validate ? 'Value Can\'t Be Empty' : null,),
                      obscureText: true,
                      onChanged: (value) {
                        setState(() {
                          _password = value;
                        });
                      }),
                  SizedBox(height: 15.0),
                  /*TextField(
                      decoration: InputDecoration(hintText: 'Name',
                        errorText: _validate ? 'Value Can\'t Be Empty' : null,),
                      onChanged: (value) {
                        setState(() {
                          _nikename = value;
                        });
                      }),
                  SizedBox(height: 20.0),
                  Container(
                    child: avatarImageFile==null?
                    Image.asset('images/photo-placeholder.jpeg',height: 150,
                        width: 150,
                        fit: BoxFit.fitWidth):uploadArea(),
                  ),
                  SizedBox(height: 20.0,),
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.teal,
                    ),
                    onPressed: getImage,
                    padding: EdgeInsets.all(30.0),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.grey,
                    iconSize: 30.0,
                  ),*/
                  RaisedButton(
                    child: Text('Sign Up'),
                    color: Colors.teal,
                    textColor: Colors.white,
                    elevation: 7.0,
                    onPressed: () {
                      FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email,
                          password: _password).then((signedInUser) {
                                    Map<String, String> userDetails = {
                                    'displayName': this._nikename,
                                    'url': this.url,
                                      'email': this._email,
                                    };
                                    _userManagement.addData(userDetails, context).then((
                                    result) {}).catchError((e) {
                                    print(e);
                                    });
                                   /* _messaging.getToken().then((token){
                                      Firestore.instance.collection('pushtokens').add({
                                        'devtoken':token,
                                      }).then((value){
                                        print("Add token");
                                      }).catchError((e){
                                        print(e);
                                      });
                                    });*/
                                    Fluttertoast.showToast(msg: 'Member was saved',
                                    toastLength: Toast.LENGTH_SHORT,
                                    backgroundColor: Colors.blueAccent,
                                    textColor: Colors.black);
                        });
                      }
                  )])
                      )
                      ));
  }
/*  Future<String> uploadImage() async{
    StorageReference ref = FirebaseStorage.instance.ref().child(Filepath);
    StorageUploadTask uploadImage = ref.putFile(avatarImageFile);
    var downUrl = await (await uploadImage.onComplete).ref.getDownloadURL();
    url = downUrl.toString();
    print(url);
    return url;

  }
  Widget uploadArea(){
    return Column(
      children: <Widget>[
        Image.file(avatarImageFile,width: 100.0, height: 100.0,),
        RaisedButton(
          child: Text('Upload'),
          onPressed: uploadImage,
        )
      ],
    );
  }*/
}
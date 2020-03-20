import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/assets/const.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loginpage.dart';

class Settings extends StatelessWidget {
  Settings(this.email);
  final String email;


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Profile",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: Container(),
      ),
      body: new SettingsScreen('${email}'),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  SettingsScreen(this.email);
  final String email;

  @override
  State createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  TextEditingController controllerNickname;
  TextEditingController controllerMobile;
  bool _isTextFieldVisible = false;
  bool _isTextFieldVisible2 = false;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  void _trigger(){
    setState(() {
      _isTextFieldVisible = !_isTextFieldVisible;
    });
  }

  void _trigger2(){
    setState(() {
      _isTextFieldVisible2 = !_isTextFieldVisible2;
    });
  }

  SharedPreferences prefs;

  String id ='';
  String nickname ='';
  String mobile = '';
  String photoUrl='';
  bool isLoading = false;
  File avatarImageFile;

  final FocusNode focusNodeNickname = new FocusNode();
  final FocusNode focusNodeMobile = new FocusNode();

  @override
  void initState() {
    readLocal();
    _loadProfile();
    super.initState();

  }

  void rebuild() {
    setState(() {});
  }
  _loadProfile() async{

    setState(() {
      print('hi');
      Firestore.instance.collection('users').where('email',isEqualTo: widget.email).getDocuments().then((doc){
         nickname=doc.documents[0].data['displayName'];
         mobile = doc.documents[0].data['mobile'];
         id = doc.documents[0].documentID;
         photoUrl = doc.documents[0].data['url'];
      });
      print('done');
    });

}



  @override
  Widget build(BuildContext context) {
    print(nickname);
    return Stack(
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 10),
              Center(
                child: Text("Hi, "+ widget.email,style: TextStyle(fontSize: 18.0,fontWeight: FontWeight.bold)),
              ),
              Container(
                child: Center(
                  child: Stack(
                    children: <Widget>[
                      (avatarImageFile == null)
                          ? (photoUrl != ''
                          ? Material(
                        child: CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 2.0,
                              valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                            width: 90.0,
                            height: 90.0,
                            padding: EdgeInsets.all(20.0),
                          ),
                          imageUrl: photoUrl,
                          width: 90.0,
                          height: 90.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        clipBehavior: Clip.hardEdge,
                      )
                          : Icon(
                        Icons.account_circle,
                        size: 90.0,
                        color: greyColor,
                      ))
                          : Material(
                        child: Image.file(
                          avatarImageFile,
                          width: 90.0,
                          height: 90.0,
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(45.0)),
                        clipBehavior: Clip.hardEdge,
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.camera_alt,
                          color: primaryColor.withOpacity(0.5),
                        ),
                        onPressed: getImage,
                        padding: EdgeInsets.all(30.0),
                        splashColor: Colors.transparent,
                        highlightColor: greyColor,
                        iconSize: 30.0,
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                margin: EdgeInsets.all(20.0),
              ),

              // Input
              Column(
                children: <Widget>[
                  // Username
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                   child: new Row(
                     children: <Widget>[
                       Text('Edit Name: '+ nickname,style: TextStyle(fontSize: 16.0,)),
                       IconButton(
                         icon: Icon(Icons.edit),
                         padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                         alignment: Alignment.centerRight,
                         onPressed: _trigger,
                       )
                     ],
                   ),
                  ),
                  _isTextFieldVisible ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: nickname,
                        contentPadding: new EdgeInsets.all(5.0),
                        hintStyle: TextStyle(color: greyColor),
                      ),
                      controller: controllerNickname,
                      onChanged: (value) {
                        nickname = value;
                      },
                    ),
                  )
                      : SizedBox(),
                  SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: new Row(
                      children: <Widget>[
                        Text('Edit Mobile: '+mobile,style: TextStyle(fontSize: 16.0,)),
                        IconButton(
                          icon: Icon(Icons.edit),
                          padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                          alignment: Alignment.centerRight,
                          onPressed: _trigger2,
                        )
                      ],
                    ),
                  ),
                  _isTextFieldVisible2 ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: mobile,
                        contentPadding: new EdgeInsets.all(5.0),
                        hintStyle: TextStyle(color: greyColor),
                      ),
                      controller: controllerMobile,
                      onChanged: (value) {
                        mobile = value;
                      },
                    ),
                  )
                      : SizedBox(),
                  SizedBox(
                    height: 10.0,
                  ),

                ],
                crossAxisAlignment: CrossAxisAlignment.stretch,
              ),

              // Button
              Container(
                child: FlatButton(
                  onPressed: handleUpdateData,
                  child: Text(
                    'Update',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  color: Colors.teal,
                  textColor: Colors.white,
                ),
              ),
              Container(
                child: FlatButton(
                  onPressed:()=> resetPassword(widget.email),
                  child: Text(
                    'Change Password',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  color: Colors.teal,
                  textColor: Colors.white,
                ),
              ),
              Container(
                child: FlatButton(
                  onPressed: (){
                    FirebaseAuth.instance.signOut().whenComplete((){
                      Navigator.of(context).pushNamedAndRemoveUntil("/login", ModalRoute.withName("/setting"));
                    });
                  },
                  child: Text(
                    'Log Out',
                    style: TextStyle(fontSize: 20.0),
                  ),
                  color: Colors.teal,
                  textColor: Colors.white,
                ),
              ),
            ],
          ),
          padding: EdgeInsets.only(left: 15.0, right: 15.0),
        ),

        // Loading
        Positioned(
          child: isLoading
              ? Container(
            child: Center(
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
            ),
            color: Colors.white.withOpacity(0.8),
          )
              : Container(),
        ),
      ],
    );
  }
  @override
  Future<void> resetPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    Fluttertoast.showToast(msg: "Check Email",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.teal,
        textColor: Colors.white);
  }

  void readLocal() async {
    prefs = await SharedPreferences.getInstance();
    id = prefs.getString('id') ?? '';
    nickname = prefs.getString('nickname') ?? '';
    mobile = prefs.getString('mobile') ?? '';
    photoUrl = prefs.getString('photoUrl') ?? '';
    controllerNickname = new TextEditingController(text: nickname);
    controllerMobile = new TextEditingController(text: mobile);
    setState(() {});
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        avatarImageFile = image;
        isLoading = true;
      });
    }
    uploadFile();
  }

  Future uploadFile() async {
    String fileName = id;
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(avatarImageFile);
    StorageTaskSnapshot storageTaskSnapshot;
    uploadTask.onComplete.then((value) {
      if (value.error == null) {
        storageTaskSnapshot = value;
        storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
          photoUrl = downloadUrl;
          Firestore.instance
              .collection('users')
              .document(id)
              .updateData({'displayName': nickname, 'url': photoUrl,'mobile':mobile}).then((data) async {
            await prefs.setString('url', photoUrl);
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: "Upload success");
          }).catchError((err) {
            setState(() {
              isLoading = false;
            });
            Fluttertoast.showToast(msg: err.toString());
          });
        }, onError: (err) {
          setState(() {
            isLoading = false;
          });
          Fluttertoast.showToast(msg: 'This file is not an image');
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(msg: 'This file is not an image');
      }
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: err.toString());
    });
  }

  void handleUpdateData() {
    focusNodeNickname.unfocus();
    focusNodeMobile.unfocus();
    setState(() {
      isLoading = true;
    });

    Firestore.instance
        .collection('users')
        .document(id)
        .updateData({'displayName': nickname, 'url': photoUrl,'mobile':mobile}).then((data) async {
      await prefs.setString('displayName', nickname);
      await prefs.setString('url', photoUrl);
      await prefs.setString('mobile', mobile);
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Update success",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.teal,
          textColor: Colors.white);
    }).catchError((err) {
      setState(() {
        isLoading = false;
      });

      Fluttertoast.showToast(msg: "Updated");
    });
  }
}
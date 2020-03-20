import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

Timestamp date = Timestamp.now();

class addNewPost extends StatefulWidget{
  addNewPost(this._userEmail);
  final String _userEmail;
  @override
  _addNewPostState createState() => _addNewPostState();
}

class _addNewPostState extends State<addNewPost>{
  String _post;
  String _publisher;
  File avatarImageFile;
  String Filepath;
  String _attach = 'No Link';
  String _url = "https://firebasestorage.googleapis.com/v0/b/rotaractproject-2e98e.appspot.com/o/empty-image.png?alt=media&token=da21d57d-615e-4fb6-bc85-b1b89b952ae9";
  bool isLoading = false;
  Widget child;
  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      avatarImageFile = image;
      Filepath = basename(avatarImageFile.path);
    });
    // Image.asset('images/load.jpg');
  }
  Future<String> uploadImage() async{
    StorageReference ref = FirebaseStorage.instance.ref().child(Filepath);
    StorageUploadTask uploadImage = ref.putFile(avatarImageFile);
    var downUrl = await (await uploadImage.onComplete).ref.getDownloadURL();
    _url = downUrl.toString();
    Fluttertoast.showToast(msg: 'Uploaded Image',toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.teal,textColor: Colors.white);
    return _url;
  }
  Widget uploadArea(){
      return Column(
        children:<Widget>[
          Image.file(avatarImageFile,width: 150.0, height: 150.0,fit: BoxFit.fitWidth),
          RaisedButton(
            child: Icon(Icons.file_upload,color: Colors.teal,),
            onPressed: uploadImage,
          ),
        //  Text("wait for uploaded msg"),
        ],
      );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text("Publish Projects & Job Vacancies"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
      child:Container(
        padding: EdgeInsets.fromLTRB(20.0,15.0,20.0,0.0),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                  Container(
                    child: avatarImageFile==null?
                    Image.asset('images/empty-image.png',height: 150,
                      width: 150,
                      fit: BoxFit.fitWidth):uploadArea(),
                  ),
                SizedBox(width: 25.0,),
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
                  ),
              ],
            ),
            new Column(
              //  mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               TextField(
                    decoration: InputDecoration(hintText: 'Enter the Topic'),
                    onChanged: (value){
                      this._post=value;
                    },
                  ),
               SizedBox(height: 5.0,),
               TextField(
                      enableInteractiveSelection: true,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: InputDecoration(hintText: 'Enter the Content'),
                      onChanged: (value){
                        this._publisher=value;
                      },
                  ),
               SizedBox(height: 5.0,),
               TextField(
                 decoration: InputDecoration(hintText: 'Enter the URL or Link'),
                 onChanged: (value){
                   this._attach=value;
                 },
               ),

              ],

            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(width: 10.0,),
                RaisedButton(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.teal,
                    child: Text("Publish",style: TextStyle(color: Colors.white),),
                    onPressed:  () {
                    Firestore.instance.collection('/post').add({
                    'topic': _post,
                    'content': _publisher,
                    'vote': 0,
                    'likedby':[],
                    'url':_url,
                      'link': _attach,
                      'date&Time':DateTime.now(),

                    }).then((value){
                     Navigator.of(context).pop();
                    Fluttertoast.showToast(msg: 'Publish the Post', backgroundColor: Colors.teal, textColor: Colors.white, gravity: ToastGravity.BOTTOM
                    );
                    }).catchError((e){
                    print(e);
                    });}
              ),
                RaisedButton(
                    padding: EdgeInsets.all(10.0),
                    color: Colors.teal,
                    child: Text("Cancel",style: TextStyle(color: Colors.white),),
                    onPressed:  () {
                     Navigator.of(context).pop();
                    }
                )
              ],
            ),
          ],
        )
      ),
      ),
    );
  }
}

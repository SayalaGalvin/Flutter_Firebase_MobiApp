import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/services/usermanagement.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class signInPage extends StatefulWidget{
  static const popWithResultButtonKey = Key('popWithResult');
  @override
  _signInPageState createState() => _signInPageState();
}
class EmailFieldValidator{
  static String validate(String value){
    if(value.isEmpty)
      return 'Email cannot be empty';

    Pattern pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(value))
      return 'Enter Valid Email';

    return null;
    // return value.isEmpty ? 'Email cannot be empty' : null;
  }
}
class PasswordFieldValidator {
  static String validate(String value) {
    if(value.isEmpty)
      return 'Password cannot be empty';

    if(value.length<7){
      return 'Password must be more than 6 character';
    }

    return null;
    //return value.isEmpty ? 'Password cannot be empty' : null;
  }
}
class _signInPageState extends State<signInPage>{
  final _formKey = new GlobalKey<FormState>();
  String _email;
  String _mobile = 'non mobile';
  String _password;
  String _displayName;
  String _url = 'https://firebasestorage.googleapis.com/v0/b/rotaractproject-2e98e.appspot.com/o/photo-placeholder.jpeg?alt=media&token=6cb94738-b230-40f9-a83e-88e5ed2fa214';
  bool isLoading = false;
  File avatarImageFile;
  String Filepath;
  bool _obscureText = true;
  UserManagement _userManagement = new UserManagement();
  final FirebaseMessaging _msg = FirebaseMessaging();
  @override
  void initState(){
    _msg.getToken().then((token){
      Firestore.instance.collection('tokens').add({
        'devtoken':token,
      }).then((value){
        print("Add token");
      }).catchError((e){
        print(e);
      });
    });
  }

  void validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate())
    {
      form.save();
      FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email,
          password: _password).then((signedInUser) async {
        try {
          FirebaseAuth.instance.currentUser().then((user){
            user.sendEmailVerification();
          });
          Map<String, String> userDetails = {
            'displayName': this._displayName,
            'url': this._url,
            'email': this._email,
            'role': 'member',
            'mobile': this._mobile,
          };
          _userManagement.addData(userDetails, context).then((result) {})
              .catchError((e) {
            print(e);
          });

        } catch (e) {
          print("An error occured while trying to send email verification");
          print(e.message);
        }
        print('Form is valid');
        });
      Fluttertoast.showToast(msg: 'Verification Email Sent',
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.teal,
          textColor: Colors.white);


    }
    else
    {
      print('form is invalid');
    }
  }
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: Text('SignIn Page'),
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back), 
            onPressed: ()=>{Navigator.of(context).pop()}),
      ),
      body: new Container(
        padding: EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: EmailFieldValidator.validate,//value.isEmpty ? 'Email cannot be blank':null,
                  onSaved: (value) => _email = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password',suffixIcon:IconButton(
                      icon: IconButton(icon: Icon(Icons.remove_red_eye),onPressed: _toggle,
                        alignment: Alignment.bottomCenter,iconSize: 20,color: Colors.teal,)
                  ) ),
                  validator: PasswordFieldValidator.validate,//(value) => value.isEmpty ? 'Password cannot be blank':null,
                  onSaved: (value) => _password = value,
                  obscureText: _obscureText,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) => value.isEmpty ? 'Name cannot be blank':null,
                  onSaved: (value) => _displayName = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Mobile'),
                  validator: (value) => value.isEmpty ? 'Mobile cannot be blank':null,
                  onSaved: (value) => _mobile = value,
                ),
                SizedBox(height:10.0),
                /*Text("Profile Picture"),
                Container(
                  child: avatarImageFile==null?  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.teal,
                    ),
                    onPressed: getImage,
                    // padding: EdgeInsets.all(30.0),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.grey,
                    iconSize: 30.0,
                  ):uploadArea(),
                ),
                SizedBox(height:15.0),
                RaisedButton(
                  color: Colors.teal,
                  child: Icon(Icons.file_upload,color: Colors.white,),
                  onPressed: uploadImage,
                ),*/
                RaisedButton(
                  color: Colors.teal,
                  textColor: Colors.white,
                  child: Text ('Create', style: TextStyle(fontSize: 20.0),),
                  onPressed: validateAndSave,
                ),
                RaisedButton(
                    key: signInPage.popWithResultButtonKey,
                  color: Colors.teal,
                  textColor: Colors.white,
                  child: Text ('Cancel', style: TextStyle(fontSize: 20.0),),
                    onPressed: ()=>{Navigator.of(context).pop()}
                  ),
                ])
          ),
        ),
      );
  }
  /*Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      avatarImageFile = image;
      Filepath = basename(avatarImageFile.path);
    });
    // Image.asset('images/load.jpg');
  }
  Future<String> uploadImage() async{
    Fluttertoast.showToast(msg: 'Please wait',toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.teal,textColor: Colors.white);
    StorageReference ref = FirebaseStorage.instance.ref().child(Filepath);
    StorageUploadTask uploadImage = ref.putFile(avatarImageFile);
    var downUrl = await (await uploadImage.onComplete).ref.getDownloadURL();
    _url = downUrl.toString();
    print(_url);
    Fluttertoast.showToast(msg: 'Uploaded Image',toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.teal,textColor: Colors.white);
    return _url;
  }
  Widget uploadArea(){
    return Column(
      children:<Widget>[
        Image.file(avatarImageFile,width: 100.0, height: 100.0,fit: BoxFit.fitWidth),
        //  Text("wait for uploaded msg"),
      ],
    );
  }*/

}
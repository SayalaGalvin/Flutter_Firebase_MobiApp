import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_project/homepage.dart';
import 'package:flutter_project/services/signInPage.dart';
import 'package:flutter_project/userPage.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  static const navigateToDetailsButtonKey = Key('navigateToSignIn');
  @override
  _LoginPageState createState() => _LoginPageState();

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


class _LoginPageState extends State<LoginPage> {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final _formKey = new GlobalKey<FormState>();
  String newemail;
  String _email;
  String _password;
  static String displayUserName;
  String displayUserMobile;
  String displayUserUrl;
  bool _obscureText = true;
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  void validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate())
    {
      /*Fluttertoast.showToast(msg: "Please wait",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.teal,
          textColor: Colors.white);*/
      form.save();
      FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password).then((user) {
           displayUserName = user.user.displayName;
           displayUserMobile = user.user.phoneNumber;
           displayUserUrl = user.user.photoUrl;

        _firebaseAuth.currentUser().then((cuser) {
          if (cuser.isEmailVerified) {
            Firestore.instance.collection('/users')
                .where('email', isEqualTo: user.user.email)
                .getDocuments()
                .then((docs) {
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text("Waiting For Logging"),
              ));

              if (docs.documents[0].exists) {
                if (docs.documents[0].data['role'] == 'admin') {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => HomePage(user: user.user)));
                }
                else {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => userPage(user: user.user,)));
                }
              }
                else{
                print("banned");
                Fluttertoast.showToast(msg: "Banned",
                toastLength: Toast.LENGTH_SHORT,
                backgroundColor: Colors.teal,
                textColor: Colors.white);
                }});
          }
          else {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                // return object of type Dialog
                return AlertDialog(
                  title: new Text("Not A Verified Account"),
                  content: new Text(
                      "Please verify your account using the sent link"),
                  actions: <Widget>[
                    // usually buttons at the bottom of the dialog
                    new FlatButton(
                      child: new Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          }
        }).catchError((e) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              // return object of type Dialog
              return AlertDialog(
                title: new Text("Invalid Email or Password"),
                content: new Text(
                    "Please Check Your Email and Password Again."),
                actions: <Widget>[
                  // usually buttons at the bottom of the dialog
                  new FlatButton(
                    child: new Text("Close"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
      });
    }
    else
    {
      print('form is invalid');
    }
  }


  @override
  Widget build(BuildContext context) {
   return new Scaffold(
     appBar: new AppBar(
       title: Text('Rotaract Club Badulla',),
       centerTitle: true,
       backgroundColor: Colors.teal,
       leading: Container(),
     ),
     resizeToAvoidBottomPadding: false,
     body: new Container(
       padding: EdgeInsets.all(25.0),
         child: Form(
             key: _formKey,
             child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: <Widget>[
                   SizedBox(height: 75.0,),
                   TextFormField(
                     key: Key('emailfield'),
                     decoration: InputDecoration(labelText: 'Email'),
                     validator: EmailFieldValidator.validate,
                     //validator: (value) => value.isEmpty ? 'Email cannot be blank':null,
                     onSaved: (value) => _email = value,
                   ),
                   TextFormField(
                     key: Key('passwordfield'),
                     decoration: InputDecoration(labelText: 'Password',suffixIcon:IconButton(
                         icon: IconButton(icon: Icon(Icons.remove_red_eye),onPressed: _toggle,
                           alignment: Alignment.bottomCenter,iconSize: 20,color: Colors.teal,)
                     ) ),
                     validator: PasswordFieldValidator.validate, //(value) => value.isEmpty ? 'Password cannot be blank':null,
                     onSaved: (value) => _password = value,
                     obscureText: _obscureText,
                   ),
                   SizedBox(height: 10.0,),
                   RaisedButton(
                     key: Key('log'),
                     textColor: Colors.white,
                     color: Colors.teal,
                     child: Text ('Login', style: TextStyle(fontSize: 20.0),),
                     onPressed: validateAndSave,

                   ),
                   FlatButton(
                     key: LoginPage.navigateToDetailsButtonKey,
                     textColor: Colors.teal,
                     child: Text('Create An Account', style: TextStyle(fontSize: 15.0),),
                     onPressed: (){
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => signInPage()),
                       );
                     },
                   ),
                   FlatButton(
                     textColor: Colors.teal,
                     child: Text('Forget Password', style: TextStyle(fontSize: 15.0),),
                     onPressed: ()=>_displayDialog(context),
                   )
                 ]
             ),
         ),
   ),
   );
  }
  @override
  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Email Address'),
            content: TextField(
              onChanged: (value){
                newemail= value;
              },
              decoration: InputDecoration(hintText: "Email"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(onPressed:()=> resetPassword(newemail), child: new Text("Reset Password")),
            ],
          );
        });
  }
  Future<void> resetPassword(String email) async {
    print(email);
    await _firebaseAuth.sendPasswordResetEmail(email: email);
    Fluttertoast.showToast(msg: "Check Email",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.teal,
        textColor: Colors.white);
  }
}
import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/assets/const.dart';
import 'package:flutter_project/services/usermanagement.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ProfilePage extends StatefulWidget {
  ProfilePage(this._userEmail);
  final String _userEmail;
  @override
  State createState() => new SettingsScreenState();
}

class SettingsScreenState extends State<ProfilePage> {
  TextEditingController _controller = TextEditingController();
  DocumentSnapshot _currentDocument;

  _updateData() async {
    await db
        .collection('users')
        .document(_currentDocument.documentID)
        .updateData({'displayName': _controller.text});
  }

  final db = Firestore.instance;
  String userName;
  String url;
  File avatarImageFile;
  String _name;
  UserManagement userManage = new UserManagement();
  @override
  Widget _buildListItem (BuildContext context, DocumentSnapshot document) {
    return new Container(
      child: new Column(
        children: <Widget>[
          SizedBox(height: 25.0,),
          Container(
            child: CachedNetworkImage(
              imageUrl: document['url'],
              width: 100,
              height: 100,
              alignment: Alignment.topLeft,
            ),
          ),
          SizedBox(height: 25.0,),
          Container(
            alignment: Alignment.topLeft,
            child: Text('Display Name',),
          ),
          TextField(
              decoration: InputDecoration(
                hintText: document['displayName'],),
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              }
          ),
          SizedBox(height: 25.0,),
          RaisedButton(
            child: Text("Update"),
            onPressed: (){

            },
          ),
          SizedBox(height: 25.0,),
          RaisedButton(
            child: Text("Log Out"),
            onPressed: (){
                userManage.signOut;
                Navigator.pushNamed(context, '/login');
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(12.0),
    children: <Widget>[
      SizedBox(height: 25.0,),
    SizedBox(height: 20.0),
    StreamBuilder<QuerySnapshot>(
    stream: db.collection('users').where('email',isEqualTo: widget._userEmail).snapshots(),
    builder: (context, snapshot) {
    if (snapshot.hasData) {
    return Column(
    children: snapshot.data.documents.map((doc) {
    return ListTile(
    title: Text(doc.data['displayName'] ?? 'nil'),
    trailing: RaisedButton(
    child: Text("Edit"),
    color: Colors.red,
    onPressed: () async {
    setState(() {
    _currentDocument = doc;
    _controller.text = doc.data['displayName'];
    });
    },
    ),
    );
    }).toList(),
    );
    } else {
    return SizedBox();
    }
    }),
    Padding(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'Display Name'),
      ),
    ),
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: Text('Update'),
        color: Colors.red,
        onPressed: _updateData,
      ),
    ),
    ],),
    );}
}

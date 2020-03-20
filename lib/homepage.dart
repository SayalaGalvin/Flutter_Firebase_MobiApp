import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/chatpage.dart';
import 'package:flutter_project/loginpage.dart';
import 'package:flutter_project/profile.dart';
import 'package:flutter_project/settings.dart';
import 'package:flutter_project/assets/profilepage.dart';
import 'package:flutter_project/userList.dart';
import 'dashboard.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key, @required this.user}) : super(key: key);

  final FirebaseUser user;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  final FirebaseMessaging _msg = FirebaseMessaging();

  TabController tabController;
  @override
  void initState(){
    super.initState();
    tabController = new TabController(length: 4, vsync: this);
    _msg.getToken().then((token){
      print("Toke"+token);

    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar:new Material(
        color: Colors.teal,
        child: TabBar(controller:tabController,
          tabs: <Widget>[
            new Tab(icon: Icon(Icons.home)),
            new Tab(icon: Icon(Icons.chat)),
           new Tab(icon: Icon(Icons.group)),
            new Tab(icon: Icon(Icons.person)),
          ],
        ),
      ) ,
      body: new TabBarView(
        controller: tabController,
        children: <Widget>[
          Dashboard('${widget.user.uid}','${widget.user.email}'),
          //LoginScreen(title: "RAC Chat Corner"),
          ChatPage('${widget.user.email}'),
          userList(),
          Settings('${widget.user.email}'),
        ],
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/chatpage.dart';
import 'package:flutter_project/settings.dart';
import 'package:flutter_project/userDashboard.dart';
import 'package:flutter_project/assets/profilepage.dart';
import 'dashboard.dart';

class userPage extends StatefulWidget {
  const userPage({Key key, @required this.user}) : super(key: key);
  final FirebaseUser user;

  @override
  _userPageState createState() => _userPageState();
}

class _userPageState extends State<userPage> with SingleTickerProviderStateMixin {
  String userName;
  TabController tabController;
  @override
  void initState(){
    super.initState();
    tabController = new TabController(length: 3, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
      return new Scaffold(
        bottomNavigationBar: new Material(
          color: Colors.teal,
          child: TabBar(controller: tabController,
            tabs: <Widget>[
              new Tab(icon: Icon(Icons.home)),
              new Tab(icon: Icon(Icons.chat)),
              //    new Tab(icon: Icon(Icons.group)),
              new Tab(icon: Icon(Icons.person)),
            ],
          ),
        ),
        body: new TabBarView(
          controller: tabController,
          children: <Widget>[
            userDashboard('${widget.user.uid}', '${widget.user.email}'),
            //LoginScreen(title: "RAC Chat Corner"),
            ChatPage('${widget.user.email}'),
            Settings('${widget.user.email}'),
          ],
        ),
      );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/PublishEventPage.dart';
import 'package:flutter_project/PublishPostPage.dart';
import 'package:flutter_project/staredPost.dart';
import 'package:flutter_project/userEventPage.dart';
import 'package:flutter_project/userlistPage.dart';

import 'EventPage.dart';
import 'listPage.dart';

class userDashboard extends StatefulWidget{
  userDashboard(this._userUid, this._userEmail);
  final String _userEmail;
  final String _userUid;
  @override
  _userDashboardPageState createState() => _userDashboardPageState();
}

class _userDashboardPageState extends State<userDashboard> with SingleTickerProviderStateMixin {

  @override
  Widget build (BuildContext context) {
    Firestore.instance.collection('users').where('email',isEqualTo: widget._userEmail).getDocuments().then((doc){

    });
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.teal,
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.toc)),
                Tab(icon: Icon(Icons.event_note))
              ],
            ),
            title: new Text(
              'Projects & Events',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              userListPage('${widget._userEmail}'),
              userEventPage('${widget._userEmail}'),
            ],
          ),
        ),
      ),
    );
  }
}
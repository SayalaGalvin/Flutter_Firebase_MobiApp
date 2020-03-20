import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/PublishEventPage.dart';
import 'package:flutter_project/PublishPostPage.dart';
import 'package:flutter_project/staredPost.dart';

class Dashboard extends StatefulWidget{
  Dashboard(this._userUid, this._userEmail);
  final String _userEmail;
  final String _userUid;
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<Dashboard> with SingleTickerProviderStateMixin {
  @override
  Widget build (BuildContext context) {
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
              PublishPostPage('${widget._userEmail}'),
              PublishEventPage('${widget._userEmail}'),
            ],
          ),
        ),
      ),
    );
  }
}
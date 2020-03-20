import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_project/commentscreen.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';


class userList extends StatefulWidget{
  @override
  _userListState createState()=> _userListState();
}

class _userListState extends State<userList>{

  bool isPostLiked = false;
  @override
  void initState(){
    super.initState();
  }


  @override
  Widget _buildListItem (BuildContext context, DocumentSnapshot document) {
    IconButton delete = new IconButton(
        icon: Icon(Icons.cancel, color: Colors.teal),
        onPressed: () async {
          print(document.documentID);
          Firestore.instance.collection("users").document(document.documentID).delete();

        });
    IconButton update = new IconButton(
        icon: Icon(Icons.update, color: Colors.teal),
        onPressed: () async {
          print(document.documentID);
          Firestore.instance.collection("users").document(document.documentID).updateData(
              {'role':'admin'}
          );
        });
    IconButton degrade = new IconButton(
        icon: Icon(Icons.settings_backup_restore, color: Colors.teal),
        onPressed: () async {
          print(document.documentID);
          Firestore.instance.collection("users").document(document.documentID).updateData(
              {'role':'member'}
          );
        });

    return new Card(
      child: new Column(
        children: <Widget>[
          new Flexible(
            child:Container(
              padding:EdgeInsets.all(10),
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(
                  document['url'] == null ? 'https://firebasestorage.googleapis.com/v0/b/rotaractproject-2e98e.appspot.com/o/empty-image.png?alt=media&token=da21d57d-615e-4fb6-bc85-b1b89b952ae9':document['url'],
                ),
                initialScale: PhotoViewComputedScale.contained,
                backgroundDecoration: BoxDecoration(color: Colors.transparent),
                basePosition: Alignment.topCenter,
                gaplessPlayback: false,

              ),
            ),),
          new Expanded(
            child: new Column(
              children: <Widget>[
                Container(
                  child:Text(document['displayName'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),
                  ),
                ),
                Container(
                  child:Text(
                    document['role'],style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                  child:Text(
                    document['mobile'],style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                  child:Text(
                    document['email'],style: TextStyle(fontSize: 16.0),
                  ),
                ),
                Container(
                  child: new Row(
                    children: <Widget>[
                      Container(
                        child: update,
                      ),
                      Container(
                        child: degrade,
                      ),
                      Container(
                        child: delete,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          //   SizedBox(height: 60.0,)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Registered Users"),
        centerTitle: true,
        backgroundColor: Colors.teal,
        leading: Container(),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('/users').snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Image.asset('images/load.gif'),
              );}
            return ListView.builder(
              itemExtent: 300.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }),
    );
  }


}
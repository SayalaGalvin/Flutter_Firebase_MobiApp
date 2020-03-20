import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/commentscreen.dart';
import 'package:intl/intl.dart';


class staredEvent extends StatefulWidget{
  staredEvent(this.email);
  final String email;
  @override
  _staredEventState createState()=> _staredEventState();
}

class _staredEventState extends State<staredEvent>{
  bool isPostLiked = false;
  @override
  void initState(){
    super.initState();
  }


  @override
  Widget _buildListItem (BuildContext context, DocumentSnapshot document) {
    var date = (document['date&Time']);
    List<String> users;
    Widget child;
    if (document['likedby'].contains('${widget.email}')) {
      IconButton Liked = new IconButton(
          icon: Icon(Icons.event_available,color: Colors.teal),
          onPressed: (){
            print("clicked");
            users = ['${widget.email}'];
            Firestore.instance.collection("events").document(document.documentID)
                .updateData({'vote': document['vote']-1});
            Firestore.instance.collection("events").document(document.documentID)
                .updateData({'likedby':  FieldValue.arrayRemove(users)});
          });
      isPostLiked = true;
      child = Liked;
    }

    return new Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: new Column(
              children: <Widget>[
                SizedBox(height:20.0),
                Container(
                  child:Text( "Event Title: " +
                      document['content'], style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height:5.0),
                Container(
                  child:Text( "Date: From "+
                      document['startDate']+" To "+document['endDate'],style: TextStyle(fontSize: 16,)
                  ),
                ),
                SizedBox(height:5.0),
                Container(
                  child:Text( "Time: From "+
                      document['startTime']+" To "+document['endTime'],style: TextStyle(fontSize: 16,)
                  ),
                ),
                SizedBox(height:5.0),
                Container(
                  child:Text((new DateFormat("yyyy-MM-dd").format(document['date&Time'].toDate()))+" "+(new DateFormat("hh:mm").format(document['date&Time'].toDate())),
                  ),
                ),
                Container(
                  child: new Row(
                    children: <Widget>[
                      Container(
                        child: child,
                      ),
                      Container(
                        child: Text(document['vote'].toString()),
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
        title: Text("My Events"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('/events').where('likedby', arrayContains:widget.email).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Image.asset('images/load.gif'),
              );}
            return ListView.builder(
              itemExtent: 180.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }),
    );
  }


}
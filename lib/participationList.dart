import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project/commentscreen.dart';
import 'package:intl/intl.dart';


class participationList extends StatefulWidget{
  participationList(this.email);
  final String email;
  @override
  _participationListState createState()=> _participationListState();
}

class _participationListState extends State<participationList>{
  TextEditingController _name = new TextEditingController();
  @override
  void initState(){
    super.initState();
  }


  @override
  Widget _buildListItem (BuildContext context, DocumentSnapshot document) {
    Future<List<dynamic>> getList() async {
      var firestore = Firestore.instance;
      DocumentReference docRef = firestore.collection('events').document(document.documentID);
      return docRef.get().then((datasnapshot) {
        if (datasnapshot.exists) {
          List<dynamic> info = datasnapshot.data['likedby'].toList();
          return info;
        }
      });
    }

    
    return new Card(
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new Expanded(
            child: new Column(
              children: <Widget>[
                SizedBox(height:20.0),
                Container(
                  child:Text( "Event Title: " +
                      document['content'], style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
                Container(
                  child:Text( "Count: " +
                      document['vote'].toString(), style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),),
                FutureBuilder(
                  future: getList(),
                  builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Center(
                        child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Container(
                                  alignment: Alignment.topLeft,
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                  child: Text((snapshot.data[index].toString()),style: TextStyle(fontSize: 14.0),),//snapshot data should dispaly in this text field
                                ),
                              );
                            }),
                      );
                    }
                  },
                ),
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
        title: Text("Participation Lists"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('/events').orderBy("startDate", descending: false).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Image.asset('images/load.gif'),
              );}
            return ListView.builder(
              itemExtent: 400,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }),
    );
  }


}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class EventPage extends StatefulWidget{
  EventPage(this._email);
  final String _email;

@override
_EventPageState createState()=> _EventPageState();

}

class _EventPageState extends State<EventPage> {


  bool isPostLiked = false;
  @override
  void initState(){
    super.initState();
  }


  @override
  Widget _buildListItem (BuildContext context, DocumentSnapshot document) {

    var date = (document['date&Time']);
    List<String> users;

    IconButton delete = new IconButton(
              icon: Icon(Icons.cancel, color: Colors.teal),
              onPressed: () async {
                print(document.documentID);
                Firestore.instance.collection("events").document(document.documentID).delete();
              });


    Widget child;
      if (document['likedby'].contains('${widget._email}')) {
        IconButton Liked = new IconButton(
            icon: Icon(Icons.event_available,color: Colors.teal),
            onPressed: (){
              print("clicked");
              users = ['${widget._email}'];
              Firestore.instance.collection("events").document(document.documentID)
                  .updateData({'vote': document['vote']-1});
              Firestore.instance.collection("events").document(document.documentID)
                  .updateData({'likedby':  FieldValue.arrayRemove(users)});
            });
        isPostLiked = true;
        child = Liked;
      } else {
        //child = Icon(Icons.favorite_border,color: Colors.teal);
        IconButton UnLiked = new IconButton(
            icon: Icon(Icons.event_busy,color: Colors.teal),
            onPressed: (){
              print("clicked");
              users = ['${widget._email}'];
              Firestore.instance.collection("events").document(document.documentID)
                  .updateData({'vote': document['vote']+1});
              Firestore.instance.collection("events").document(document.documentID)
                  .updateData({'likedby':  FieldValue.arrayUnion(users)});
            });
        isPostLiked = false;
        child = UnLiked;
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
                            Container(
                              child: delete,
                            )
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
      body:
      StreamBuilder(
          stream: Firestore.instance.collection('/events').orderBy("startDate", descending: false).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Image.asset('images/load.gif'),
              );}
            return ListView.builder(
              itemExtent: 180,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }),
    );
  }

}


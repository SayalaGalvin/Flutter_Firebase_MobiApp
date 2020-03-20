import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_project/commentscreen.dart';
import 'package:flutter_project/services/usermanagement.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';


class ListPage extends StatefulWidget{
  ListPage(this._userEmail);
  final String _userEmail;
  @override
  _ListPageState createState()=> _ListPageState();

}

class _ListPageState extends State<ListPage> {

  Widget delete;
  bool isPostLiked = false;
  @override
  void initState(){
    super.initState();
  }


  @override
  Widget _buildListItem (BuildContext context, DocumentSnapshot document) {
    var date = (document['date&Time']);
    List<String> users;
    _commentButtonPressed(){
      setState((){
        Navigator.push(context, MaterialPageRoute(builder:(context)=> CommentScreen(context,document.documentID,widget._userEmail)));
      });
    }

        IconButton delete = new IconButton(
            icon: Icon(Icons.cancel, color: Colors.teal),
            onPressed: () async {
              print(document.documentID);
              Firestore.instance.collection("post").document(document.documentID).delete();
            });

    IconButton comment = IconButton(
      iconSize: 35.0,
      icon: Icon(Icons.chat_bubble_outline,color: Colors.teal,size: 20,),
      onPressed: ()=> _commentButtonPressed(),
    );
    Widget child;
    if (document['likedby'].contains('${widget._userEmail}')) {
      IconButton Liked = new IconButton(
          icon: Icon(Icons.favorite,color: Colors.teal),
          onPressed: (){
              print("clicked");
              users = ['${widget._userEmail}'];
              Firestore.instance.collection("post").document(document.documentID)
                  .updateData({'vote': document['vote']-1});
              Firestore.instance.collection("post").document(document.documentID)
                  .updateData({'likedby':  FieldValue.arrayRemove(users)});
          });
      isPostLiked = true;
      child = Liked;
    } else {
      //child = Icon(Icons.favorite_border,color: Colors.teal);
      IconButton UnLiked = new IconButton(
          icon: Icon(Icons.favorite_border,color: Colors.teal),
          onPressed: (){
            print("clicked");
            users = ['${widget._userEmail}'];
            Firestore.instance.collection("post").document(document.documentID)
                .updateData({'vote': document['vote']+1});
            Firestore.instance.collection("post").document(document.documentID)
                .updateData({'likedby':  FieldValue.arrayUnion(users)});
          });
      isPostLiked = false;
      child = UnLiked;
    }

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
          child:Text(document['topic'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0),
           ),
            ),
          Container(
            child:Text(
              document['content'],style: TextStyle(fontSize: 16.0),
            ),
          ),
          Container(
              margin: EdgeInsets.all(5.0),
              child: Linkify(
                onOpen: (link_url) async {
                  if (await canLaunch(link_url.url)) {
                    await launch(link_url.url);
                  } else {
                    throw 'Could not launch $link_url';
                  }
                },
                text: document['link'],
                style: TextStyle(color: Colors.teal,fontWeight: FontWeight.bold, fontSize: 16.0),
              )
          ),
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
                  child: comment,
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
      body: StreamBuilder(
          stream: Firestore.instance.collection('/post').orderBy("date&Time", descending: true).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Image.asset('images/load.gif'),
              );}
            return ListView.builder(
              itemExtent: 500,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }),
    );
  }


}



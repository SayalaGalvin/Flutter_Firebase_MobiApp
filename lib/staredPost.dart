import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_project/commentscreen.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';


class staredPost extends StatefulWidget{
  staredPost(this.email);
  final String email;
  @override
 _staredPostState createState()=> _staredPostState();
}

class _staredPostState extends State<staredPost>{
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
        Navigator.push(context, MaterialPageRoute(builder:(context)=> CommentScreen(context,document.documentID,widget.email)));
      });
    }
    IconButton comment = IconButton(
      iconSize: 35.0,
      icon: Icon(Icons.chat_bubble_outline,color: Colors.teal,size: 20,),
      onPressed: ()=> _commentButtonPressed(),
    );

    Widget child;
    if (document['likedby'].contains('${widget.email}')) {
      IconButton Liked = new IconButton(
          icon: Icon(Icons.favorite,color: Colors.teal),
          onPressed: (){
            print("clicked");
            users = ['${widget.email}'];
            Firestore.instance.collection("post").document(document.documentID)
                .updateData({'vote': document['vote']-1});
            Firestore.instance.collection("post").document(document.documentID)
                .updateData({'likedby':  FieldValue.arrayRemove(users)});
          });
      isPostLiked = true;
      child = Liked;
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
        title: Text("Bookmarked Projects"),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection('/post').where('likedby', arrayContains:widget.email).snapshots(),
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(
                child: Image.asset('images/load.gif'),
              );}
            return ListView.builder(
              itemExtent: 500.0,
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) =>
                  _buildListItem(context, snapshot.data.documents[index]),
            );
          }),
    );
  }


}
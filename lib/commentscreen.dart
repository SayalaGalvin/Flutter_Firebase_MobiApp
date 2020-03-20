import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CommentScreen extends StatefulWidget {
  final String postId;
  final String email;
  const CommentScreen(document, this.postId,this.email);
  @override
  _CommentScreenState createState() => _CommentScreenState(
    postId: this.postId,
  );
}

class _CommentScreenState extends State<CommentScreen> {
  final String postId;
  final TextEditingController _commentController = TextEditingController();
  _CommentScreenState({this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          "Comments",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: buildPage(),
    );
  }

  Widget buildPage() {
    return Column(
      children: [
        Expanded(
          child:
          buildComments(),
        ),
        Divider(),
          new ListTile(
              title: new TextFormField(
                  controller: _commentController,
                  onFieldSubmitted: addComment,
                  decoration:
                  new InputDecoration.collapsed(hintText: "Type the Comment"),
                ),
              trailing: FlatButton(onPressed: (){addComment(_commentController.text);},child: Icon(Icons.send,color: Colors.teal,),),
            ),
      ],
    );

  }


  Widget buildComments() {
    return FutureBuilder<List<Comment>>(
        future: getComments(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Container(
                alignment: FractionalOffset.center,
                child: Image.asset("images/load.gif"));
          return ListView(
            children: snapshot.data,
          );
        });
  }

  Future<List<Comment>> getComments() async {
    List<Comment> comments = [];
    QuerySnapshot data = await Firestore.instance
        .collection("/post").document(postId)
        .collection("comments")
        .getDocuments();
    data.documents.forEach((DocumentSnapshot doc) {
      comments.add(Comment.fromDocument(doc));
    });
    return comments;
  }

  addComment(String comment) {
    Firestore.instance.collection('users').where('email',isEqualTo: widget.email).getDocuments().then((doc){
      _commentController.clear();
      Firestore.instance
          .collection("/post")
          .document(postId)
          .collection("comments")
          .add({
        "username": doc.documents[0].data['displayName'],
        "comment": comment,
        "timestamp": DateTime.now(),
      });
    });
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String comment;
  final Timestamp timestamp;

  Comment(
      {this.username,
        this.comment,
        this.timestamp,
      });

  factory Comment.fromDocument(DocumentSnapshot document) {
    return Comment(
      username: document['username'],
      comment: document["comment"],
      timestamp: document["timestamp"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
          ListTile(
              title: Text(comment),
              subtitle: new Row(
                children: <Widget>[
                  Text(username),
                  SizedBox(width: 20.0,),
                  Container(
                    child:Text((new DateFormat("yyyy-MM-dd").format(timestamp.toDate()))+" "+(new DateFormat("hh:mm").format(timestamp.toDate())),
                    ),
                  ),
                ],
              )
        ),
        Divider(),
      ],
    );
  }
}
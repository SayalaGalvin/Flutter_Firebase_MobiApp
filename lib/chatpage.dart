import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ChatPage extends StatefulWidget {
  ChatPage(this._email);
  final String _email;

  @override
  _ChatPageState createState() => new _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String url="https://firebasestorage.googleapis.com/v0/b/rotaractproject-2e98e.appspot.com/o/loading.gif?alt=media&token=1f573add-db42-41b0-b88f-af99384134ec";
  String c_url="https://firebasestorage.googleapis.com/v0/b/rotaractproject-2e98e.appspot.com/o/loading.gif?alt=media&token=1f573add-db42-41b0-b88f-af99384134ec";
  String name ="loading...";
  String c_name ="loading...";
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: Text('Chat Hub'),
          centerTitle: true,
          leading: new Container(),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: <Widget>[
              Flexible(
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection("chat_room")
                      .orderBy("created_at", descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) {
                        DocumentSnapshot document =
                        snapshot.data.documents[index];

                        bool isOwnMessage = false;
                        if (document['email']== widget._email) {
                            isOwnMessage = true;
                        }
                        return isOwnMessage
                            ? _ownMessage(
                            document['message'],document['email'],document['created_at'])
                            : _message(
                            document['message'],document['email'],document['created_at']);

                      },
                      itemCount: snapshot.data.documents.length,
                    );
                  },
                ),
              ),
              new Divider(height: 1.0),
              Container(
                margin: EdgeInsets.only(bottom: 20.0, right: 10.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    new Flexible(
                      child: new TextField(
                        autofocus: true,
                        controller: _controller,
                        onSubmitted: _handleSubmit,
                        decoration:
                        new InputDecoration.collapsed(hintText: "send message"),
                      ),
                    ),
                    new Container(
                      child: new IconButton(
                          icon: new Icon(
                            Icons.send,
                            color: Colors.teal,
                          ),
                          onPressed: () {
                            _handleSubmit(_controller.text);
                          }),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Widget _ownMessage(String message,String email,Timestamp date) {
    Firestore.instance.collection('users').where('email',isEqualTo: email).getDocuments().then((doc) {
      url = doc.documents[0].data['url'];
      name= doc.documents[0].data['displayName'];
    });
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 10.0,),
           // Text(name),
            Text(message),
            Text(new DateFormat("hh:mm").format(date.toDate())),
            Text(new DateFormat("yyyy-MM-dd").format(date.toDate())),
          ],
        ),
        Container(
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.scaleDown,
            width: 40,
            height: 40,
          ),
        ),
      ],
    );
  }

  Widget _message(String message,String email,Timestamp date) {
    Firestore.instance.collection('users').where('email',isEqualTo: email).getDocuments().then((doc) {
      c_url = doc.documents[0].data['url'];
      c_name= doc.documents[0].data['displayName'];
    });
    return Row(
      children: <Widget>[
        Container(
          child: CachedNetworkImage(
            imageUrl: c_url,
            fit: BoxFit.scaleDown,
            width: 40,
            height: 40,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10.0,),
            Text(c_name),
            Text(message),
            Text(new DateFormat("hh:mm").format(date.toDate())),
            Text(new DateFormat("yyyy-MM-dd").format(date.toDate())),
          ],
        )
      ],
    );
  }

  _handleSubmit(String message) {
    var now = new DateTime.now();
    _controller.text = "";
      var db = Firestore.instance;
      db.collection("chat_room").add({
      "email": widget._email,
      "message": message,
      "created_at": now,
    });
  }
}
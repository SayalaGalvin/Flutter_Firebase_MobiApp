import 'package:flutter/material.dart';
import 'package:flutter_project/addNewPost.dart';
import 'package:flutter_project/listPage.dart';
import 'package:flutter_project/staredPost.dart';
import 'package:unicorndial/unicorndial.dart';


class PublishPostPage extends StatefulWidget{
  PublishPostPage(this._userEmail);
  final String _userEmail;
  @override
  _PublishPostPageState createState() => _PublishPostPageState();
}

class _PublishPostPageState extends State<PublishPostPage> {

  bool isLoading = false;

  @override
  Widget build (BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Bookmarked Projects",
        currentButton: FloatingActionButton(
          heroTag: "bookmarked",
          backgroundColor: Colors.teal,
          mini: true,
          child: Icon(Icons.bookmark),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => staredPost('${widget._userEmail}')),
            );
            },
        )));

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Add Projects",
        currentButton: FloatingActionButton(
            heroTag: "addpost",
            backgroundColor: Colors.teal,
            mini: true,
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => addNewPost('${widget._userEmail}')),
              );
            },
        )));


    return new Scaffold(
      floatingActionButton: UnicornDialer(
          backgroundColor: Color.fromRGBO(255, 255, 255, 0.6),
          parentButtonBackground: Colors.teal,
          orientation: UnicornOrientation.VERTICAL,
          parentButton: Icon(Icons.settings),
          childButtons: childButtons),
      body: ListPage('${widget._userEmail}'),
    );
  }

}

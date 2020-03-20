import 'package:flutter/material.dart';
import 'package:flutter_project/EventPage.dart';
import 'package:flutter_project/addNewEvent.dart';
import 'package:flutter_project/addNewPost.dart';
import 'package:flutter_project/participationList.dart';
import 'package:flutter_project/staredEvent.dart';
import 'package:unicorndial/unicorndial.dart';

class PublishEventPage extends StatefulWidget{
  PublishEventPage(this._email);
  final String _email;

  @override
  _PublishEventPageState createState() => _PublishEventPageState();
}

class _PublishEventPageState extends State<PublishEventPage>{
  String _post;
  String _publisher;
  Future<bool> addDialog(BuildContext context) async{
    // set up the buttons
    Widget cancelButton = FlatButton(
        child: Text("Cancel"),
        onPressed:  () {
          Navigator.of(context, rootNavigator: true).pop();
        }

    );
    Widget continueButton = FlatButton(
      child: Text("Publish"),
      onPressed:  () {},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text('Publsih Post',style: TextStyle(fontSize: 20.0 )),
      content:
      TextField(
        decoration: InputDecoration(hintText: 'Enter the post'),
        onChanged: (value){
          this._post=value;
        },
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    return showDialog(context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  bool _isFavorited = true;
  int _favoriteCount = 41;
  @override
  Widget build (BuildContext context) {
    var childButtons = List<UnicornButton>();

    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "My Events",
        currentButton: FloatingActionButton(
          heroTag: "bookmarked",
          backgroundColor: Colors.teal,
          mini: true,
          child: Icon(Icons.bookmark),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => staredEvent('${widget._email}')),
            );
          },
        )));
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Participations",
        currentButton: FloatingActionButton(
          heroTag: "participations",
          backgroundColor: Colors.teal,
          mini: true,
          child: Icon(Icons.event_available),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => participationList('${widget._email}')),
            );
          },
        )));
    childButtons.add(UnicornButton(
        hasLabel: true,
        labelText: "Add Event",
        currentButton: FloatingActionButton(
          heroTag: "addevent",
          backgroundColor: Colors.teal,
          mini: true,
          child: Icon(Icons.add),
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => addNewEvent('${widget._email}')),
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
      body: EventPage('${widget._email}'),
    );
  }

}

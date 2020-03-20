import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

DateTime date = DateTime.now();

class addNewEvent extends StatefulWidget{
  addNewEvent(this.email);
  final String email;

  @override
  _addNewEventState createState() => _addNewEventState();
}

class _addNewEventState extends State<addNewEvent> {
  final f = new DateFormat('yyyy-MM-dd');
  String _post;
  File avatarImageFile;
  String Filepath;
  bool isLoading = false;
  Widget child;
  DateTime _date = new DateTime.now();
  DateTime _dateend = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  TimeOfDay _timeend = new TimeOfDay.now();

  Future<Null> _selectDate (BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(3000));
    if (picked != null && picked != _date) {
      setState(() {
        _date = picked;
      });
    }
  }
  Future<Null> _selectDateend (BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _dateend,
        firstDate: new DateTime(2016),
        lastDate: new DateTime(3000));
    if (picked != null && picked != _dateend) {
      setState(() {
        _dateend = picked;
      });
    }
  }
  Future<Null> _selectTime (BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: _time,
    );
    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }
  Future<Null> _selectTimeend (BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _timeend,
    );
    if (picked != null && picked != _timeend) {
      setState(() {
        _timeend = picked;
      });
    }
  }

  @override
  Widget build (BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: Text("Publish Events"),
          centerTitle: true,
          backgroundColor: Colors.teal,
        ),
        body: new Container(
            padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 0.0),
            child: new Column(
                children: <Widget>[
                  new Column(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'Title of the Event'),
                        onChanged: (value) {
                          this._post = value;
                        },
                      ),
                      SizedBox(height: 5.0,),
                      Container(
                        child: new Row(
                          children: <Widget>[
                            RaisedButton(
                                child: Text("Select Date (From)"),
                                onPressed: (){
                                  _selectDate(context);
                                }),
                            SizedBox(width: 5,),
                            RaisedButton(
                                child: Text("Select Date (To)"),
                                onPressed: (){
                                  _selectDateend(context);
                                }),
                          ],
                        ),
                      ),
                      Container(
                        child: new Row(
                          children: <Widget>[
                            Text("Date: "+f.format((_date)).toString()),
                            SizedBox(width: 30,),
                            Text("Date: "+f.format((_dateend)).toString()),
                          ],
                        ),
                      ),
                      Container(
                        child: new Row(
                          children: <Widget>[
                            RaisedButton(
                                child: Text("Select Time (From) "),
                                onPressed: (){
                                  _selectTime(context);
                                }),
                            SizedBox(width:5),
                            RaisedButton(
                                child: Text("Select Time (To) "),
                                onPressed: (){
                                  _selectTimeend(context);
                                }),
                          ],
                        ),
                      ),
                      Container(
                        child: new Row(
                          children: <Widget>[
                            Text("Time: "+_time.format(context).toString()),
                            SizedBox(width:30),
                            Text("Time: "+_timeend.format(context).toString()),
                          ],
                        ),
                      )
                    ],),
                  new Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 5.0,),
                        RaisedButton(
                            padding: EdgeInsets.all(5.0),
                            color: Colors.teal,
                            child: Text("Publish",
                              style: TextStyle(color: Colors.white,fontSize: 16),),
                            onPressed: () {
                              Firestore.instance.collection('/events').add({
                                'content': _post,
                                'startDate': f.format(_date),
                                'endDate': f.format(_dateend),
                                'startTime': _time.format(context),
                                'endTime': _timeend.format(context),
                                'vote': 0,
                                'likedby': [],
                                'date&Time':DateTime.now(),
                              }).then((value) {
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(msg: 'Event is Published',
                                    backgroundColor: Colors.teal,
                                    textColor: Colors.white,
                                    gravity: ToastGravity.BOTTOM
                                );
                              }).catchError((e) {
                                print(e);
                              });
                            }
                        ),
                        RaisedButton(
                        padding: EdgeInsets.all(5.0),
                          color: Colors.teal,
                          child: Text("Cancel",style: TextStyle(color: Colors.white,fontSize: 16),),
                          onPressed: (){
                          Navigator.of(context).pop();
                          },
                        )

                      ]),
                ])));
  }
}

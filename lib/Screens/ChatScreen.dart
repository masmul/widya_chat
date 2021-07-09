import 'dart:convert';
import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_skeleton/flutter_skeleton.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:flutter_chat_ui/Utils/Message.dart';
import 'package:dio/dio.dart';


class MyChatScreen extends StatefulWidget {
  const MyChatScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyChatState createState() => new _MyChatState();
}

class _MyChatState extends State<MyChatScreen> {
  final List<Message> _messages = <Message>[];

  // Create a text controller. We will use it to retrieve the current value
  // of the TextField!
  final _textController = TextEditingController();
  bool isLoading;


  @override
  Widget build(BuildContext context) {
    DateTime time = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(time);
    //getHttp();
    return new Scaffold(
        appBar: new AppBar(
          title: const Text(
            'Widya Edu Chat',
            style: TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
        body: new Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/wallpaper.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: new Container(
              child: new Column(
                children: <Widget>[
                  //Chat list
                 isLoading ?
              // card list skeleton
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height-150,
                    child:// card list skeleton
                    ListSkeleton(
                      style: SkeletonStyle(
                        theme: SkeletonTheme.Light,
                        isShowAvatar: true,
                        isCircleAvatar: true,
                        barCount: 5,
                      ),
                    ),
                  ) :
                 new Flexible(
                    child: new ListView.builder(
                      padding: new EdgeInsets.all(8.0),
                      reverse: true,
                      itemBuilder: (_, int index) => _messages[index],
                      itemCount: _messages.length,
                    ),
                  ),
                  new Divider(height: 1.0),
                  new Container(
                      decoration:
                          new BoxDecoration(color: Theme.of(context).cardColor),
                      child: new IconTheme(
                          data: new IconThemeData(
                              color: Theme.of(context).accentColor),
                          child: new Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2.0),
                            child: new Row(
                              children: <Widget>[
                                //left send button

                                new Container(
                                  width: 48.0,
                                  height: 48.0,
                                  child: new IconButton(
                                      icon: Image.asset(
                                          "assets/images/send_in.png"),
                                      onPressed: () => _sendMsg(
                                          _textController.text,
                                          'left',
                                          formattedDate)),
                                ),

                                //Enter Text message here
                                new Flexible(
                                  child: new TextField(
                                    controller: _textController,
                                    decoration: new InputDecoration.collapsed(
                                        hintText: "Enter message"),
                                  ),
                                ),
                              ],
                            ),
                          ))),
                ],
              ),
            )));
  }

  void getHttp() async {
    print("asdasdasdasdsad");
      setState(() {
        isLoading = true;
      });
      try {
      var response = await Dio().get('https://pinterinternet.com/wp-content/uploads/message_dataset.json');
      // Map<String, dynamic> user = jsonDecode(response.data);
      // var name = user["data"];
      var name = response.data["data"];
      //print(name);
      for (int i = 0; i < name.length; i++) {
        print(name[i]["body"]);
          var msg = name[i]["body"];
          var from = name[i]["from"];
          var timestamp = int.parse(name[i]["timestamp"]);


          DateTime time2 = DateTime.now();
          var date = new DateTime.fromMicrosecondsSinceEpoch(timestamp);
          DateTime time = DateTime.fromMicrosecondsSinceEpoch(timestamp);
        print(timestamp);
        print(date);
          print(time);
          print(time2);
          String formattedDate = DateFormat('yyyy-MM-dd hh:mm').format(time);




          Message message = new Message(
            msg: name[i]["body"] == null ? "" : name[i]["body"],
            direction: from == "A" ? "left" : "right",
            dateTime: formattedDate,
            type: name[i]["attachment"] == null ? "" : name[i]["attachment"],
          );
          setState(() {

            _messages.insert(0, message);
          });

      }
      setState(() {
       isLoading = false;
      });
      print(name);
    } catch (e) {
      print(e);
    }
  }


  void _sendMsg(String msg, String messageDirection, String date) {
    if (msg.length == 0) {
      Fluttertoast.showToast(
          msg: "Please Enter Message",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.blue);
    } else {
      _textController.clear();
      Message message = new Message(
        msg: msg,
        direction: messageDirection,
        dateTime: date,
      );
      setState(() {
        _messages.insert(0, message);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getHttp();
  }

  @override
  void dispose() {
    // Every listener should be canceled, the same should be done with this stream.
    // Clean up the controller when the Widget is disposed
    _textController.dispose();
    super.dispose();
  }
}

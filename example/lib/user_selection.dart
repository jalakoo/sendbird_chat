import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sendbird_user.dart';
import 'sendbird_model.dart';
import 'dart:async';
import 'package:focus_detector/focus_detector.dart';

class UserSelectionPage extends StatefulWidget {
  @override
  UserSelectionState createState() => new UserSelectionState();
}

class UserSelectionState extends State {
  TextEditingController _textFieldController = TextEditingController();
  Timer timer;

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final _sendbird = Provider.of<SendbirdModel>(context, listen: true);
    final _resumeDetectorKey = UniqueKey();

    return FocusDetector(
      key: _resumeDetectorKey,
      onFocusGained: () {
        timer = new Timer.periodic(Duration(seconds: 8), (timer) {
          _sendbird.refreshUsers();
        });
      },
      onFocusLost: () {
        timer.cancel();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Select a User")),
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _sendbird.users().length,
            itemBuilder: (BuildContext context, int index) {
              SendbirdUser user = _sendbird.users()[index];
              return Column(
                children: [_row(context, user, _sendbird)],
              );
            }),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _displayDialog(context, _sendbird);
            },
            child: Icon(Icons.add)),
      ),
    );
  }

  Widget _row(context, SendbirdUser user, SendbirdModel sendbird) {
    String uid = user.userId;
    return Dismissible(
      key: Key(user.userId),
      background: _delete(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        print('user_selection.dart: user delete requested: $uid');
        setState(() {
          sendbird.deleteUser(user);
        });
      },
      child: Card(
        child: ListTile(
          title: new Text(user.userId),
          onTap: () {
            print('user_selection.dart: user selected: $uid');
            sendbird.setUser(user);
            sendbird.refreshOpenChannels();
            Navigator.pushNamed(context, '/open_channel');
          },
        ),
      ),
    );
  }

  Widget _delete() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 20.0),
      color: Colors.red,
      child: const Icon(
        Icons.delete,
        color: Colors.white,
      ),
    );
  }

  _displayDialog(BuildContext context, SendbirdModel sendbird) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('New User ID'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "A name for the new user"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('SUBMIT'),
                onPressed: () {
                  sendbird.createUser(_textFieldController.text);
                  _textFieldController.text = "";
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

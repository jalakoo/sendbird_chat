import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'sendbird_model.dart';
import 'sendbird_channel.dart';

class OpenChannelSelectionPage extends StatefulWidget {
  @override
  OpenChannelState createState() => new OpenChannelState();
}

class OpenChannelState extends State {
  TextEditingController _textFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _sendbird = Provider.of<SendbirdModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: Text("Select an Open Group")),
      body: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: _sendbird.channels().length,
          itemBuilder: (BuildContext context, int index) {
            SendbirdChannel channel = _sendbird.channels()[index];
            return Column(
              children: [_row(context, channel, _sendbird)],
            );
          }),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _displayDialog(context, _sendbird);
          },
          child: Icon(Icons.add)),
    );
  }

  Widget _row(context, SendbirdChannel channel, SendbirdModel sendbird) {
    String uid = channel.name;
    return Dismissible(
      key: Key(uid),
      background: _delete(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        print('open_channel_selection.dart: channel delete requested: $uid');
        setState(() {
          sendbird.deleteOpenChannel(channel);
        });
      },
      child: Card(
        child: ListTile(
          title: new Text(channel.name),
          onTap: () {
            // print('open_channel_selection.dart: channel selected: $uid');
            sendbird.setChannel(channel);
            sendbird.refreshOpenChannelMessages();
            Navigator.pushNamed(context, '/chat');
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
                  sendbird.createOpenChannel(
                      _textFieldController.text, [sendbird.user()]);
                  _textFieldController.text = "";
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
}

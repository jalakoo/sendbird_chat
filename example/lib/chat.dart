import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:provider/provider.dart';
import 'sendbird_model.dart';
import 'sendbird_message.dart';
import 'sendbird_user.dart';
import 'dart:async';
import 'package:focus_detector/focus_detector.dart';

class ChatPage extends StatefulWidget {
  @override
  ChatState createState() => new ChatState();
}

class ChatState extends State {
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
        timer = new Timer.periodic(Duration(seconds: 1), (timer) {
          _sendbird.refreshOpenChannelMessages();
        });
      },
      onFocusLost: () {
        timer.cancel();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("${_sendbird.currentChannel.name}"),
        ),
        body: new DashChat(
          showUserAvatar: true,
          onPressAvatar: (ChatUser user) {
            print("OnPressAvatar: ${user.name}");
          },
          key: Key(_sendbird.channel().channelUrl.toString()),
          onSend: (ChatMessage message) async {
            setState(() {
              _sendbird.sendOpenChannelMessage(message.text);
            });
          },
          sendOnEnter: true,
          textInputAction: TextInputAction.send,
          messages: asDashChatMessages(_sendbird.messages()),
          user: asDashChatUser(_sendbird.user()),
          inputDecoration:
              InputDecoration.collapsed(hintText: "Add message here..."),
        ),
      ),
    );
  }

  asDashChatMessages(List<SendbirdMessage> messages) {
    // print('chat.dart: asDashChatMessages: messages: $messages');
    List<ChatMessage> result = new List<ChatMessage>();
    messages.forEach((message) => result.add(ChatMessage(
        text: message.message,
        user: ChatUser(
            name: message.user.nickname,
            uid: message.user.userId,
            avatar: message.user.profileUrl))));
    return result;
  }

  asDashChatUser(SendbirdUser user) {
    // print('chat.dart: asDashChatUser: user: $user');
    return ChatUser(
        name: user.nickname, uid: user.userId, avatar: user.profileUrl);
  }
}

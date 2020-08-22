import 'package:flutter/material.dart';
import 'package:dash_chat/dash_chat.dart';
import 'package:provider/provider.dart';
import 'sendbird_model.dart';
import 'sendbird_message.dart';
import 'sendbird_user.dart';

class ChatPage extends StatefulWidget {
  @override
  ChatState createState() => new ChatState();
}

class ChatState extends State {
  @override
  Widget build(BuildContext context) {
    final _sendbird = Provider.of<SendbirdModel>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
      ),
      body: new DashChat(
        showUserAvatar: true,
        onPressAvatar: (ChatUser user) {
          print("OnPressAvatar: ${user.name}");
        },
        key: Key(_sendbird.channel().channelUrl.toString()),
        onSend: (ChatMessage message) async {
          print('chat.dart: message to send: $message');
          setState(() {
            _sendbird.sendOpenChannelMessage(message.text);
          });
        },
        sendOnEnter: true,
        textInputAction: TextInputAction.send,
        // messages: this.messages,
        messages: asDashChatMessages(_sendbird.messages()),
        user: asDashChatUser(_sendbird.user()),
        inputDecoration:
            InputDecoration.collapsed(hintText: "Add message here..."),
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

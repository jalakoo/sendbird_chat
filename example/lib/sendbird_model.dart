import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sendbird_chat/sendbird_chat.dart';
import 'sendbird_channel.dart';
import 'sendbird_message.dart';
import 'sendbird_user.dart';

class SendbirdModel extends ChangeNotifier {
  SendbirdChat _chat;
  List<SendbirdUser> _users = new List<SendbirdUser>();
  List<SendbirdChannel> _openChannels = new List<SendbirdChannel>();
  SendbirdUser currentUser;
  SendbirdChannel currentChannel = new SendbirdChannel("", "", []);
  List<SendbirdMessage> _currentMessages = new List<SendbirdMessage>();

  void init(String appId, String token) async {
    this._chat = SendbirdChat(applicationId: appId, apiToken: token);
  }

  refreshUsers() async {
    // TODO: Error handling
    List currentUsers = await _chat.listUsers();
    List<SendbirdUser> newUsers = [];
    currentUsers.forEach((user) => newUsers.add(SendbirdUser.fromJson(user)));
    // TODO: Actually check content
    if (newUsers.length == _users.length) {
      print('sendbird_model.dart: refreshUsers: no change in users list.');
      return;
    }
    _users = newUsers;
    notifyListeners();
  }

  List<SendbirdUser> users() {
    // TODO: Cache
    return this._users;
  }

  Future createUser(String userId) async {
    await this._chat.createUser(userId);
    refreshUsers();
  }

  Future deleteUser(SendbirdUser user) async {
    this._users.remove(user);
    await this._chat.deleteUser(user.userId);
    refreshUsers();
  }

  refreshOpenChannels() async {
    List currentChannels = await _chat.listOpenChannels();
    List<SendbirdChannel> newChannels = [];
    currentChannels.forEach(
        (channel) => newChannels.add(SendbirdChannel.fromJson(channel)));
    // TODO: Actually check contents
    if (newChannels.length == _openChannels.length) {
      print('sendbird_model.dart: refreshOpenChannels: no change in channels');
      return;
    }
    _openChannels = newChannels;
    notifyListeners();
  }

  List<SendbirdChannel> channels() {
    // TODO: Cache
    return this._openChannels;
  }

  SendbirdChannel channel() {
    return this.currentChannel;
  }

  void setChannel(SendbirdChannel channel) {
    this._currentMessages.clear();
    this.currentChannel = channel;
  }

  Future createOpenChannel(String name, List<SendbirdUser> users) async {
    List<String> operators = [];
    users.forEach((user) => operators.add(user.userId));
    await this._chat.createOpenChannel(name: name, userIds: operators);
    refreshOpenChannels();
  }

  Future deleteOpenChannel(SendbirdChannel channel) async {
    this._openChannels.remove(channel);
    await this._chat.deleteOpenChannel(channel.channelUrl);
    refreshOpenChannels();
  }

  // MESSAGES
  Future<List<SendbirdMessage>> getOpenChannelMessages() async {
    String channelUrl = this.currentChannel.channelUrl;
    List messages = await this._chat.getOpenChannelMessages(channelUrl);
    List<SendbirdMessage> result = new List<SendbirdMessage>();
    if (messages.length > 0) {
      messages.forEach(
          (message) => {result.add(SendbirdMessage.fromJson(message))});
    }
    return result;
  }

  Future<void> refreshOpenChannelMessages() async {
    List<SendbirdMessage> newMessages = await getOpenChannelMessages();
    // TODO; Actually check message contents
    if (newMessages.length == this._currentMessages.length) {
      // No change, ignore.
      print(
          'sendbird_model.dart: refreshOpenChannelMessages: no change in messages');
      return;
    }
    this._currentMessages = newMessages;
    notifyListeners();
  }

  Future<void> sendOpenChannelMessage(String message) async {
    await this._chat.sendOpenChannelMessage(
        channelUrl: this.currentChannel.channelUrl,
        originUserId: this.currentUser.userId,
        message: message);
    List<SendbirdMessage> messages = await getOpenChannelMessages();
    this._currentMessages.clear();
    this._currentMessages = messages;
    notifyListeners();
  }

  List<SendbirdMessage> messages() {
    return this._currentMessages;
  }

  SendbirdUser user() {
    return this.currentUser;
  }

  void setUser(SendbirdUser user) {
    this.currentUser = user;
  }
}
